SELECT 
    director,
    AVG(budget) AS average_budget
FROM 
    movies
GROUP BY 
    director
ORDER BY 
    average_budget DESC;