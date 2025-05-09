SELECT 
    a.athlete_id,
    a.firstname,
    a.lastname,
    COUNT(DISTINCT e.discipline) AS unique_disciplines
FROM 
    athletes a
JOIN 
    entries e ON a.athlete_id = e.athlete_id
WHERE 
    e.final_rank = 1
GROUP BY 
    a.athlete_id, a.firstname, a.lastname
HAVING 
    COUNT(DISTINCT e.discipline) > 1
ORDER BY 
    unique_disciplines DESC;