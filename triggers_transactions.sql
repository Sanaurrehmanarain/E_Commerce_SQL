-- file: triggers_transactions.sql

-- 1. DROP old triggers/procedures if they exist (Clean Start)
DROP TRIGGER IF EXISTS after_order_item_insert;
DROP PROCEDURE IF EXISTS place_order;

-- 2. CREATE TRIGGER: Automatically decrease stock
-- Logic: When a row is added to 'order_items', subtract the quantity from 'products'
DELIMITER $$

CREATE TRIGGER after_order_item_insert
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE products
    SET stock_quantity = stock_quantity - NEW.quantity
    WHERE product_id = NEW.product_id;
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE place_order(
    IN p_user_id INT,
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_payment_method VARCHAR(50)
)
BEGIN
    -- Variables to hold data
    DECLARE v_price DECIMAL(10,2);
    DECLARE v_stock INT;
    DECLARE v_order_id INT;

    -- ERROR HANDLING: If any error occurs, undo everything (Rollback)
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Transaction Failed: Rolled Back' AS status;
    END;

    -- Start the ACID Transaction
    START TRANSACTION;

    -- 1. Check Stock & Price
    SELECT price, stock_quantity INTO v_price, v_stock
    FROM products WHERE product_id = p_product_id;

    -- 2. Validate Stock
    IF v_stock < p_quantity THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Insufficient Stock';
    ELSE
        -- 3. Create the Order
        INSERT INTO orders (user_id, status, total_amount)
        VALUES (p_user_id, 'Completed', v_price * p_quantity);
        
        SET v_order_id = LAST_INSERT_ID();

        -- 4. Add Order Item (*** TRIGGER RUNS HERE AUTOMATICALLY ***)
        INSERT INTO order_items (order_id, product_id, quantity, unit_price)
        VALUES (v_order_id, p_product_id, p_quantity, v_price);

        -- 5. Process Payment
        INSERT INTO payments (order_id, amount, payment_method, status)
        VALUES (v_order_id, v_price * p_quantity, p_payment_method, 'Success');

        -- 6. Save Changes
        COMMIT;
        SELECT 'Success' AS status, v_order_id AS new_order_id;
    END IF;
END$$

DELIMITER ;


-- TEST 1: Check stock of Product #1 BEFORE purchase
SELECT product_name, stock_quantity FROM products WHERE product_id = 1;

-- TEST 2: Buy 5 units of Product #1 (User ID 1 is buying)
CALL place_order(1, 1, 5, 'Credit Card');

-- TEST 3: Check stock of Product #1 AFTER purchase (Should be 5 less)
SELECT product_name, stock_quantity FROM products WHERE product_id = 1;