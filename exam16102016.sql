USE AMS
GO
CREATE TABLE Towns(
TownID INT PRIMARY KEY,
TownName VARCHAR(30) NOT NULL
)

CREATE TABLE Airports(
AirportID INT PRIMARY KEY,
AirportName VARCHAR(50),
TownID INT,
CONSTRAINT FK_Airports_Towns FOREIGN KEY (TownID)
REFERENCES Towns(TownID)
)

-- Section 1: Data Definition
CREATE TABLE Flights(
FlightID INT PRIMARY KEY,
DepartureTime DATETIME NOT NULL,
ArrivalTime DATETIME NOT NULL,
Status VARCHAR(9) CHECK (Status IN ('Departing', 'Delayed', 'Arrived', 'Cancelled')),
OriginAirportID INT,
DestinationAirportID INT,
AirlineID INT,
CONSTRAINT FK_Flights_AirportsOrigin FOREIGN KEY(OriginAirportID)
REFERENCES Airports(AirportID),
CONSTRAINT FK_Flights_AirportsDestination FOREIGN KEY(DestinationAirportID)
REFERENCES Airports(AirportID),
CONSTRAINT FK_FLights_Airlines FOREIGN KEY(AirlineID)
REFERENCES Airlines(AirlineID)
)

CREATE TABLE Tickets(
TicketID INT PRIMARY KEY,
Price DECIMAL(8, 2) NOT NULL,
Class VARCHAR(6) CHECK (Class IN ('First', 'Second', 'Third')),
Seat VARCHAR(5) NOT NULL,
CustomerID INT,
FlightID INT,
CONSTRAINT FK_Tickets_Customers FOREIGN KEY(CustomerID)
REFERENCES Customers(CustomerID),
CONSTRAINT FK_Tickets_Flights FOREIGN KEY(FlightID)
REFERENCES Flights(FlightID)
)

-- Section 2: Database Manipulations

-- Task 1: Data Insertion

INSERT INTO Flights(FlightID, DepartureTime, ArrivalTime, Status, OriginAirportID, DestinationAirportID, AirlineID)
VALUES
(1, '20161013 6 AM', '20161013 10 AM', 'Delayed', 1, 4, 1),
(2, '20161012 12 PM', '20161012 12:01 PM', 'Departing', 1, 3, 2),
(3,'20161014 3 PM', '20161020 4 AM', 'Delayed', 4, 2, 4),
(4,	'20161012 1:24 PM',	'20161012 4:31 PM',	'Departing', 3,	1, 3),
(5, '20161012 08:11 AM', '20161012 11:22 PM', 'Departing',	4,	1,	1),
(6, '19950621 12:30 PM', '19950622 08:30 PM', 'Arrived', 2,	3, 5),
(7, '20161012 11:34 PM', '20161013 03:00 AM', 'Departing',	2, 4, 2),
(8, '20161111 01:00 PM', '20161112 10:00 PM', 'Delayed', 4, 3, 1),
(9, '20151001 12:00 PM', '20151201 01:00 AM', 'Arrived', 1,	2, 1),
(10, '20161012 07:30 PM', '20161013 12:30 PM', 'Departing', 2, 1, 7)

INSERT INTO Tickets
VALUES
(1, 3000.00, 'First', '233-A', 3, 8),
(2, 1799.90, 'Second', '123-D', 1, 1),
(3, 1200.50, 'Second', '12-Z', 2, 5),
(4, 410.68, 'Third', '45-Q', 2, 8),
(5, 560.00, 'Third', '201-R', 4, 6),
(6, 2100.00, 'Second', '13-T', 1, 9),
(7, 5500.00, 'First', '98-O', 2, 7)

-- Task 2: Update Arrived Flights

UPDATE Flights SET AirlineID = 1
WHERE [Status] = 'Arrived'

--Task 3: Update Tickets

UPDATE Tickets SET Price = Price*1.5
FROM Tickets AS t
	JOIN Flights AS f
		ON t.FlightID = f.FlightID
WHERE f.AirlineID =
(SELECT TOP 1 f.AirlineID FROM Tickets AS t
	JOIN Flights AS f
		ON t.FlightID = f.FlightID
	JOIN Airlines AS a
		ON a.AirlineID = f.AirlineID
	ORDER BY a.Rating DESC)

-- Task 4: Table Creation

CREATE TABLE CustomerReviews(
ReviewID INT PRIMARY KEY,
ReviewContent VARCHAR(255) NOT NULL,
ReviewGrade INT CHECK (ReviewGrade BETWEEN 0 AND 10),
AirlineID INT,
CustomerID INT,
CONSTRAINT FK_CustomerReviews_Airlines FOREIGN KEY(AirlineID)
REFERENCES Airlines(AirlineID),
CONSTRAINT FK_CustomerReviews_Customers FOREIGN KEY(CustomerID)
REFERENCES Customers(CustomerID)
)

CREATE TABLE CustomerBankAccounts(
AccountID INT PRIMARY KEY,
AccountNumber VARCHAR(10) NOT NULL UNIQUE,
Balance DECIMAL(10,2) NOT NULL,
CustomerID INT,
CONSTRAINT FK_CustomerBankAccounts_Customers FOREIGN KEY(CustomerID)
REFERENCES Customers(CustomerID)
)

-- Task 5: Fill the new Tables with Data

INSERT INTO CustomerReviews
VALUES
(1, 'Me is very happy. Me likey this airline. Me good.', 10, 1, 1),
(2, 'Ja, Ja, Ja... Ja, Gut, Gut, Ja Gut! Sehr Gut!', 10, 1, 4),
(3, 'Meh...', 5, 4, 3),
(4, 'Well Ive seen better, but Ive certainly seen a lot worse...', 7, 3, 5);

INSERT INTO CustomerBankAccounts
VALUES
(1, '123456790', 2569.23, 1),
(2, '18ABC23672', 14004568.23, 2),
(3, 'F0RG0100N3', 19345.20, 5)

-- Section 3: Querying

-- Task 1: Extract All Tickets

SELECT TicketID, Price, Class, Seat FROM Tickets
ORDER BY TicketID

-- Task 2: Extract All Customers 

SELECT CustomerID, CONCAT(FirstName, ' ', LastName) AS 'FullName', Gender 
FROM Customers
ORDER BY 'FullName', CustomerID

-- Task 3: Extract Delayed Flights 

SELECT FlightID, DepartureTime, ArrivalTime FROM Flights
WHERE [Status] = 'Delayed'
ORDER BY FlightID

-- Task 4: Extract Top 5 Most Highly Rated Airlines which have any Flights

SELECT DISTINCT TOP 5 a.AirlineID, a.AirlineName, a.Nationality, a.Rating FROM Airlines AS a
	JOIN Flights AS f
		ON a.AirlineID = f.AirlineID
ORDER BY a.Rating DESC, AirlineID

-- Task 5: Extract all Tickets with price below 5000, for First Class

SELECT t.TicketID, a.AirportName AS Destination, CONCAT(c.FirstName, ' ', c.LastName) AS [CustomerName] FROM Tickets AS t
	JOIN Flights AS f
		ON t.FlightID = f.FlightID
	JOIN Airports as a
		ON f.DestinationAirportID = a.AirportID
	JOIN Customers AS c
		ON t.CustomerID = c.CustomerID
WHERE t.Price <5000 AND t.Class = 'First'
ORDER BY t.TicketID

-- Task 6: Extract all Customers which are departing from their Home Town

SELECT DISTINCT c.CustomerID, CONCAT(c.FirstName, ' ', c.LastName) AS FullName, tw.TownName AS HomeTown FROM Customers AS c
	JOIN Tickets AS t
		ON c.CustomerID = t.CustomerID
	JOIN Flights AS f
		ON t.FlightID = f.FlightID
	JOIN Airports AS a
		ON f.OriginAirportID = a.AirportID
	JOIN Towns AS tw
		ON c.HomeTownID = tw.TownID
WHERE c.HomeTownID = a.TownID
ORDER BY c.CustomerID

-- Task 7: Extract all Customers which will fly

SELECT DISTINCT c.CustomerID, CONCAT(c.FirstName, ' ', c.LastName) AS FullName, 
(2016 - YEAR(c.DateOfBirth)) AS Age FROM Customers AS c
	RIGHT JOIN Tickets AS t
		ON c.CustomerID = t.CustomerID
	JOIN Flights AS f
		ON t.FlightID = f.FlightID
	WHERE f.[Status] = 'Departing'
ORDER BY Age, c.CustomerID

-- Task 8: Extract Top 3 Customers which have Delayed Flights

SELECT TOP 3 c.CustomerID, CONCAT(c.FirstName, ' ', c.LastName) AS FullName,
	t.Price AS TicketPrice, a.AirportName AS Destination FROM Customers AS c
	JOIN Tickets AS t
		ON c.CustomerID = t.CustomerID
	JOIN Flights AS f
		ON t.FlightID = f.FlightID
	JOIN Airports AS a
		ON f.DestinationAirportID = a.AirportID
	WHERE f.Status = 'Delayed'
ORDER BY t.Price DESC, c.CustomerID

-- 	Task 9: Extract the Last 5 Flights, which are departing.
SELECT * FROM
(SELECT TOP 5 f.FlightID, f.DepartureTime, f.ArrivalTime, 
	fo.AirportName AS Origin, fd.AirportName AS Destination FROM Flights AS f
	JOIN Airports AS fo
		ON f.OriginAirportID = fo.AirportID
	JOIN Airports AS fd
		ON f.DestinationAirportID = fd.AirportID
	WHERE f.Status = 'Departing'
ORDER BY f.DepartureTime DESC, FlightID DESC) AS r
ORDER BY r.DepartureTime

-- Task 10: Extract all Customers below 21 years, 
--which have already flew at least once

SELECT DISTINCT c.CustomerID, CONCAT(c.FirstName, ' ', c.LastName) AS FullName,
	(2016 - YEAR(c.DateOfBirth)) AS Age FROM Customers AS c
	JOIN Tickets AS t
		ON c.CustomerID = t.CustomerID
	JOIN Flights AS f
		ON t.FlightID = f.FlightID
	WHERE 2016 - YEAR(c.DateOfBirth) < 21 AND f.Status = 'Arrived'
ORDER BY Age DESC, c.CustomerID

-- Task 11: Extract all Airports and the Count of People departing from them

SELECT airp.[AirportID], airp.[AirportName], COUNT(t.[TicketID]) AS Passengers
  FROM [Airports] AS airp
 INNER JOIN [Flights] AS f
    ON f.[OriginAirportID] = airp.[AirportID]
 INNER JOIN [Tickets] AS t
    ON t.[FlightID] = f.[FlightID]
 WHERE f.[Status] = 'Departing'
 GROUP BY airp.[AirportID],
          airp.[AirportName];

-- Section 4: Programmability

-- Task 1: Review Registering Procedure

CREATE PROCEDURE usp_SubmitReview(
@CustomerID INT,
@ReviewContent VARCHAR(255),
@ReviewGrade INT,
@AirlineName VARCHAR(30)
)
AS
BEGIN
	
	IF((SELECT TOP 1 a.AirlineName FROM Airlines AS a WHERE a.AirlineName = @AirlineName) IS NULL)
		BEGIN
		RAISERROR('Airline does not exist.', 16, 1)
		END
	INSERT INTO CustomerReviews
	VALUES(
	(SELECT COUNT(*) + 1 FROM CustomerReviews),
	@ReviewContent,
	@ReviewGrade,
	(SELECT AirlineID FROM Airlines WHERE AirlineName = @AirlineName),
	@CustomerID
	)
		
END

-- Task 2: Ticket Purchase Procedure

CREATE PROCEDURE usp_PurchaseTicket(
@CustomerID INT,
@FlightID INT,
@TicketPrice DECIMAL(8,2),
@Class VARCHAR(6),
@Seat VARCHAR(5)
)
AS
BEGIN
	BEGIN TRAN

	INSERT INTO Tickets
	VALUES((SELECT COUNT(*) + 1 FROM Tickets), @TicketPrice, @Class, @Seat, @CustomerID, @FlightID);

	UPDATE CustomerBankAccounts SET Balance = Balance - @TicketPrice
	WHERE CustomerID = @CustomerID

	IF((SELECT Balance FROM CustomerBankAccounts WHERE CustomerID = @CustomerID) < 0)
		BEGIN
			RAISERROR('Insufficient bank account balance for ticket purchase.', 16, 1)
			ROLLBACK
		END
	ELSE
		COMMIT
END

-- Section 5 (BONUS): Update Trigger

CREATE TRIGGER TR_LogArrived
ON Flights
AFTER UPDATE
AS
BEGIN
	IF((SELECT i.Status FROM inserted AS i) = 'Arrived')
		BEGIN
			INSERT INTO ArrivedFlights
			SELECT i.[FlightID], i.[ArrivalTime], (SELECT ao.[AirportName]
                                                 FROM [Airports] AS ao
                                                INNER JOIN inserted AS inso
                                                   ON ao.[AirportID]  = inso.[OriginAirportID]), (SELECT ad.[AirportName]
                                                                                                FROM [Airports] AS ad
                                                                                               INNER JOIN inserted AS insd
                                                                                                  ON ad.[AirportID]  = insd.[OriginAirportID]), COUNT(t.[TicketID])
          FROM inserted AS i
         INNER JOIN Tickets AS t
            ON t.[FlightID] = i.[FlightID]
         GROUP BY i.[FlightID], i.[ArrivalTime];
			
		END
END
