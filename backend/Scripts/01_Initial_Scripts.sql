-- =============================================
-- Author:		Praful Bhoir
-- Purpose:		Reminder App Database Schema
-- Environment:	Production (SQL Server)
-- =============================================
--CREATE DATABASE ReminderApp
--USE ReminderApp

-- =====================
-- USERS
-- =====================
IF NOT EXISTS (SELECT 1 FROM sys.tables t WHERE t.name = 'Users' AND SCHEMA_NAME(t.schema_id) = 'dbo')
BEGIN
    CREATE TABLE dbo.Users (
        UserID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
        UserName VARCHAR(255) NOT NULL,
        Email VARCHAR(255) NOT NULL,
        PasswordHash TEXT NOT NULL,
        PasswordSalt VARCHAR(255) NULL,
        CreatedBy UNIQUEIDENTIFIER NULL,
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        UpdatedBy UNIQUEIDENTIFIER NULL,
        UpdatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

        CONSTRAINT PK_Users PRIMARY KEY CLUSTERED (UserID),
		CONSTRAINT UQ_Users_UserName UNIQUE (UserName),
        CONSTRAINT UQ_Users_Email UNIQUE (Email)
    );
END
GO

-- Users (self reference)
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Users_Users_CreatedBy')
BEGIN
    ALTER TABLE dbo.Users WITH CHECK 
    ADD CONSTRAINT FK_Users_Users_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES dbo.Users(UserID);

    ALTER TABLE dbo.Users CHECK CONSTRAINT FK_Users_Users_CreatedBy;
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Users_Users_UpdatedBy')
BEGIN
    ALTER TABLE dbo.Users WITH CHECK 
    ADD CONSTRAINT FK_Users_Users_UpdatedBy FOREIGN KEY (UpdatedBy) REFERENCES dbo.Users(UserID);

    ALTER TABLE dbo.Users CHECK CONSTRAINT FK_Users_Users_UpdatedBy;
END
GO


-- =====================
-- PRIORITY LOOKUP
-- =====================
IF NOT EXISTS (SELECT 1 FROM sys.tables t WHERE t.name = 'Priority' AND SCHEMA_NAME(t.schema_id) = 'dbo')
BEGIN
    CREATE TABLE dbo.Priority (
        PriorityID TINYINT NOT NULL,
        PriorityName VARCHAR(20) NOT NULL,

        CONSTRAINT PK_Priority PRIMARY KEY CLUSTERED (PriorityID),
        CONSTRAINT UQ_Priority_Name UNIQUE (PriorityName)
    );
END
GO

-- =====================
-- RECURRENCE LOOKUP
-- =====================
IF NOT EXISTS (SELECT 1 FROM sys.tables t WHERE t.name = 'Recurrence' AND SCHEMA_NAME(t.schema_id) = 'dbo')
BEGIN
    CREATE TABLE dbo.Recurrence (
        RecurrenceID TINYINT NOT NULL,
        RecurrenceName VARCHAR(20) NOT NULL,

        CONSTRAINT PK_Recurrence PRIMARY KEY CLUSTERED (RecurrenceID),
        CONSTRAINT UQ_Recurrence_Name UNIQUE (RecurrenceName)
    );
END
GO

-- =====================
-- CATEGORIES
-- =====================
IF NOT EXISTS (SELECT 1 FROM sys.tables t WHERE t.name = 'Categories' AND SCHEMA_NAME(t.schema_id) = 'dbo')
BEGIN
    CREATE TABLE dbo.Categories (
        CategoryID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
        CategoryName VARCHAR(100) NOT NULL,
        CreatedBy UNIQUEIDENTIFIER NULL,
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        UpdatedBy UNIQUEIDENTIFIER NULL,
        UpdatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

        CONSTRAINT PK_Categories PRIMARY KEY CLUSTERED (CategoryID),
        CONSTRAINT UQ_Categories_Name UNIQUE (CategoryName)
    );
END
GO

-- Categories -> Users
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Categories_Users_CreatedBy')
BEGIN
    ALTER TABLE dbo.Categories WITH CHECK 
    ADD CONSTRAINT FK_Categories_Users_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES dbo.Users(UserID);

    ALTER TABLE dbo.Categories CHECK CONSTRAINT FK_Categories_Users_CreatedBy;
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Categories_Users_UpdatedBy')
BEGIN
    ALTER TABLE dbo.Categories WITH CHECK 
    ADD CONSTRAINT FK_Categories_Users_UpdatedBy FOREIGN KEY (UpdatedBy) REFERENCES dbo.Users(UserID);

    ALTER TABLE dbo.Categories CHECK CONSTRAINT FK_Categories_Users_UpdatedBy;
END
GO


-- =====================
-- TAGS
-- =====================
IF NOT EXISTS (SELECT 1 FROM sys.tables t WHERE t.name = 'Tags' AND SCHEMA_NAME(t.schema_id) = 'dbo')
BEGIN
    CREATE TABLE dbo.Tags (
        TagID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
        TagName VARCHAR(100) NOT NULL,
        CreatedBy UNIQUEIDENTIFIER NULL,
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        UpdatedBy UNIQUEIDENTIFIER NULL,
        UpdatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

        CONSTRAINT PK_Tags PRIMARY KEY CLUSTERED (TagID),
        CONSTRAINT UQ_Tags_Name UNIQUE (TagName)
    );
END
GO

-- Tags -> Users
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Tags_Users_CreatedBy')
BEGIN
    ALTER TABLE dbo.Tags WITH CHECK 
    ADD CONSTRAINT FK_Tags_Users_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES dbo.Users(UserID);

    ALTER TABLE dbo.Tags CHECK CONSTRAINT FK_Tags_Users_CreatedBy;
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Tags_Users_UpdatedBy')
BEGIN
    ALTER TABLE dbo.Tags WITH CHECK 
    ADD CONSTRAINT FK_Tags_Users_UpdatedBy FOREIGN KEY (UpdatedBy) REFERENCES dbo.Users(UserID);

    ALTER TABLE dbo.Tags CHECK CONSTRAINT FK_Tags_Users_UpdatedBy;
END
GO


-- =====================
-- REMINDERS
-- =====================
IF NOT EXISTS (SELECT 1 FROM sys.tables t WHERE t.name = 'Reminders' AND SCHEMA_NAME(t.schema_id) = 'dbo')
BEGIN
    CREATE TABLE dbo.Reminders (
        ReminderID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
        UserID UNIQUEIDENTIFIER NOT NULL,
        Title VARCHAR(255) NOT NULL,
        Description TEXT NULL,
        CategoryID UNIQUEIDENTIFIER NULL,
        PriorityID TINYINT NOT NULL DEFAULT 2, -- Default: Medium
        RemindAt DATETIME2 NOT NULL,
        RecurrenceID TINYINT NOT NULL DEFAULT 0, -- Default: None
        IsDeleted BIT NOT NULL DEFAULT 0,
        CreatedBy UNIQUEIDENTIFIER NULL,
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        UpdatedBy UNIQUEIDENTIFIER NULL,
        UpdatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

        CONSTRAINT PK_Reminders PRIMARY KEY CLUSTERED (ReminderID)
    );
END
GO


-- Reminders -> Users
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Reminders_Users_UserID')
BEGIN
    ALTER TABLE dbo.Reminders WITH CHECK 
    ADD CONSTRAINT FK_Reminders_Users_UserID FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID) ON DELETE CASCADE;

    ALTER TABLE dbo.Reminders CHECK CONSTRAINT FK_Reminders_Users_UserID;
END
GO

-- Reminders -> Categories
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Reminders_Categories_CategoryID')
BEGIN
    ALTER TABLE dbo.Reminders WITH CHECK 
    ADD CONSTRAINT FK_Reminders_Categories_CategoryID FOREIGN KEY (CategoryID) REFERENCES dbo.Categories(CategoryID);

    ALTER TABLE dbo.Reminders CHECK CONSTRAINT FK_Reminders_Categories_CategoryID;
END
GO

-- Reminders -> Priority
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Reminders_Priority_PriorityID')
BEGIN
    ALTER TABLE dbo.Reminders WITH CHECK 
    ADD CONSTRAINT FK_Reminders_Priority_PriorityID FOREIGN KEY (PriorityID) REFERENCES dbo.Priority(PriorityID);

    ALTER TABLE dbo.Reminders CHECK CONSTRAINT FK_Reminders_Priority_PriorityID;
END
GO

-- Reminders -> Recurrence
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Reminders_Recurrence_RecurrenceID')
BEGIN
    ALTER TABLE dbo.Reminders WITH CHECK 
    ADD CONSTRAINT FK_Reminders_Recurrence_RecurrenceID FOREIGN KEY (RecurrenceID) REFERENCES dbo.Recurrence(RecurrenceID);

    ALTER TABLE dbo.Reminders CHECK CONSTRAINT FK_Reminders_Recurrence_RecurrenceID;
END
GO

-- =====================
-- REMINDER TAGS (Junction Table)
-- =====================
IF NOT EXISTS (SELECT 1 FROM sys.tables t WHERE t.name = 'ReminderTags' AND SCHEMA_NAME(t.schema_id) = 'dbo')
BEGIN
    CREATE TABLE dbo.ReminderTags (
        ReminderID UNIQUEIDENTIFIER NOT NULL,
        TagID UNIQUEIDENTIFIER NOT NULL,
        CreatedBy UNIQUEIDENTIFIER NULL,
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        UpdatedBy UNIQUEIDENTIFIER NULL,
        UpdatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

        CONSTRAINT PK_ReminderTags PRIMARY KEY CLUSTERED (ReminderID, TagID)
    );
END
GO
-- ReminderTags -> Reminders
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_ReminderTags_Reminders_ReminderID')
BEGIN
    ALTER TABLE dbo.ReminderTags WITH CHECK 
    ADD CONSTRAINT FK_ReminderTags_Reminders_ReminderID FOREIGN KEY (ReminderID) REFERENCES dbo.Reminders(ReminderID) ON DELETE CASCADE;

    ALTER TABLE dbo.ReminderTags CHECK CONSTRAINT FK_ReminderTags_Reminders_ReminderID;
END
GO

-- ReminderTags -> Tags
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_ReminderTags_Tags_TagID')
BEGIN
    ALTER TABLE dbo.ReminderTags WITH CHECK 
    ADD CONSTRAINT FK_ReminderTags_Tags_TagID FOREIGN KEY (TagID) REFERENCES dbo.Tags(TagID) ON DELETE CASCADE;

    ALTER TABLE dbo.ReminderTags CHECK CONSTRAINT FK_ReminderTags_Tags_TagID;
END
GO

-- ReminderTags -> Users
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_ReminderTags_Users_CreatedBy')
BEGIN
    ALTER TABLE dbo.ReminderTags WITH CHECK 
    ADD CONSTRAINT FK_ReminderTags_Users_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES dbo.Users(UserID);

    ALTER TABLE dbo.ReminderTags CHECK CONSTRAINT FK_ReminderTags_Users_CreatedBy;
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_ReminderTags_Users_UpdatedBy')
BEGIN
    ALTER TABLE dbo.ReminderTags WITH CHECK 
    ADD CONSTRAINT FK_ReminderTags_Users_UpdatedBy FOREIGN KEY (UpdatedBy) REFERENCES dbo.Users(UserID);

    ALTER TABLE dbo.ReminderTags CHECK CONSTRAINT FK_ReminderTags_Users_UpdatedBy;
END
GO


-- =====================
-- NOTIFICATION PREFERENCES
-- =====================
IF NOT EXISTS (SELECT 1 FROM sys.tables t WHERE t.name = 'NotificationPreferences' AND SCHEMA_NAME(t.schema_id) = 'dbo')
BEGIN
    CREATE TABLE dbo.NotificationPreferences (
        NotificationPreferenceID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
        UserID UNIQUEIDENTIFIER NOT NULL,
        EmailEnabled BIT NOT NULL DEFAULT 1,
        WhatsappEnabled BIT NOT NULL DEFAULT 1,
        Email VARCHAR(255) NULL,
        Phone VARCHAR(20) NULL,
        CreatedBy UNIQUEIDENTIFIER NULL,
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        UpdatedBy UNIQUEIDENTIFIER NULL,
        UpdatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

        CONSTRAINT PK_NotificationPreferences PRIMARY KEY CLUSTERED (NotificationPreferenceID),
        CONSTRAINT UQ_NotificationPreferences_User UNIQUE (UserID)
    );
END
GO

-- NotificationPreferences -> Users
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_NotificationPreferences_Users_UserID')
BEGIN
    ALTER TABLE dbo.NotificationPreferences WITH CHECK 
    ADD CONSTRAINT FK_NotificationPreferences_Users_UserID FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID) ON DELETE CASCADE;

    ALTER TABLE dbo.NotificationPreferences CHECK CONSTRAINT FK_NotificationPreferences_Users_UserID;
END
GO


-- =====================
-- DEFAULT SEED DATA
-- =====================

-- PRIORITY
IF NOT EXISTS (SELECT 1 FROM dbo.Priority)
BEGIN
    INSERT INTO dbo.Priority (PriorityID, PriorityName) VALUES
    (1, 'Low'),
    (2, 'Medium'),
    (3, 'High');
END
GO

-- RECURRENCE
IF NOT EXISTS (SELECT 1 FROM dbo.Recurrence)
BEGIN
    INSERT INTO dbo.Recurrence (RecurrenceID, RecurrenceName) VALUES
    (0, 'None'),
    (1, 'Daily'),
    (2, 'Weekly'),
    (3, 'Monthly'),
    (4, 'Yearly');
END
GO
