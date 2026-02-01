-- 1. Monthly Revenue Growth (The most important chart)
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(order_id) AS total_orders,
    SUM(total_amount) AS total_revenue
FROM orders
WHERE status = 'Completed'
GROUP BY month
ORDER BY month;

-- 2. Top 3 Best-Selling Categories by Revenue
SELECT 
    c.category_name, 
    SUM(oi.quantity * oi.unit_price) AS category_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY category_revenue DESC
LIMIT 3;

-- 3. Average Order Value (AOV)
SELECT ROUND(AVG(total_amount), 2) AS avg_order_value
FROM orders
WHERE status = 'Completed';

-- 4. Daily Revenue Trend (Last 30 Days)
SELECT 
    DATE(order_date) AS date,
    SUM(total_amount) AS daily_revenue
FROM orders
WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
AND status = 'Completed'
GROUP BY date
ORDER BY date;

-- 5. Top 5 High-Value Customers (VIPs)
SELECT 
    u.first_name, 
    u.last_name, 
    COUNT(o.order_id) AS total_orders, 
    SUM(o.total_amount) AS lifetime_value
FROM users u
JOIN orders o ON u.user_id = o.user_id
WHERE o.status = 'Completed'
GROUP BY u.user_id
ORDER BY lifetime_value DESC
LIMIT 5;

-- 6. Customers Who Haven't Purchased in 6 Months (Churn Risk)
SELECT first_name, last_name, email
FROM users
WHERE user_id NOT IN (
    SELECT DISTINCT user_id 
    FROM orders 
    WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
);

-- 7. Customer Segmentation (FIXED)
SELECT 
    customer_tier,
    COUNT(*) AS customer_count
FROM (
    SELECT 
        user_id,
        CASE 
            WHEN SUM(total_amount) > 1000 THEN 'Gold'
            WHEN SUM(total_amount) BETWEEN 500 AND 1000 THEN 'Silver'
            ELSE 'Bronze'
        END AS customer_tier
    FROM orders
    WHERE status = 'Completed'
    GROUP BY user_id
) AS subquery
GROUP BY customer_tier;


-- 8. Low Stock Alert (Products with < 20 items)
SELECT product_name, stock_quantity 
FROM products 
WHERE stock_quantity < 20 
ORDER BY stock_quantity ASC;

-- 9. "Dead Stock" (Products never sold)
SELECT product_name 
FROM products 
WHERE product_id NOT IN (SELECT DISTINCT product_id FROM order_items);

-- 10. Top 5 Most Popular Products (by Quantity Sold)
SELECT 
    p.product_name, 
    SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 5;

-- 11. Payment Method Preferences
SELECT payment_method, COUNT(*) AS usage_count
FROM payments
WHERE status = 'Success'
GROUP BY payment_method;

-- 12. Monthly Revenue per User (ARPU)
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(total_amount) / COUNT(DISTINCT user_id) AS arpu
FROM orders
WHERE status = 'Completed'
GROUP BY month;

-- 13. Peak Shopping Hours (When do people buy?)
SELECT 
    HOUR(order_date) AS hour_of_day, 
    COUNT(order_id) AS order_count
FROM orders
GROUP BY hour_of_day
ORDER BY order_count DESC;

-- 14. Order Status Distribution (Operations Efficiency)
SELECT status, COUNT(*) AS count
FROM orders
GROUP BY status;

-- 15. The "Whale" Orders (Orders > Average Value)
SELECT order_id, total_amount 
FROM orders 
WHERE total_amount > (SELECT AVG(total_amount) FROM orders)
ORDER BY total_amount DESC
LIMIT 10;

-- 16. Monthly New User Signups (Growth Metric)
SELECT 
    DATE_FORMAT(created_at, '%Y-%m') AS month, 
    COUNT(user_id) AS new_users
FROM users
GROUP BY month
ORDER BY month;

-- 17. Total Inventory Value (Assets)
SELECT SUM(price * stock_quantity) AS total_inventory_value 
FROM products;

-- 18. Most Expensive Products
SELECT product_name, price 
FROM products 
ORDER BY price DESC 
LIMIT 5;

-- 19. Repeat Customers (Loyalty)
SELECT user_id, COUNT(order_id) AS purchase_count
FROM orders
GROUP BY user_id
HAVING purchase_count > 1;

-- 20. Average Quantity of Items per Order
SELECT AVG(quantity) AS avg_items_per_order
FROM order_items;