WITH CustomerAverages AS (
    -- Calculate average invoice total for each customer
    SELECT 
        c.CustomerId,
        c.Country,
        AVG(i.Total) AS AvgInvoiceTotal
    FROM Customer c
    JOIN Invoice i ON c.CustomerId = i.CustomerId
    GROUP BY c.CustomerId, c.Country
),
CountryStats AS (
    -- Calculate statistics for each country
    SELECT 
        Country,
        COUNT(CustomerId) AS num_customers,
        AVG(AvgInvoiceTotal) AS avg_avg_invoicetotal
    FROM CustomerAverages
    GROUP BY Country
),
GlobalAverage AS (
    -- Calculate the global average of customers' average invoice totals
    SELECT AVG(AvgInvoiceTotal) AS GlobalAvgOfAvgs
    FROM CustomerAverages
)
-- Select countries meeting the criteria
SELECT 
    Country,
    num_customers,
    avg_avg_invoicetotal
FROM CountryStats
WHERE num_customers >= 2
  AND avg_avg_invoicetotal > (SELECT GlobalAvgOfAvgs FROM GlobalAverage)
ORDER BY avg_avg_invoicetotal DESC;