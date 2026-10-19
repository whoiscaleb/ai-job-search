-- Drops and recreates the lab database. Safe to run any time you want a clean slate.
USE master;
GO
IF DB_ID('CommunityLab') IS NOT NULL
BEGIN
    ALTER DATABASE CommunityLab SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE CommunityLab;
END
GO
CREATE DATABASE CommunityLab;
GO
