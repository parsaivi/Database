INSERT INTO MovieProd (title, year, pName)
SELECT 'New DB', 1404, pName
FROM Producer
WHERE pID = 123;