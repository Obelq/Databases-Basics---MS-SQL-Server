--Problem 15.	Employees Average Salaries
SELECT * INTO AvgSalaries FROM Employees
WHERE Salary > 30000;

DELETE FROM AvgSalaries
WHERE ManagerID = 42;

UPDATE AvgSalaries
	SET Salary += 5000
	WHERE DepartmentID = 1;

SELECT DepartmentID, AVG(Salary) AS AverageSalary FROM AvgSalaries
GROUP BY DepartmentID

--Problem 16.	Employees Maximum Salaries

SELECT DepartmentID, MAX(Salary) AS MaxSalary FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) < 30000 OR MAX(Salary) > 70000

--Problem 17.	Employees Count Salaries

SELECT COUNT(*) AS Count FROM Employees
WHERE ManagerID IS NULL
GROUP BY ManagerID

--Problem 18.	*3rd Highest Salary

