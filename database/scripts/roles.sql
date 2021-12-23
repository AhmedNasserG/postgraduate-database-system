CREATE ROLE [db_owner]
GO

-- CREATE LOGIN linearDepression WITH PASSWORD = 'linearDepression12345';

-- CREATE USER linearDepression FOR LOGIN linearDepression;

ALTER ROLE dbo_owner ADD MEMBER LinearDepression;