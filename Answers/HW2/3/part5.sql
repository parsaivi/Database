SELECT 
	a.athlete_id,
    a.firstname,
    a.lastname,
    ROUND((julianday(e.start_date) - julianday(a.birthday)) / 365.25, 1) AS age_at_event
FROM 
    athletes a
JOIN 
    entries en ON a.athlete_id = en.athlete_id
JOIN 
    events e ON en.event_id = e.event_id
WHERE 
    en.final_rank = 1
    AND a.birthday IS NOT NULL
    AND e.start_date IS NOT NULL
ORDER BY 
    age_at_event ASC
LIMIT 1;