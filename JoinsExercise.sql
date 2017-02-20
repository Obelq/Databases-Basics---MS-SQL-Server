USE SoftUni
GO
-- Problem 1.	Employee Address

SELECT TOP 5 e.EmployeeID, e.JobTitle, e.AddressID, a.AddressText FROM Employees AS e
	INNER JOIN Addresses AS a
		ON e.AddressID = a.AddressID
ORDER BY e.AddressID;

-- Problem 2.	Addresses with Towns

SELECT TOP 50 e.FirstName, e.LastName, t.Name, a.AddressText FROM Employees as e
	INNER JOIN Addresses AS a
		ON e.AddressID = a.AddressID
	INNER JOIN Towns AS t
		ON a.TownID = t.TownID
ORDER BY e.FirstName, e.LastName;

-- Problem 3.	Sales Employee

SELECT e.EmployeeID, e.FirstName, e.LastName, d.Name AS DepartmentName FROM Employees AS e
	INNER JOIN Departments AS d
		ON e.DepartmentID = d.DepartmentID
WHERE d.Name = 'Sales'
ORDER BY e.EmployeeID;

-- Problem 4.	Employee Departments

SELECT TOP 5 e.EmployeeID, e.FirstName, e.Salary, d.Name AS DepartmentName FROM Employees AS e
	INNER JOIN Departments AS d
		ON e.DepartmentID = d.DepartmentID
WHERE e.Salary > 15000
ORDER BY e.DepartmentID;

-- Problem 5.	Employees Without Project

SELECT TOP 3 e.EmployeeID, e.FirstName FROM Employees AS e
	LEFT OUTER JOIN EmployeesProjects AS ep
		ON e.EmployeeID = ep.EmployeeID
WHERE ep.EmployeeID IS NULL
ORDER BY e.EmployeeID;

-- Problem 6.	Employees Hired After

SELECT e.FirstName, e.LastName, e.HireDate, d.Name FROM Employees AS e
	INNER JOIN Departments AS d
		ON e.DepartmentID = d.DepartmentID
WHERE e.HireDate > '1/1/1999'
AND d.Name IN ('Sales', 'Finance');

-- Problem 7.	Employees with Project

SELECT TOP 5 e.EmployeeID, e.FirstName, p.Name AS ProjectName FROM Employees AS e
INNER JOIN EmployeesProjects AS ep
		ON e.EmployeeID = ep.EmployeeID
	INNER JOIN Projects AS p
		ON ep.ProjectID = p.ProjectID
	WHERE p.StartDate > Convert(datetime,'2002-08-13') AND p.EndDate IS NULL
ORDER BY e.EmployeeID;

-- Problem 8.	Employee 24

SELECT e.EmployeeID, e.FirstName, p.Name AS ProjectName FROM Employees AS e
	INNER JOIN EmployeesProjects AS ep
		ON e.EmployeeID = ep.EmployeeID
	LEFT JOIN Projects AS p
		ON ep.ProjectID = p.ProjectID
	AND p.StartDate < '2005-01-01'
WHERE e.EmployeeID = 24;

-- Problem 9.	Employee Manager

SELECT e.EmployeeID, e.FirstName, e.ManagerID, m.FirstName FROM Employees AS e
JOIN Employees AS m
ON e.ManagerID = m.EmployeeID
WHERE e.ManagerID IN (3, 7)
ORDER BY e.EmployeeID;

-- Problem 10.	Employee Summary


SELECT TOP 50 e.EmployeeID, 
		CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
		CONCAT(m.FirstName, ' ', m.LastName) AS ManagerName,
		d.Name AS DepartmentName
		FROM Employees AS e
	JOIN Employees AS m
	ON e.ManagerID = m.EmployeeID
	JOIN Departments AS d
	ON e.DepartmentID = d.DepartmentID
ORDER BY e.EmployeeID;

-- Problem 11.	Min Average Salary

SELECT MIN(AvgSalary) AS MinAverageSalary
FROM (SELECT e.DepartmentID, AVG(e.Salary) AS AvgSalary FROM Employees AS e
GROUP BY e.DepartmentID) AS av;


END
-- Problem 12.	Highest Peak in Bulgaria

USE Geography
GO

SELECT mc.CountryCode, m.MountainRange, p.PeakName, p.Elevation FROM Peaks AS p
	JOIN Mountains AS m
		ON p.MountainId = m.Id
	JOIN MountainsCountries as mc
		ON p.MountainId = mc.MountainId
	AND mc.CountryCode = 'BG'
	WHERE p.Elevation > 2835
ORDER BY p.Elevation DESC

-- Problem 13.	Count Mountain Ranges

SELECT mc.CountryCode, COUNT(*) AS MountainRanges FROM Mountains AS m
	JOIN MountainsCountries AS mc
		ON m.Id = mc.MountainId
	WHERE mc.CountryCode IN ('BG', 'US', 'RU')
GROUP BY mc.CountryCode

-- Problem 14.	Countries with rivers

SELECT TOP 5 c.CountryName, r.RiverName FROM Countries AS c
	LEFT JOIN CountriesRivers as cr
		ON c.CountryCode = cr.CountryCode
	LEFT JOIN Rivers AS r
		ON cr.RiverId = r.Id
	WHERE c.ContinentCode = 'AF'
ORDER BY c.CountryName;

-- Problem 15.	*Continents and Currencies
SELECT * FROM Countries AS nc
JOIN
(SELECT cc.ContinentCode, MAX(cc.CurrUsage) AS CurrencyUsage FROM
(SELECT c.ContinentCode, c.CurrencyCode, COUNT(CurrencyCode) AS CurrUsage FROM Countries AS c
GROUP BY c.ContinentCode, c.CurrencyCode) AS cc
GROUP BY cc.ContinentCode) AS ccc
ON ccc.ContinentCode = nc.CountryCode
WHERE ccc.ContinentCode = 
ORDER BY ccc.ContinentCode

--Problem 16.	Countries Without any Mountains

SELECT COUNT(*) AS CountryCode FROM Countries as c
LEFT JOIN MountainsCountries AS mc
ON c.CountryCode = mc.CountryCode
WHERE mc.MountainId IS NULL

-- Problem 17.	Highest Peak and Longest River by Country
USE Geography
GO

SELECT TOP 5 pe.CountryName , pe.HighestPeakElevation, rl.LongestRiverLength FROM
(SELECT c.CountryName, MAX(p.Elevation) AS HighestPeakElevation FROM Countries AS c
	LEFT JOIN MountainsCountries AS mc
		ON c.CountryCode = mc.CountryCode
	LEFT JOIN Mountains AS m
		ON mc.MountainId = m.Id
	LEFT JOIN Peaks AS p
		ON m.Id = p.MountainId
	GROUP BY c.CountryName) AS pe
	JOIN
(SELECT c.CountryName, MAX(r.Length) AS LongestRiverLength FROM Countries AS c
	LEFT JOIN CountriesRivers AS cr
		ON c.CountryCode = cr.CountryCode
	LEFT JOIN Rivers AS r
		ON cr.RiverId = r.Id
	GROUP BY c.CountryName) AS rl
ON pe.CountryName = rl.CountryName
ORDER BY pe.HighestPeakElevation DESC, rl.LongestRiverLength DESC, pe.CountryName