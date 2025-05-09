SELECT 
    a.athlete_id, 
    a.lastname, 
    COUNT(*) AS gold_medals_count
FROM 
    athletes a
JOIN 
    entries e ON a.athlete_id = e.athlete_id
WHERE 
    e.final_rank = 1
GROUP BY 
    a.athlete_id, a.firstname, a.lastname, a.country
ORDER BY 
    gold_medals_count DESC
LIMIT 1;