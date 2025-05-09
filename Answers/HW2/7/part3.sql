CREATE FUNCTION count_countries_for_actor(p_actor_id INT)
RETURNS INT
BEGIN
    DECLARE country_count INT;
    
    SELECT COUNT(DISTINCT movies.countary) INTO country_count
    FROM actors
    JOIN act ON actors.actor_id = act.actor_id
    JOIN movies ON act.movie_id = movies.movie_id
    WHERE actors.actor_id = p_actor_id;
    
    RETURN country_count;
END;

SELECT count_countries_for_actor(123); -- به جای 123 شناسه بازیگر مورد نظر را قرار دهید