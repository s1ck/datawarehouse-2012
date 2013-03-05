use dwhprak06

-- drop foreign keys
IF OBJECT_ID('dbo.fk_author') IS NOT NULL	
	ALTER TABLE [dbo].[cube_AuthorPublication] DROP CONSTRAINT [fk_author]
IF OBJECT_ID('dbo.fk_publication') IS NOT NULL	
	ALTER TABLE [dbo].[cube_AuthorPublication] DROP CONSTRAINT [fk_publication]
IF OBJECT_ID('dbo.fk_time') IS NOT NULL	
	ALTER TABLE [dbo].[cube_Publication] DROP CONSTRAINT [fk_time]
IF OBJECT_ID('dbo.fk_venueseries') IS NOT NULL	
	ALTER TABLE [dbo].[cube_Publication] DROP CONSTRAINT [fk_venueseries]
IF OBJECT_ID('dbo.fk_title') IS NOT NULL	
	ALTER TABLE [dbo].[cube_Publication] DROP CONSTRAINT [fk_title]
		

-- drop tables
IF OBJECT_ID('dbo.cube_Time') IS NOT NULL DROP TABLE [dbo].[cube_Time]
IF OBJECT_ID('dbo.cube_Author') IS NOT NULL DROP TABLE [dbo].[cube_Author]
IF OBJECT_ID('dbo.cube_AuthorPublication') IS NOT NULL DROP TABLE [dbo].[cube_AuthorPublication]
IF OBJECT_ID('dbo.cube_Title') IS NOT NULL DROP TABLE [dbo].[cube_Title]
IF OBJECT_ID('dbo.cube_VenueSeries') IS NOT NULL DROP TABLE [dbo].[cube_VenueSeries]

IF OBJECT_ID('dbo.cube_Publication') IS NOT NULL DROP TABLE [dbo].[cube_Publication]

-- Dimensions

CREATE TABLE cube_Time (
	year int NOT NULL,
	decade int,
	PRIMARY KEY (year));

CREATE TABLE cube_Author (
	id BIGINT NOT NULL,
	name NVARCHAR(255),
	institution NVARCHAR(255),
	PRIMARY KEY (id));
	
CREATE TABLE cube_AuthorPublication (
	Publication_Id bigint NOT NULL,
	Author_Id BIGINT NOT NULL,
	PRIMARY KEY (Publication_Id, Author_Id)
	);

CREATE TABLE cube_Title (
	id BIGINT NOT NULL,
	title VARCHAR(255),
	PRIMARY KEY (id));
	
CREATE TABLE cube_VenueSeries (
	id BIGINT NOT NULL,
	description VARCHAR(255),
	PRIMARY KEY (id));
	
-- Fact

CREATE TABLE cube_Publication (
	id BIGINT NOT NULL IDENTITY,
	titleId BIGINT,
	year INT,
	venueSeriesId BIGINT,
	citingsGS INT DEFAULT 0,
	citingsACM INT DEFAULT 0,
	citingsACMSelf INT DEFAULT 0,
	PRIMARY KEY (id));
	






