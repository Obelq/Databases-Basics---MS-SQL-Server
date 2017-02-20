SELECT COUNT(*) AS 'Count' FROM WizzardDeposits

SELECT MAX(MagicWandSize) AS 'LongestMagicWand' FROM WizzardDeposits

SELECT DepositGroup ,MAX(MagicWandSize) AS 'LongestMagicWand' FROM WizzardDeposits
GROUP BY DepositGroup

SELECT * FROM
(SELECT DepositGroup ,MIN(MagicWandSize) AS 'LongestMagicWand' FROM WizzardDeposits
GROUP BY DepositGroup) AS m

SELECT DepositGroup ,SUM(DepositAmount) AS 'TotalSum' FROM WizzardDeposits
GROUP BY DepositGroup

SELECT DepositGroup ,SUM(DepositAmount) AS 'TotalSum' FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup

SELECT DepositGroup ,SUM(DepositAmount) AS 'TotalSum' FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup
HAVING SUM(DepositAmount) < 150000
ORDER BY 'TotalSum' DESC

SELECT DepositGroup, MagicWandCreator AS [MagicWandCreator], MIN(DepositCharge) AS MinDepositCharge FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
ORDER BY MagicWandCreator, DepositGroup

SELECT AgeGroup, COUNT(AgeGroup) FROM
(SELECT *, CASE
	WHEN Age <= 10 THEN '[0-10]'
	WHEN Age <= 20 THEN '[11-20]'
	WHEN Age <= 30 THEN '[21-30]'
	WHEN Age <= 40 THEN '[31-40]'
	WHEN Age <= 50 THEN '[41-50]'
	WHEN Age <= 60 THEN '[51-60]'
	ELSE '[61+]'
	END AS 'AgeGroup'
	FROM WizzardDeposits) AS m
	GROUP BY AgeGroup

SELECT LEFT(FirstName, 1) AS 'FirstLetter' FROM WizzardDeposits
WHERE DepositGroup = 'Troll Chest'
GROUP BY LEFT(FirstName, 1)
ORDER BY 'FirstLetter'

SELECT DepositGroup, IsDepositExpired, AVG(DepositInterest) FROM WizzardDeposits
WHERE DepositStartDate > '1985-01-01'
GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired


SELECT * FROM WizzardDeposits
