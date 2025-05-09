SELECT year, COUNT(*) as count
FROM world_cup_matches
WHERE (
    -- Home team leading at halftime but Away team won
    ("Half-time Home Goals" > "Half-time Away Goals" AND "Home_Team_Goals" < "Away_Team_Goals")
    OR
    -- Away team leading at halftime but Home team won
    ("Half-time Home Goals" < "Half-time Away Goals" AND "Home_Team_Goals" > "Away_Team_Goals")
)
AND "win_conditions" NOT LIKE '%penalty%'
GROUP BY year
ORDER BY year;