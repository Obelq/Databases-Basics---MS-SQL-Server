USE Bank
Go

CREATE TABLE DepositTypes
(
DepositTypeID INT PRIMARY KEY,
Name VARCHAR(20)
)

CREATE TABLE Deposits
(
DepositID INT PRIMARY KEY IDENTITY,
Amount Decimal(10,2),
StartDate DATE,
EndDate DATE,
DepositTypeID INT,
CustomerID INT,
CONSTRAINT FK_Deposits_DepositTypes FOREIGN KEY(DepositTypeID)
REFERENCES DepositTypes(DepositTypeID),
CONSTRAINT FK_Deposits_Customers FOREIGN KEY(CustomerID)
REFERENCES Customers(CustomerID)
)

CREATE TABLE EmployeesDeposits
(
EmployeeID INT,
DepositID INT,
CONSTRAINT PK_EmployeeID_DepositID PRIMARY KEY(EmployeeID, DepositID),
CONSTRAINT FK_EmployeesDeposits_Employees FOREIGN KEY(EmployeeID)
REFERENCES Employees(EmployeeID),
CONSTRAINT FK_EmployeesDeposits_Deposits FOREIGN KEY(DepositID)
REFERENCES Deposits(DepositID)
)

CREATE TABLE CreditHistory
(
CreditHistoryID INT PRIMARY KEY,
Mark CHAR(1),
StartDate DATE,
EndDate DATE,
CustomerID INT,
CONSTRAINT FK_CreditHistory_Customers FOREIGN KEY (CustomerID)
REFERENCES Customers(CustomerID)
)

CREATE TABLE Payments(
PaymentID INT PRIMARY KEY,
[Date] DATE,
Amount Decimal(10,2),
LoanID INT,
CONSTRAINT FK_Payments_Loans FOREIGN KEY (LoanID)
REFERENCES Loans(LoanID)
)

CREATE TABLE Users(
UserID INT PRIMARY KEY,
UserName VARCHAR(20),
[Password] VARCHAR(20),
CustomerID INT UNIQUE,
CONSTRAINT FK_Users_Customers FOREIGN KEY (CustomerID)
REFERENCES Customers(CustomerID)
)

ALTER TABLE Employees
ADD ManagerID INT

ALTER TABLE Employees
ADD CONSTRAINT FK_Employees_Employees FOREIGN KEY (ManagerID)
REFERENCES Employees(EmployeeID)

-- Part 2
--

-- 2.1 Insert statements

INSERT INTO DepositTypes(DepositTypeID, Name)
VALUES(1, 'Time Deposit'), (2, 'Call Deposit'), (3, 'Free Deposit')

INSERT INTO Deposits(Amount, StartDate, EndDate, DepositTypeID, CustomerID)
SELECT (CASE
		WHEN c.DateOfBirth > '1980.01.01' THEN 1000
		ELSE 1500 END) +
		(CASE WHEN c.Gender = 'M' THEN 100
		ELSE 200 END) AS DepositAmount,
		GETDATE(),
		NULL AS EndDate,
		CASE WHEN c.CustomerID >15 THEN 3
			WHEN c.CustomerID % 2 = 0 THEN 2
			ELSE 1 END AS 'DepType',
		c.CustomerID
	FROM Customers AS c
	WHERE c.CustomerID < 20

INSERT INTO EmployeesDeposits(EmployeeID, DepositID)
VALUES(15, 4), (20, 15), (8, 7), (4, 8), (3, 13), (3, 8), (4, 10), (10, 1), (13, 4), (14, 9);

-- 2.2 Update Statements

UPDATE Employees
SET ManagerID =
CASE WHEN EmployeeID BETWEEN 2 AND 10 THEN 1
	WHEN EmployeeID BETWEEN 12 AND 20 THEN 11
	WHEN EmployeeID BETWEEN 22 AND 30 THEN 21
	WHEN EmployeeID IN (11, 21) THEN 1 END

-- 2.3 Delete Records

DELETE FROM EmployeesDeposits
WHERE DepositID = 9 OR EmployeeID = 3

-- Section 3 Querying

-- 1.	Employees’ Salary

SELECT EmployeeID, HireDate, Salary, BranchID FROM Employees
WHERE Salary > 2000 AND HireDate > '2009.06.15'

-- 2. Customer Age

SELECT c.FirstName, c.DateOfBirth, DATEDIFF(year,c.DateOfBirth, '2016.10.01') AS Age
FROM Customers AS c
WHERE DATEDIFF(year,c.DateOfBirth, '2016.10.01') BETWEEN 40 AND 50;

-- 3.	Customer City

SELECT c.CustomerID, c.FirstName, c.LastName, c.Gender, ci.CityName FROM Customers AS c
	JOIN Cities AS ci
		ON c.CityID = ci.CityID
	WHERE (c.LastName LIKE 'Bu%' OR c.FirstName LIKE '%a')
		AND LEN(ci.CityName) >=8
ORDER BY c.CustomerID;

-- 4.	Employee Accounts

SELECT TOP 5 e.EmployeeID, e.FirstName, a.AccountNumber FROM Employees AS e
	JOIN EmployeesAccounts as ea
		ON e.EmployeeID = ea.EmployeeID
	JOIN Accounts AS a
		ON ea.AccountID = a.AccountID
	WHERE YEAR(a.StartDate) >= 2012
ORDER BY e.FirstName DESC;

--5.	Employee Cities

SELECT c.CityName, b.Name, COUNT(*) AS EmployeesCount FROM Employees AS e
	JOIN Branches AS b
		ON e.BranchID = b.BranchID
	JOIN Cities AS c
		ON b.CityID = c.CityID
WHERE c.CityID NOT IN (4,5)
GROUP BY c.CityName, b.Name
HAVING COUNT(*) >= 3;

-- 6.	Loan Statistics

SELECT SUM(l.Amount) AS TotalLoanAmount, 
		MAX(l.Interest) AS MaxInterest, 
		MIN(e.Salary) AS MinEmployeeSalary FROM Employees AS e
	JOIN EmployeesLoans AS el
		ON e.EmployeeID = el.EmployeeID
	JOIN Loans AS l
		ON el.LoanID = l.LoanID;

-- 7.	Unite People

SELECT TOP 3 e.FirstName, c.CityName FROM Employees AS e
	JOIN Branches AS b
		ON e.BranchID = b.BranchID
	JOIN Cities AS c
		ON b.CityID = c.CityID;

SELECT TOP 3 cu.FirstName, c.CityName FROM Customers AS cu
	JOIN Cities AS c
		ON cu.CityID = c.CityID;

-- 8.	Customers without Accounts

SELECT c.CustomerID, c.Height FROM Accounts AS a
	RIGHT JOIN Customers AS c
		ON a.CustomerID = c.CustomerID
	WHERE a.AccountID IS NULL AND c.Height BETWEEN 1.74 AND 2.04;

-- 9.	Customers without Accounts


SELECT TOP 5 l.CustomerID,l.Amount FROM Loans AS l
	JOIN Customers AS c
		ON l.CustomerID = c.CustomerID
	WHERE l.Amount > (
	SELECT AVG(Amount) FROM Loans AS ol
		JOIN Customers AS oc
			ON ol.CustomerID = oc.CustomerID
		WHERE oc.Gender = 'M')
ORDER BY c.LastName;

-- 10.	Oldest Account

SELECT TOP 1 c.CustomerID, c.FirstName, a.StartDate FROM Customers AS c
	JOIN Accounts AS a
		ON c.CustomerID = a.CustomerID
ORDER BY a.StartDate;


-- Section 4. Programmability

-- 1.	String Joiner Function

CREATE FUNCTION udf_ConcatString(@FirstWord VARCHAR(MAX), @SecondWord VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @Result VARCHAR(MAX)
	SET @Result = CONCAT(REVERSE(@FirstWord), REVERSE(@SecondWord))
	RETURN @Result
END;

PRINT dbo.udf_ConcatString('abc','Rakiq');

--2.	Unexpired Loans Procedure

CREATE PROCEDURE usp_CustomersWithUnexpiredLoans(@CustomerID INT)
AS
BEGIN
	SELECT l.CustomerID, c.FirstName, LoanID FROM Loans AS l
	JOIN Customers AS c
		ON l.CustomerID = c.CustomerID
	WHERE l.ExpirationDate IS NULL AND l.CustomerID = @CustomerID
END

EXEC usp_CustomersWithUnexpiredLoans 9

-- 3.	Take Loan Procedure

CREATE PROCEDURE usp_TakeLoan(@CustomerID INT, @LoanAmount DECIMAL(18,2), @Interest DECIMAL(4,2), @StartDate DATE)
AS
BEGIN
	BEGIN TRAN

	INSERT INTO Loans(StartDate, Amount, Interest, CustomerID)
	VALUES(@StartDate, @LoanAmount, @Interest, @CustomerID)

	IF(@LoanAmount NOT BETWEEN 0.01 AND 100000)
	BEGIN
		RAISERROR('Invalid Loan Amount.', 16, 1)
		ROLLBACK
	END
	ELSE
		COMMIT

END

-- 4. Trigger Hire Employee

CREATE TRIGGER TR_HireEmployee
ON [dbo].[Employees]
AFTER INSERT
AS
BEGIN
	UPDATE [dbo].[EmployeesLoans]
	SET EmployeeID = i.EmployeeID
	FROM EmployeesLoans AS e
	JOIN inserted AS i
		ON e.EmployeeID + 1 = i.EmployeeID
END

-- Section 5. Bonus

-- 1.	Delete Trigger

CREATE TRIGGER tr_LogAccounts
ON [dbo].[Accounts]
INSTEAD OF DELETE
AS
BEGIN
	DELETE FROM [dbo].[EmployeesAccounts]
	WHERE AccountID IN (SELECT d.AccountID FROM deleted AS d)

	INSERT INTO [AccountLogs]
	SELECT * FROM deleted

	DELETE [dbo].[Accounts]
	WHERE AccountID IN (SELECT d.AccountID FROM deleted AS d)
END

