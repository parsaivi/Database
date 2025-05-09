WITH CustomerTotalSpending AS (
    -- Calculate total spending for each customer
    SELECT 
        c.CustomerId,
        SUM(i.Total) AS TotalSpent
    FROM Customer c
    JOIN Invoice i ON c.CustomerId = i.CustomerId
    GROUP BY c.CustomerId
),
AboveAverageCustomers AS (
    -- Identify customers with above average spending
    SELECT 
        CustomerId
    FROM CustomerTotalSpending
    WHERE TotalSpent > (SELECT AVG(TotalSpent) FROM CustomerTotalSpending)
),
TrackPurchases AS (
    -- Get track purchase information for above average customers
    SELECT 
        t.TrackId,
        t.Name,
        COUNT(DISTINCT il.InvoiceId) AS PurchaseCount,
        COUNT(DISTINCT i.CustomerId) AS num_customers,
        SUM(il.UnitPrice * il.Quantity) AS total_revenue
    FROM Track t
    JOIN InvoiceLine il ON t.TrackId = il.TrackId
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    WHERE i.CustomerId IN (SELECT CustomerId FROM AboveAverageCustomers)
    GROUP BY t.TrackId, t.Name
)
-- Final result with tracks sorted by unique customer count
SELECT 
    TrackId,
    Name,
    num_customers,
    total_revenue
FROM TrackPurchases
ORDER BY num_customers DESC, total_revenue DESC;