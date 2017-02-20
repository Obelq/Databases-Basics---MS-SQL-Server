SELECT FirstName + '.' + LastName + '@softuni.bg' AS [Full Email Address]
FROM Employees

SELECT DISTINCT Salary FROM Employees ORDER BY Salary

SELECT * FROM Employees
WHERE JobTitle = 'Sales Representative'

SELECT FirstName, LastName, JobTitle FROM Employees
WHERE Salary BETWEEN 20000 AND 30000

SELECT FirstName + ISNULL(' ' + MiddleName, '') + ' ' + LastName AS [Full Name]
FROM Employees
WHERE Salary IN (25000, 14000, 12500, 23600)

SELECT FirstName, LastName FROM Employees
WHERE ManagerID IS NULL


SELECT FirstName, LastName, Salary FROM Employees
WHERE Salary > 50000
ORDER BY Salary DESC

SELECT TOP 5 * FROM Employees
ORDER BY Salary DESC


SELECT FirstName, LastName FROM Employees
WHERE DepartmentID != 4

SELECT * FROM Employees
ORDER BY Salary DESC, FirstName, LastName DESC, MiddleName

CREATE VIEW V_EmployeesSalaries AS
SELECT FirstName, LastName, Salary FROM Employees

CREATE VIEW V_EmployeeNameJobTitle AS
SELECT FirstName + ISNULL(' ' + MiddleName, '') + ' ' + LastName AS [Full Name], JobTitle AS [Job Title]
FROM Employees

SELECT DISTINCT JobTitle FROM Employees

SELECT TOP 10 * FROM Projects
ORDER BY StartDate, Name

SELECT TOP 7 FirstName, LastName, HireDate FROM Employees
ORDER BY HireDate DESC



UPDATE [Employees]
   SET [Salary] *= 1.12
 WHERE [DepartmentId] IN 
	(SELECT [DepartmentId] 
	   FROM [Departments]
	  WHERE [Name] IN 
		('Engineering', 'Tool Design', 'Marketing', 'Information Services'))
						
SELECT [Salary] 
  FROM [Employees]

