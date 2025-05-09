SELECT t.year, t.div_id, t.league_id, t.team_id, t.name
FROM team t
JOIN (
    SELECT year, div_id, league_id, MIN(rank) as min_rank
    FROM team
    GROUP BY year, div_id, league_id
) best ON t.year = best.year AND t.div_id = best.div_id 
       AND t.league_id = best.league_id AND t.rank = best.min_rank
ORDER BY t.team_id ASC;