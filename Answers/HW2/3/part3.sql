SELECT 
    a.country,
    COUNT(*) AS total_championships
FROM 
    athletes a
JOIN 
    entries e ON a.athlete_id = e.athlete_id
WHERE 
    e.final_rank = 1
GROUP BY 
    a.country
ORDER BY 
    total_championships DESC
LIMIT 1;