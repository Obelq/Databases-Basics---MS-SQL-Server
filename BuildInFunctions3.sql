SELECT TOP 50 Name, CONVERT(date, Start, 126) AS 'Start' FROM Games
WHERE YEAR(Start) IN (2011, 2012)
ORDER BY Start, Name

SELECT Username, SUBSTRING(Email, CHARINDEX('@', Email) + 1, 50) AS 'Email Provider'
FROM Users
ORDER BY 'Email Provider', Username

SELECT Username, IpAddress FROM Users
WHERE IpAddress LIKE '___.1%.%.___'
ORDER BY Username

SELECT * FROM Games
ORDER BY Name

SELECT Name AS 'Game',
CASE
	WHEN DATEPART(HOUR, Start) < 12 THEN 'Morning'
	WHEN DATEPART(HOUR, Start) < 18 THEN 'Afternoon'
	ELSE 'Evening'
END AS 'Part of the Day',
CASE
	WHEN Duration <= 3 THEN 'Extra Short'
	WHEN Duration <= 6 THEN 'Short'
	WHEN Duration > 6 THEN 'Long'
	WHEN Duration IS NULL THEN 'Extra Long'
END AS 'Duration'
FROM Games
ORDER BY 'Game', Duration, 'Part of the Day'