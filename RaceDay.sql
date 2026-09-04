CREATE DATABASE RaceDay;
GO

USE RaceDay;
GO

-- 1. EVENT_TYPE
CREATE TABLE EVENT_TYPE
(
    EventTypeID INT PRIMARY KEY,
    TypeName VARCHAR(50) NOT NULL,
    CONSTRAINT UQ_EventType_TypeName UNIQUE (TypeName)
);
GO

-- 2. USER (reserved word, so it needs square brackets)
CREATE TABLE [USER]
(
    UserID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Surname VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Password VARCHAR(100) NOT NULL,
    Role VARCHAR(20) NOT NULL DEFAULT 'Participant',
    CONSTRAINT UQ_User_Email UNIQUE (Email)
);
GO

-- 3. EVENT (OrganiserID links back to USER, since an organiser is a user)
CREATE TABLE EVENT
(
    EventID INT PRIMARY KEY,
    EventName VARCHAR(100) NOT NULL,
    Description VARCHAR(255) NULL,
    EventDate DATE NOT NULL,
    Location VARCHAR(100) NULL,
    Distance DECIMAL(5,2) NULL,
    EventTypeID INT NOT NULL,
    OrganiserID INT NOT NULL,
    CONSTRAINT FK_Event_EventType FOREIGN KEY (EventTypeID)
        REFERENCES EVENT_TYPE (EventTypeID),
    CONSTRAINT FK_Event_Organiser FOREIGN KEY (OrganiserID)
        REFERENCES [USER] (UserID)
);
GO

-- 4. CATEGORY (belongs to a specific EVENT)
CREATE TABLE CATEGORY
(
    CategoryID INT PRIMARY KEY,
    EventID INT NOT NULL,
    CategoryType VARCHAR(50) NULL,
    CategoryName VARCHAR(50) NOT NULL,
    CONSTRAINT FK_Category_Event FOREIGN KEY (EventID)
        REFERENCES EVENT (EventID)
);
GO

-- 5. ENROLLMENT (ParticipantID links back to USER, since a participant is a user)
CREATE TABLE ENROLLMENT
(
    EnrollmentID INT PRIMARY KEY,
    ParticipantID INT NOT NULL,
    EventID INT NOT NULL,
    CategoryID INT NOT NULL,
    EnrollmentDate DATE NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Enrollment_Participant FOREIGN KEY (ParticipantID)
        REFERENCES [USER] (UserID),
    CONSTRAINT FK_Enrollment_Event FOREIGN KEY (EventID)
        REFERENCES EVENT (EventID),
    CONSTRAINT FK_Enrollment_Category FOREIGN KEY (CategoryID)
        REFERENCES CATEGORY (CategoryID)
);
GO

-- 6. RESULT
CREATE TABLE RESULT
(
    ResultsID INT PRIMARY KEY,
    EnrollmentID INT NOT NULL,
    FinishTime TIME NULL,
    FinishingPosition INT NULL,
    Status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    CONSTRAINT FK_Result_Enrollment FOREIGN KEY (EnrollmentID)
        REFERENCES ENROLLMENT (EnrollmentID),
    CONSTRAINT UQ_Result_Enrollment UNIQUE (EnrollmentID)
);
GO

-- EVENT_TYPE
INSERT INTO EVENT_TYPE (EventTypeID, TypeName) VALUES
(1, 'Marathon'),
(2, 'Fun Run'),
(3, 'Triathlon');
GO

-- USER: 2 Organisers, 2 Participants
INSERT INTO [USER] (UserID, Name, Surname, Email, Password, Role) VALUES
(1, 'Thabo', 'Nkosi', 'thabo.nkosi@email.com', 'Pass123!', 'Organiser'),
(2, 'Naledi', 'Mokoena', 'naledi.mokoena@email.com', 'Pass321!', 'Organiser'),
(3, 'Sarah', 'Botha', 'sarah.botha@email.com', 'Pass456!', 'Participant'),
(4, 'Lindiwe', 'Dube', 'lindiwe.dube@email.com', 'Pass789!', 'Participant');
GO

-- EVENT: 3 events, each with a different organiser/type
INSERT INTO EVENT (EventID, EventName, Description, EventDate, Location, Distance, EventTypeID, OrganiserID) VALUES
(1, 'Joburg City Marathon', 'Annual city marathon', '2026-10-04', 'Johannesburg', 42.20, 1, 1),
(2, 'Sunday Fun Run', 'Casual community run', '2026-09-20', 'Pretoria', 5.00, 2, 1),
(3, 'Spring Triathlon', 'Swim, cycle, run event', '2026-11-15', 'Cape Town', 51.50, 3, 2);
GO

-- CATEGORY: at least one category per event
INSERT INTO CATEGORY (CategoryID, EventID, CategoryType, CategoryName) VALUES
(1, 1, 'Age Group', 'Open 18-39'),
(2, 1, 'Age Group', 'Senior 60+'),
(3, 2, 'General', 'All Ages'),
(4, 3, 'Age Group', 'Open 18-39');
GO

-- ENROLLMENT: sample enrolments (EnrollmentDate uses DEFAULT, so omitted here for row 2)
INSERT INTO ENROLLMENT (EnrollmentID, ParticipantID, EventID, CategoryID, EnrollmentDate) VALUES
(1, 3, 1, 1, '2026-08-01');
GO

INSERT INTO ENROLLMENT (EnrollmentID, ParticipantID, EventID, CategoryID) VALUES
(2, 4, 3, 4);
GO

-- RESULT (Status uses DEFAULT 'Pending' for the second row)
INSERT INTO RESULT (ResultsID, EnrollmentID, FinishTime, FinishingPosition, Status) VALUES
(1, 1, '03:45:12', 25, 'Finished');
GO

INSERT INTO RESULT (ResultsID, EnrollmentID, FinishTime, FinishingPosition) VALUES
(2, 2, NULL, NULL);
GO