--Problem 1.	One-To-One Relationship
CREATE TABLE Passports
(
PassportID int PRIMARY KEY,
PassportNumber nvarchar(50)
);

CREATE TABLE Persons
(
PersonID int PRIMARY KEY,
FirstName nvarchar(50),
Salary float,
PassportID int UNIQUE,
CONSTRAINT FK_Persons_Passports
FOREIGN KEY (PassportID)
REFERENCES Passports(PassportID)
);

INSERT INTO Passports(PassportID, PassportNumber)
VALUES (101, 'N34FG21B'), (102, 'K65LO4R7'), (103, 'ZE657QP2');

INSERT INTO Persons(PersonID, FirstName, Salary, PassportID)
VALUES (1, 'Roberto', 43300.00, 102), (2, 'Tom', 56100.00, 103), (3, 'Yana', 60200.00, 101);

SELECT * FROM Persons

--Problem 2.	One-To-Many Relationship
CREATE TABLE Manufacturers
(
ManufacturerID int PRIMARY KEY,
Name nvarchar(50),
EstablishedOn Date
)

CREATE TABLE Models
(
ModelID int PRIMARY KEY,
Name nvarchar(50),
ManufacturerID int,
CONSTRAINT FK_Models_Manufacturers FOREIGN KEY (ManufacturerID)
REFERENCES Manufacturers(ManufacturerID)
)

INSERT INTO Manufacturers(ManufacturerID, Name, EstablishedOn)
VALUES
(1, 'BMW', '07/03/1916'), 
(2, 'Tesla', '01/01/2003'), 
(3, 'Lada', '01/05/1966');

INSERT INTO Models(ModelID, Name, ManufacturerID)
VALUES
(101, 'X1', 1),
(102, 'i6', 1),
(103, 'Model S', 2),
(104, 'Model X', 2),
(105, 'Model 3', 2),
(106, 'Nova', 3);

--Problem 3.	Many-To-Many Relationship

CREATE TABLE Students
(
StudentID int PRIMARY KEY,
Name nvarchar(50)
);

CREATE TABLE Exams
(
ExamID int PRIMARY KEY,
Name nvarchar(50)
);

CREATE TABLE StudentsExams
(
StudentID int,
ExamID int,
CONSTRAINT PK_StudentID_ExamID PRIMARY KEY (StudentID, ExamID),
CONSTRAINT FK_StudentsExams_Students
FOREIGN KEY (StudentID)
REFERENCES Students(StudentID),
CONSTRAINT FK_StudentsExams_Exams
FOREIGN KEY (ExamID)
REFERENCES Exams(ExamID)
);

INSERT INTO Students(StudentID, Name)
VALUES (1, 'Mila'), (2, 'Toni'), (3, 'Ron');

INSERT INTO Exams(ExamID, Name)
VALUES (101, 'SpringMVC'), (102, 'Neo4j'), (103, 'Oracle 11g');

INSERT INTO StudentsExams(StudentID, ExamID)
VALUES (1, 101), (1, 102), (2, 101), (3, 103), (2, 102), (2,103);

-- Problem 4.	Self-Referencing 

CREATE TABLE Teachers
(
TeacherID int PRIMARY KEY,
Name nvarchar(50),
ManagerID int,
FOREIGN KEY (ManagerID)
REFERENCES Teachers(TeacherID)
);

--Problem 5.	Online Store Database

CREATE DATABASE Shema
USE Shema
GO

CREATE TABLE Cities
(
CityID int PRIMARY KEY,
Name nvarchar(50)
);

CREATE TABLE Customers
(
CustomerID int PRIMARY KEY,
Name nvarchar(50),
Birthday DATE,
CityID int,
CONSTRAINT FK_Customers_Cities FOREIGN KEY (CityID)
REFERENCES Cities(CityID)
);

CREATE TABLE Orders
(
OrderID int PRIMARY KEY,
CustomerID int,
CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID)
REFERENCES Customers(CustomerID)
);

CREATE TABLE ItemTypes
(
ItemTypeID int PRIMARY KEY,
Name nvarchar(50)
);

CREATE TABLE Items(
ItemID int PRIMARY KEY,
Name nvarchar(50),
ItemTypeID int,
CONSTRAINT FK_Items_ItemTypes FOREiGN KEY (ItemTypeID)
REFERENCES ItemTypes(ItemTypeID)
);

CREATE TABLE OrderItems
(
OrderID int,
ItemID int,
CONSTRAINT PK_OrderID_ItemID PRIMARY KEY (OrderID, ItemID),
CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
CONSTRAINT FK_OrderItems_Items FOREIGN KEY (ItemID) REFERENCES Items(ItemID)
);

-- Problem 6.	University Database

CREATE DATABASE University
USE University
GO

CREATE TABLE Majors
(
MajorID int PRIMARY KEY,
Name nvarchar(50)
);

CREATE TABLE Students
(
StudentID int PRIMARY KEY,
StudentNumber int,
StudentName nvarchar(50),
MajorID int,
CONSTRAINT FK_Students_Majors FOREIGN KEY (MajorID) REFERENCES Majors(MajorID)
);

CREATE TABLE Subjects
(
SubjectID int PRIMARY KEY,
SubjectName nvarchar(50)
);

CREATE TABLE Agenda
(
StudentID int,
SubjectID int,
CONSTRAINT PK_StudentID_SubjectID PRIMARY KEY (StudentID, SubjectID),
CONSTRAINT FK_Agenda_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
CONSTRAINT FK_Agenda_Subjects FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);

CREATE TABLE Payment
(
PaymentID int PRIMARY KEY,
PaymentDate Date,
PaymentAmount Decimal(8,2),
StudentID int,
CONSTRAINT FK_Payments_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);

