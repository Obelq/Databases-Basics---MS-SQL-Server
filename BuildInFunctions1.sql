SELECT FirstName, LastName FROM Employees
WHERE SUBSTRING(FirstName, 1, 2) = 'Sa'

SELECT FirstName, LastName FROM Employees
WHERE LastName LIKE '%ei%'

SELECT FirstName FROM Employees
WHERE DepartmentID IN (3, 10) AND YEAR(HireDate) BETWEEN 1995 AND 2005

SELECT FirstName, LastName FROM Employees
WHERE JobTitle NOT LIKE '%engineer%'

SELECT Name FROM Towns
WHERE LEN(Name) IN (5,6)
ORDER BY Name

SELECT TownID, Name FROM Towns
WHERE Name LIKE '[mkbe]%'
ORDER BY Name

SELECT TownID, Name FROM Towns
WHERE Name NOT LIKE '[rbd]%'
ORDER BY Name

CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName, LastName FROM Employees
WHERE YEAR(HireDate) > 2000

SELECT FirstName, LastName FROM Employees
WHERE LEN(LastName) = 5