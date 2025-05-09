SELECT m."referee", COUNT(*) AS totalcards
FROM world_cup_matches m
JOIN world_cup_players p ON m."matchid" = p."matchid"
WHERE p."event" LIKE 'R%' OR p."event" LIKE 'RSY%'
GROUP BY m."referee"
ORDER BY totalcards DESC;