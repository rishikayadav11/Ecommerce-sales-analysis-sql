-- E-COMMERCE SALES ANALYSIS - 12 BUSINESS QUERIES
-- Author: Rishika Yadav
-- Database: ecommerce_db

-- Q1. Total Counts
SELECT (SELECT COUNT(*) FROM customers) as total_customers,
       (SELECT COUNT(*) FROM products) as total_products,
       (SELECT COUNT(*) FROM orders) as total_orders;

-- Q2. Orders by Status
SELECT status, COUNT(*) as count FROM orders GROUP BY status;

-- Q3. Customers City-wise
SELECT city, COUNT(*) as customer_count FROM customers GROUP BY city ORDER BY customer_count DESC;

-- Q4. Most Expensive Product
SELECT product_name, price FROM products ORDER BY price DESC LIMIT 1;

-- Q5. Total Revenue (Delivered Orders)
SELECT SUM(p.price * oi.quantity) as total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Delivered';

-- Q6. City-wise Revenue (Top City)
SELECT c.city, SUM(p.price * oi.quantity) as revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'Delivered'
GROUP BY c.city ORDER BY revenue DESC;

-- Q7. Top 5 Best-Selling Products by Quantity
SELECT p.product_name, SUM(oi.quantity) as total_sold
FROM products p JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_name ORDER BY total_sold DESC LIMIT 5;

-- Q8. Category-wise Profitability
SELECT p.category, SUM(p.price * oi.quantity) as revenue
FROM products p 
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Delivered'
GROUP BY p.category ORDER BY revenue DESC;

-- Q9. Repeat Customers
SELECT customer_id, COUNT(order_id) as order_count
FROM orders WHERE status='Delivered'
GROUP BY customer_id HAVING COUNT(order_id) > 1
ORDER BY order_count DESC;

-- Q10. Average Order Value (AOV)
SELECT SUM(p.price * oi.quantity) / COUNT(DISTINCT o.order_id) as AOV
FROM orders o 
JOIN order_items oi ON o.order_id=oi.order_id
JOIN products p ON oi.product_id=p.product_id
WHERE o.status='Delivered';

-- Q11. Monthly Sales Trend
SELECT MONTH(o.order_date) as month, SUM(p.price * oi.quantity) as monthly_revenue
FROM orders o 
JOIN order_items oi ON o.order_id=oi.order_id
JOIN products p ON oi.product_id=p.product_id
WHERE o.status='Delivered'
GROUP BY MONTH(o.order_date) ORDER BY month;

-- Q12. High-Value Customers (Spent > 100000) - Using CTE
WITH customer_spending AS (
  SELECT c.customer_id, c.customer_name, SUM(p.price * oi.quantity) as total_spent
  FROM customers c JOIN orders o ON c.customer_id=o.customer_id
  JOIN order_items oi ON o.order_id=oi.order_id
  JOIN products p ON oi.product_id=p.product_id
  WHERE o.status='Delivered'
  GROUP BY c.customer_id, c.customer_name
)
SELECT * FROM customer_spending WHERE total_spent > 100000 ORDER BY total_spent DESC;
