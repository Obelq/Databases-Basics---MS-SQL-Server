SELECT CountryName, IsoCode FROM Countries
WHERE CountryName LIKE '%a%a%a%'
ORDER BY IsoCode

SELECT PeakName, RiverName, 
LOWER(CONCAT(PeakName, SUBSTRING(RiverName, 2, LEN(RiverName)-1))) AS 'Mix'
FROM Peaks
JOIN Rivers
ON LEFT(RiverName, 1) = RIGHT(PeakName, 1)
ORDER BY Mix
