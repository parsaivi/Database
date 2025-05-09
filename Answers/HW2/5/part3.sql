WITH CustomerSpending AS (
    -- Calculate total spending for each customer
    SELECT 
        c.CustomerId,
        c.SupportRepId,
        SUM(i.Total) AS TotalSpent
    FROM Customer c
    JOIN Invoice i ON c.CustomerId = i.CustomerId
    GROUP BY c.CustomerId, c.SupportRepId
),
GlobalAverage AS (
    -- Calculate the global average spending per customer
    SELECT AVG(TotalSpent) AS AvgSpending
    FROM CustomerSpending
),
EmployeeCustomerStats AS (
    -- Calculate statistics for each employee's customers
    SELECT 
        e.EmployeeId,
        e.FirstName,
        e.LastName,
        COUNT(c.CustomerId) AS num_customers,
        AVG(cs.TotalSpent) AS avg_customer_spending
    FROM Employee e
    JOIN Customer c ON e.EmployeeId = c.SupportRepId
    JOIN CustomerSpending cs ON c.CustomerId = cs.CustomerId
    GROUP BY e.EmployeeId, e.FirstName, e.LastName
)
-- Select employees whose customers' average spending is above global average
SELECT 
    EmployeeId,
    FirstName,
    LastName,
    num_customers,
    avg_customer_spending
FROM EmployeeCustomerStats
WHERE avg_customer_spending > (SELECT AvgSpending FROM GlobalAverage)
ORDER BY avg_customer_spending DESC;