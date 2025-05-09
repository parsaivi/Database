SELECT 
  c.customer_id,
  c.Customer_Name,
  ts.Category,
  ts.purchase_count
FROM
  customers c
CROSS JOIN LATERAL(
  SELECT 
    s.Customer_ID AS id,
    s.Category,
    Count(s.Order_ID) AS purchase_count
  FROM 
    sales s
  WHERE
    s.Customer_ID = c.customer_id
  GROUP BY
    s.Category, s.Customer_ID
  ORDER BY 
    purchase_count DESC
  LIMIT 1
) AS ts
ORDER BY
  c.customer_id;
