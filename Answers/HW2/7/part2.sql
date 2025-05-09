SELECT movie_id, title 
FROM movies
WHERE 
    (
        (LENGTH(title) - LENGTH(REPLACE(LOWER(title), 'batman', '')))/LENGTH('batman') +
        (LENGTH(title) - LENGTH(REPLACE(LOWER(title), 'gotham', '')))/LENGTH('gotham') +
        (LENGTH(summary) - LENGTH(REPLACE(LOWER(summary), 'batman', '')))/LENGTH('batman') +
        (LENGTH(summary) - LENGTH(REPLACE(LOWER(summary), 'gotham', '')))/LENGTH('gotham')
    ) >= 2;