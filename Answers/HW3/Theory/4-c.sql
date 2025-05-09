INSERT INTO MovieProd (title, year, pName)
SELECT title, year, 'Rox'
FROM Movie
WHERE producerID = 456;