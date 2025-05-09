
SELECT 
    a.actor_id,
    a.name AS actor_name,
    count_countries_for_actor(a.actor_id) AS number_of_countries
FROM 
    actors a
ORDER BY 
    number_of_countries DESC;