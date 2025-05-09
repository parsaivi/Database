WITH TopTeams AS (
    SELECT t.year, t.div_id, t.league_id, t.team_id, t.name
    FROM team t
    JOIN (
        SELECT year, div_id, league_id, MIN(rank) as min_rank
        FROM team
        GROUP BY year, div_id, league_id
    ) best ON t.year = best.year AND t.div_id = best.div_id 
           AND t.league_id = best.league_id AND t.rank = best.min_rank
)
SELECT tt.year, tt.div_id, tt.league_id, tt.team_id, tt.name,
       p.player_id, p.name_first, p.name_last
FROM TopTeams tt
JOIN batting b ON tt.team_id = b.team_id AND tt.year = b.year
JOIN player p ON b.player_id = p.player_id;