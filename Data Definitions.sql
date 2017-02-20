INSERT INTO Towns
    (Id, Name)
VALUES
    (1 , 'Sofia'),
    (2 , 'Plovdiv'),
    (3 , 'Varna');
INSERT INTO Minions
    (Id, Name,Age,TownId)
VALUES
    (1 , 'Kevin', 15,1),
    (2 , 'Bob', 22,3),
    (3 , 'Steward', NULL, 2);
-- 14. Car Rental Database
CREATE TABLE Categories
(
Id INT IDENTITY NOT NULL,
Category NVARCHAR(20) NOT NULL,
DailyRate NUMERIC,
WeeklyRate NUMERIC,
MonthlyRate NUMERIC,
WeekendRate NUMERIC
CONSTRAINT PK_Categories PRIMARY KEY (Id)
);

CREATE TABLE Cars
(
Id INT IDENTITY NOT NULL,
PlateNumber NVARCHAR(8) NOT NULL,
Make NVARCHAR(20) NOT NULL,
Model NVARCHAR(20) NOT NULL,
CarYear INT,
CategoryId INT,
Doors INT,
Picture VARBINARY(MAX),
Condition NVARCHAR(20),
IsAvailable BIT
CONSTRAINT PK_Cars PRIMARY KEY (Id)
);

CREATE TABLE Employees
(
Id INT IDENTITY NOT NULL,
FirstName NVARCHAR(20) NOT NULL,
LastName NVARCHAR(20) NOT NULL,
Title NVARCHAR(20),
Notes NVARCHAR(200)
CONSTRAINT PK_Employees PRIMARY KEY (Id)
);

CREATE TABLE Customers
(
Id INT IDENTITY NOT NULL,
DriverLicenceNumber NVARCHAR(15) NOT NULL,
FullName NVARCHAR(100) NOT NULL,
Address NVARCHAR(500),
City NVARCHAR(50),
ZIPCode NVARCHAR(10),
Notes NVARCHAR(200)
CONSTRAINT PK_Customers PRIMARY KEY (Id)
);

CREATE TABLE RentalOrders
(
Id INT IDENTITY NOT NULL,
EmployeeId INT NOT NULL,
CustomerId INT NOT NULL,
CarId INT NOT NULL,
CarCondition NVARCHAR(20),
TankLevel NUMERIC(10,2),
KilometrageStart INT,
KilometrageEnd INT,
TotalKilometrage INT,
StartDate DATE,
EndDate DATE,
TotalDays INT,
RateApplied INT,
TaxRate NUMERIC,
OrderStatus NVARCHAR(10),
Notes NVARCHAR(200)
CONSTRAINT PK_RentalOrders PRIMARY KEY (Id)
);

INSERT INTO Categories (Category)
VALUES ('Car'), ('Truck'), ('Van');

INSERT INTO Cars (PlateNumber, Make, Model)
VALUES
('A1234AA', 'Opel', 'Omega'),
('A6542AB', 'Ford', 'Focus'),
('OB4444AP', 'Lada', 'Niva');

INSERT INTO Employees (FirstName, LastName)
VALUES
('Ivan', 'Ivanov'),
('Petar', 'Petrov'),
('Misha', 'Mishav');

INSERT INTO Customers (DriverLicenceNumber, FullName)
VALUES
('A12345', 'Ivan Ivanov Ivanov'),
('A12346', 'Ivan Ivanov Petrov'),
('A12342', 'Petar Ivanov Ivanov');

INSERT INTO RentalOrders (EmployeeId, CustomerId, CarId)
VALUES
(1, 2, 3),
(2, 3, 1),
(2, 2, 2);

SELECT COUNT(*) FROM Categories;
SELECT COUNT(*) FROM Cars;
SELECT COUNT(*) FROM Employees;
SELECT COUNT(*) FROM Customers;
SELECT COUNT(*) FROM RentalOrders;

--15. Hotel Database

CREATE TABLE Employees
 (
 Id INT PRIMARY KEY IDENTITY, 
 FirstName VARCHAR(50) NOT NULL, 
 LastName VARCHAR (50) NOT NULL, 
 Title VARCHAR(255), 
 Notes VARCHAR(max)
 );

 CREATE TABLE Customers
 (
 AccountNumber INT PRIMARY KEY, 
 FirstName VARCHAR(50) NOT NULL, 
 LastName VARCHAR(50) NOT NULL, 
 PhoneNumber NUMERIC NOT NULL, 
 EmergencyName VARCHAR(50), 
 EmergencyNumber NUMERIC, 
 Notes VARCHAR(max)
 );

 CREATE TABLE RoomStatus
  (
  RoomStatus VARCHAR(10), 
  Notes VARCHAR(max)
  CONSTRAINT PK_RoomStatus PRIMARY KEY(RoomStatus)
  );
  
 CREATE TABLE RoomTypes
   (
   RoomType VARCHAR(20), 
   Notes VARCHAR(max)
   CONSTRAINT PK_RoomType PRIMARY KEY (RoomType)
   );

 CREATE TABLE BedTypes
    (
	BedType VARCHAR(20), 
	Notes VARCHAR(max)
	CONSTRAINT PK_BedType PRIMARY KEY(BedType)
	);

CREATE TABLE Rooms
	 (
	 RoomNumber INT NOT NULL, 
	 RoomType VARCHAR(20) NOT NULL, 
	 BedType VARCHAR(20) NOT NULL, 
	 Rate NUMERIC, 
	 RoomStatus VARCHAR(10) NOT NULL, 
	 Notes VARCHAR(max)
	 CONSTRAINT PK_RoomNumber PRIMARY KEY(RoomNumber)
	 );

CREATE TABLE Payments 
	 (
	 Id INT IDENTITY NOT NULL, 
	 EmployeeId INT NOT NULL, 
	 PaymentDate DATE NOT NULL, 
	 AccountNumber INT NOT NULL, 
	 FirstDateOccupied DATE, 
	 LastDateOccupied DATE, 
	 TotalDays INT, 
	 AmountCharged NUMERIC, 
	 TaxRate NUMERIC, 
	 TaxAmount NUMERIC, 
	 PaymentTotal NUMERIC NOT NULL, 
	 Notes VARCHAR(max)
	 CONSTRAINT PK_Payments PRIMARY KEY (Id)
	 );

CREATE TABLE Occupancies
	  (
	  Id INT IDENTITY NOT NULL, 
	  EmployeeId INT NOT NULL, 
	  DateOccupied DATE, 
	  AccountNumber INT NOT NULL, 
	  RoomNumber INT NOT NULL, 
	  RateApplied NUMERIC, 
	  PhoneCharge NUMERIC, 
	  Notes VARCHAR(max)
	  CONSTRAINT PK_Occupancies PRIMARY KEY(Id)
	  );

INSERT INTO Employees (FirstName, LastName)
VALUES ('Ivan', 'Ivanov'),
		('Jelqzko', 'Nikov'),
		('Jivko', 'Ivanov');

INSERT INTO Customers (AccountNumber, FirstName, LastName, PhoneNumber)
VALUES
(34545674, 'Ivan', 'Petrov', '+35988999999'),
(35436554, 'Misho', 'Petrovanov', '+359889965479'),
(12480934, 'Nikolay', 'Nikov', '+35988999919');

INSERT INTO RoomStatus (RoomStatus)
VALUES
('Occupied'),
('Available'),
('Cleaning');

INSERT INTO RoomTypes (RoomType)
VALUES
('Single'),
('Double'),
('Apartment');

INSERT INTO BedTypes (BedType)
VALUES
('Double'),
('Single'),
('President');

INSERT INTO Rooms (RoomNumber, RoomType, BedType, RoomStatus)
VALUES
(10, 'Single', 'Double', 'Available'),
(21, 'Double', 'Single', 'Available'),
(14, 'Apartment', 'President', 'Occupied');

INSERT INTO Payments (EmployeeId, PaymentDate, AccountNumber, AmountCharged, PaymentTotal, TaxRate)
VALUES
(1, GETDATE(), 34545675, 10.20, 12.20, 2.4),
(3, GETDATE(), 34545675, 220.20, 240.22, 2.1),
(2, GETDATE(), 34545675, 190.20, 215.88, 1.1);

INSERT INTO Occupancies (EmployeeId, AccountNumber, RoomNumber)
VALUES
(1, 34545675, 2),
(2, 34545675, 1),
(2, 34545675, 12);
 --20.
 SELECT * FROM Towns
ORDER BY Name ASC

SELECT * FROM Departments
ORDER BY Name ASC

SELECT * FROM Employees
ORDER BY Salary DESC
-- 21.
 SELECT Name FROM Towns
 ORDER BY Name ASC;

SELECT Name FROM Departments
ORDER BY Name ASC;

SELECT FirstName, LastName, JobTitle, Salary FROM Employees
ORDER BY Salary DESC;

UPDATE Employees
	SET Salary = Salary*1.1;
SELECT Salary FROM Employees;


UPDATE Payments
SET TaxRate -= TaxRate * 0.03;
SELECT TaxRate FROM Payments;

DELETE FROM Occupancies;
	