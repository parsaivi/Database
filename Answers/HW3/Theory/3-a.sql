CREATE VIEW order_summary AS
SELECT o.order_id, o.customer_id, o.order_date, 
       SUM(oi.quantity * oi.price) AS total_amount
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.customer_id, o.order_date;