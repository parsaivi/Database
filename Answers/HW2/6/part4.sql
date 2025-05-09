SELECT wc."Country", wc."Year", 
       AVG(wcm."attendance")::integer AS avgparticipantspermatch
FROM "WorldCups" wc
JOIN world_cup_matches wcm ON wc."Year" = wcm.year
WHERE wcm."Home_Team_Name" = wc."Country" OR wcm."Away_Team_Name" = wc."Country"
GROUP BY wc."Country", wc."Year"
ORDER BY avgparticipantspermatch DESC;