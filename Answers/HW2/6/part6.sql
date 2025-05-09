SELECT 
    p."Player Name",
    m.year AS "Year",
    p."Team Initials",
    wc."Country",
    p."event"
FROM world_cup_players p
JOIN world_cup_matches m ON p."matchid" = m."matchid"
JOIN "WorldCups" wc ON m.year = wc."Year"
WHERE 
    -- Find matches where a team from the host country played
    ((m."Home_Team_Name" = wc."Country" AND p."Team Initials" = m."Home_Team_Initials")
    OR 
    (m."Away_Team_Name" = wc."Country" AND p."Team Initials" = m."Away_Team_Initials"))
    -- Filter for card events using LIKE
    AND (p."event" LIKE '%Y%' OR p."event" LIKE '%R%' OR p."event" LIKE '%RSY%')
ORDER BY m.year, p."Player Name";