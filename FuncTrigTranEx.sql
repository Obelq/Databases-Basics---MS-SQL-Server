
-- Problem 1.	Employees with Salary Above 35000
CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
BEGIN
	SELECT FirstName, LastName FROM Employees
	WHERE Salary > 35000
END

-- Problem 2.	Employees with Salary Above Number

CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber (@Number MONEY)
AS
BEGIN
	SELECT FirstName, LastName FROM Employees
	WHERE Salary >= @Number
END

-- Problem 3.	Town Names Starting With

CREATE PROCEDURE usp_GetTownsStartingWith @prefix VARCHAR(MAX)
AS
SELECT [Name] FROM Towns
WHERE Name LIKE CONCAT(@prefix, '%')

-- Problem 4.	Employees from Town

CREATE PROCEDURE usp_GetEmployeesFromTown (@TownName VARCHAR(MAX))
AS
BEGIN
	SELECT FirstName, LastName FROM Employees AS e
		JOIN Addresses AS a
			ON e.AddressID = a.AddressID
		JOIN Towns AS t
			ON a.TownID = t.TownID
		WHERE t.Name = @TownName
END

-- Problem 5.	Salary Level Function

CREATE FUNCTION ufn_GetSalaryLevel (@Salary MONEY)
RETURNS NVARCHAR(10)
AS
BEGIN
	DECLARE @SalaryLevel NVARCHAR(10)
	IF(@Salary < 30000)
		SET @SalaryLevel = 'Low'
	ELSE IF(@Salary <= 50000)
		SET @SalaryLevel = 'Average'
	ELSE
		SET @SalaryLevel = 'High'
	RETURN @SalaryLevel
END

-- Problem 6.	Employees by Salary Level

CREATE PROCEDURE usp_EmployeesBySalaryLevel (@SalaryLvl NVARCHAR(10))
AS
BEGIN
	IF(@SalaryLvl = 'Low')
		BEGIN
			SELECT FirstName, LastName FROM Employees
				WHERE Salary < 30000
		END
	ELSE IF(@SalaryLvl = 'Average')
		BEGIN
			SELECT FirstName, LastName FROM Employees
				WHERE Salary <= 50000 AND Salary > 30000
		END
	ELSE
		BEGIN
			SELECT FirstName, LastName FROM Employees
			WHERE Salary > 50000
		END
END

EXEC usp_EmployeesBySalaryLevel 'High'

-- Problem 7.	Define Function

CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(50), @word VARCHAR(50))
RETURNS BIT
AS
BEGIN
    DECLARE @lettersSet AS VARCHAR(50)
    DECLARE @givenWord AS VARCHAR(50)
    DECLARE @RESULT BIT
 
    SET @lettersSet = @setOfLetters
    SET @givenWord = @word
    SET @RESULT = 1
 
    DECLARE @cnt INT = 0;
    WHILE @cnt < LEN(@givenWord)
    BEGIN
        DECLARE @innerCnt INT = 0;
        DECLARE @letterFound BIT = 0
        WHILE @innerCnt < LEN(@lettersSet)
        BEGIN
            IF SUBSTRING(@lettersSet, @innerCnt + 1, 1) = SUBSTRING(@givenWord, @cnt + 1, 1)
            BEGIN
                SET @letterFound = 1;
            END
            SET @innerCnt += 1
        END
        IF @letterFound = 0
        BEGIN
            SET @RESULT = 0
        END
        SET @cnt += 1;
    END
    RETURN @RESULT
END

-- Problem 9.	Employees with Three Projects

CREATE PROCEDURE usp_AssignProject(@emloyeeId INT, @projectID INT)
AS
BEGIN
	DECLARE @MaxProjects INT
	DECLARE @EmpProjects INT
	SET @MaxProjects = 3
	
	BEGIN TRAN

	INSERT INTO EmployeesProjects(EmployeeID, ProjectID)
	VALUES (@emloyeeId, @projectID)

	SET @EmpProjects = (SELECT COUNT(*) FROM EmployeesProjects AS ep
									WHERE ep.EmployeeID = @emloyeeId	)

	IF(@EmpProjects > @MaxProjects)
	BEGIN
		RAISERROR('The employee has too many projects!', 16, 1)
		ROLLBACK
	END
	ELSE
	BEGIN
		COMMIT
	END
END

EXEC usp_AssignProject 262, 20


----
----


-- Problem 10.	Find Full Name
USE Bank
GO

CREATE PROCEDURE usp_GetHoldersFullName
AS
BEGIN
	SELECT CONCAT(ah.FirstName,' ', ah.LastName) AS FullName FROM AccountHolders AS ah
		
END

-- Problem 11.	People with Balance Higher Than

CREATE PROCEDURE usp_GetHoldersWithBalanceHigherThan (@Number MONEY)
AS
BEGIN
	SELECT fl.FirstName, fl.LastName FROM
	(SELECT ah.FirstName, ah.LastName, SUM(a.Balance) AS TotalSum FROM AccountHolders AS ah
		JOIN Accounts AS a
			ON a.AccountHolderID = ah.Id
		GROUP BY ah.FirstName, ah.LastName
		HAVING SUM(a.Balance) > @Number) AS fl
END

-- Problem 12.	Future Value Function

CREATE FUNCTION ufn_CalculateFutureValue(@Sum MONEY, @InterestRate FLOAT, @Period INT)
RETURNS MONEY
AS
BEGIN
	DECLARE @Result MONEY
	SET @Result = @Sum*POWER((1 + @InterestRate), @Period)
	RETURN @Result
END

SELECT * FROM dbo.ufn_CalculateFutureValue (1000, 0.1, 5)

-- Problem 13.	Calculating Interest

CREATE PROCEDURE usp_CalculateFutureValueForAccount(@AccID INT, @IntRate FLOAT)
AS
BEGIN
	SELECT a.Id AS 'Account Id', ah.FirstName, 
		ah.LastName, a.Balance,
		dbo.ufn_CalculateFutureValue(a.Balance, @IntRate, 5) AS 'Balance in 5 years' 
		FROM AccountHolders AS ah
			JOIN Accounts AS a
				ON a.AccountHolderID = ah.Id
		WHERE a.Id = @AccID
END

EXEC usp_CalculateFutureValueForAccount 1, 0.1

-- Problem 14.	Deposit Money

CREATE PROCEDURE usp_DepositMoney(@AccountId INT , @moneyAmount MONEY) 
AS
BEGIN
	BEGIN TRAN
	
	UPDATE Accounts SET Balance = Balance + @moneyAmount
		WHERE Id = @AccountId

	IF @@ROWCOUNT <> 1
    BEGIN
        ROLLBACK
        RAISERROR('Invalid account!', 16, 1);
        RETURN
    END
	ELSE
		COMMIT
END

-- Problem 15.	Withdraw Money

CREATE PROCEDURE usp_WithdrawMoney(@AccountId INT, @moneyAmount MONEY)
AS
BEGIN
	BEGIN TRAN

	UPDATE Accounts SET Balance = Balance - @moneyAmount
		WHERE Id = @AccountId

	IF @@ROWCOUNT <> 1
    BEGIN
        ROLLBACK
        RAISERROR('Invalid account!', 16, 1);
        RETURN
    END
	ELSE
		COMMIT
END

-- Problem 16.	Money Transfer

CREATE PROCEDURE usp_TransferMoney(@senderId INT, @receiverId INT, @amount MONEY)
AS
BEGIN
	BEGIN TRAN

	EXEC usp_WithdrawMoney @senderID, @amount
	EXEC usp_DepositMoney @receiverId, @amount

	IF @@ROWCOUNT <> 0
    BEGIN
        ROLLBACK
        RAISERROR('Invalid account!', 16, 1);
        RETURN
    END
	ELSE IF((SELECT Balance FROM Accounts
	WHERE Id = @senderId) < 0)
	 BEGIN
        ROLLBACK
        RAISERROR('Insuficient amount!', 16, 1);
        RETURN
    END
	ELSE
		COMMIT
END
EXEC usp_TransferMoney 1, 2, 300

-- Problem 17.	Create Table Logs

CREATE TRIGGER tr_LogRecords
ON Accounts
AFTER UPDATE
AS
BEGIN
	INSERT INTO 
END