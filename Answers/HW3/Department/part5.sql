CREATE MATERIALIZED VIEW mv_top_customers AS
SELECT 
    c.customer_id,
    COUNT(s.Order_ID) AS total_purchases,
    RANK() OVER (ORDER BY COUNT(s.Order_ID) DESC) AS rank
FROM 
    customers c
LEFT JOIN 
    sales s ON c.customer_id = s.customer_id
GROUP BY 
    c.customer_id;

SELECT 
    customer_id,
    total_purchases,
    rank
FROM 
    mv_top_customers
ORDER BY 
    rank
LIMIT 3;

