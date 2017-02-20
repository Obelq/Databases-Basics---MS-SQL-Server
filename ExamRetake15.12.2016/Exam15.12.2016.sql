CREATE DATABASE TheNerdHerd
USE TheNerdHerd
GO

-- Section 1. DDL	
CREATE TABLE Locations(
Id INT PRIMARY KEY,
Latitude FLOAT,
Longitude FLOAT
)

CREATE TABLE [Credentials](
Id INT PRIMARY KEY,
Email VARCHAR(30),
Password VARCHAR(20)
)

CREATE TABLE Users(
	Id INT PRIMARY KEY IDENTITY,
	Nickname VARCHAR(25),
	Gender CHAR(1),
	Age INT,
	LocationId INT,
	CredentialId INT UNIQUE,
	CONSTRAINT FK_Users_Locations FOREIGN KEY(LocationId)
	REFERENCES Locations(Id),
	CONSTRAINT FK_Users_Credentials FOREIGN KEY(CredentialId)
	REFERENCES [Credentials](Id)
)

CREATE TABLE Chats(
Id INT PRIMARY KEY,
Title VARCHAR(32),
StartDate DATE,
IsActive BIT
)

CREATE TABLE [Messages](
Id INT PRIMARY KEY,
Content VARCHAR(200),
SentOn DATE,
ChatId INT,
UserId INT,
CONSTRAINT FK_Messages_Chats FOREIGN KEY(ChatId)
REFERENCES Chats(Id),
CONSTRAINT FK_Messages_Users FOREIGN KEY(UserId)
REFERENCES Users(Id)
)

CREATE TABLE UsersChats(
UserId INT,
ChatId INT,
CONSTRAINT PK_User_Chat PRIMARY KEY(ChatId, UserId),
CONSTRAINT FK_UsersChats_Users FOREIGN KEY(UserId)
REFERENCES Users(Id),
CONSTRAINT FK_UsersChats_Chats FOREIGN KEY(ChatId)
REFERENCES Chats(Id)
)

-- Section 2. DML

-- 2.Insert

SELECT * FROM Messages
SELECT * FROM Users


INSERT INTO Messages(Content, SentOn, ChatId, UserId)
SELECT CONCAT(u.Age, '-', u.Gender, '-', l.Latitude, '-', l.Longitude), GETDATE(),
	CASE WHEN u.Gender = 'F' THEN CEILING(SQRT(u.Age*2))
		ELSE CEILING(POWER(u.Age/18, 3)) END, u.Id
	FROM Users AS u
		JOIN Locations AS l
			ON u.LocationId = l.Id
WHERE u.Id BETWEEN 10 AND 20

-- 3.Update

UPDATE Chats
SET StartDate = (
				SELECT MIN(m.SentOn)
				FROM Chats AS c
				JOIN Messages AS m ON c.Id = m.ChatId
				WHERE c.Id = Chats.Id
				)
WHERE Chats.Id IN (
					SELECT c.Id FROM Chats AS c
					JOIN Messages AS m
						ON c.Id = m.ChatId
					GROUP BY c.Id, c.StartDate
					HAVING c.StartDate > MIN(m.SentOn)
					ORDER BY c.Id
				)

-- 4.	Delete

DELETE FROM Locations
WHERE Locations.Id IN
	(
		SELECT DISTINCT l.Id FROM Locations AS l
			LEFT JOIN Users AS u ON l.Id = u.LocationId
		WHERE u.Id IS NULL
	)

-- Section 3. Querying

-- 5.Age Range

SELECT Nickname, Gender, Age FROM Users WHERE Age BETWEEN 22 AND 37


-- 14.	Last Chat

SELECT TOP 1 WITH TIES c.Title , m.Content FROM Messages AS m
	RIGHT JOIN Chats AS c
		ON m.ChatId = c.Id
WHERE c.Id = (
				SELECT TOP 1 Id FROM Chats
				ORDER BY StartDate DESC
			)
ORDER BY m.SentOn
