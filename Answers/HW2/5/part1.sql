WITH CustomerGenrePurchases AS (
    -- Calculate total spent on each genre by each customer
    SELECT 
        c.CustomerId,
        c.FirstName,
        c.LastName,
        g.Name AS GenreName,
        SUM(il.UnitPrice * il.Quantity) AS TotalSpent,
        COUNT(il.InvoiceLineId) AS PurchaseCount
    FROM Customer c
    JOIN Invoice i ON c.CustomerId = i.CustomerId
    JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
    JOIN Track t ON il.TrackId = t.TrackId
    JOIN Genre g ON t.GenreId = g.GenreId
    GROUP BY c.CustomerId, g.GenreId
),
FavoriteGenres AS (
    -- Identify favorite genre by purchase count
    SELECT 
        CustomerId,
        FirstName,
        LastName,
        GenreName AS favorite_genre,
        TotalSpent AS total_spent_on_favorite,
        PurchaseCount,
        ROW_NUMBER() OVER (PARTITION BY CustomerId ORDER BY PurchaseCount DESC, TotalSpent DESC) AS GenreRank
    FROM CustomerGenrePurchases
),
SpendingRank AS (
    -- Rank genres by spending for each customer
    SELECT 
        CustomerId,
        FirstName,
        LastName,
        GenreName,
        TotalSpent,
        ROW_NUMBER() OVER (PARTITION BY CustomerId ORDER BY TotalSpent DESC) AS SpendRank
    FROM CustomerGenrePurchases
)
-- Select customers where favorite genre matches top spending genre
SELECT 
    f.CustomerId,
    f.FirstName,
    f.LastName,
    f.favorite_genre,
    f.total_spent_on_favorite
FROM FavoriteGenres f
JOIN SpendingRank s ON 
    f.CustomerId = s.CustomerId AND 
    f.favorite_genre = s.GenreName AND 
    s.SpendRank = 1
WHERE f.GenreRank = 1
ORDER BY f.total_spent_on_favorite DESC;