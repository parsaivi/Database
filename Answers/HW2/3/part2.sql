WITH highest_qualification_scores AS (
    SELECT 
        e.event_id,
        MAX(e.qualification_score) AS max_score
    FROM 
        entries e
    GROUP BY 
        e.event_id
)
SELECT 
    ev.name AS event_name,
    a.lastname
FROM 
    entries en
JOIN 
    highest_qualification_scores h ON en.event_id = h.event_id 
    AND en.qualification_score = h.max_score
JOIN 
    athletes a ON en.athlete_id = a.athlete_id
JOIN 
    events ev ON en.event_id = ev.event_id
ORDER BY 
    ev.name;