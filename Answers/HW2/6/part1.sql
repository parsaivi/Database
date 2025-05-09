SELECT year, stage, "Home_Team_Name", "Home_Team_Goals", "Away_Team_Goals", "Away_Team_Name"
FROM world_cup_matches
WHERE ("Home_Team_Goals" + "Away_Team_Goals") > 5
ORDER BY year, stage;