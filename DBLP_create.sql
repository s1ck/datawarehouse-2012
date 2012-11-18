USE [dwhprak06]

if OBJECT_ID('dbo.dblp_author_publication') IS NOT NULL drop table [dbo].[dblp_author_publication]
if OBJECT_ID('dbo.dblp_venue_publication') IS NOT NULL drop table [dbo].[dblp_venue_publication]
if OBJECT_ID('dbo.dblp_venue_series_publication') IS NOT NULL drop table [dbo].[dblp_venue_series_publication]
if OBJECT_ID('dbo.dblp_cited_by') IS NOT NULL drop table [dblp_cited_by]

if OBJECT_ID('dbo.dblp_venue') IS NOT NULL drop table [dbo].[dblp_venue]
if OBJECT_ID('dbo.dblp_publication') IS NOT NULL drop table [dbo].[dblp_publication]
if OBJECT_ID('dbo.dblp_author') IS NOT NULL drop table [dbo].[dblp_author]
if OBJECT_ID('dbo.dblp_venue_series') IS NOT NULL drop table [dbo].[dblp_venue_series]


CREATE TABLE [dbo].[dblp_author] (
    [id] bigint NOT NULL PRIMARY KEY,
    [firstname] varchar(255),
    [lastname] varchar(255),
    [homepage] varchar(255),
    [fullname] varchar(255)
)

CREATE TABLE [dbo].[dblp_venue_series] (
    [id] bigint NOT NULL PRIMARY KEY,
    [name] varchar(255),
    [type] varchar(10)
)

CREATE TABLE [dbo].[dblp_publication] (
    [id] bigint NOT NULL PRIMARY KEY,
    [dblp_code] varchar(255),
    [title] varchar(255),
    [year] int,
    [start_page] bigint,
    [end_page] bigint
)

CREATE TABLE [dbo].[dblp_venue] (
	[id] bigint NOT NULL PRIMARY KEY IDENTITY,
	[name] varchar(255),
	[year] int,
	[venue_series_id] bigint NOT NULL,
	[publication_id] bigint NOT NULL,
	FOREIGN KEY (venue_series_id) REFERENCES [dbo].[dblp_venue_series](id)
)

CREATE TABLE [dbo].[dblp_author_publication] (	
    [publication_id] bigint NOT NULL,
    [author_id] bigint NOT NULL,
    [position] tinyint,
	-- pos is within pk because of data error: The duplicate key value is (7531, 50178).
	PRIMARY KEY (publication_id, author_id, position)
)

CREATE TABLE [dbo].[dblp_venue_series_publication] (
    [venue_series_id] bigint NOT NULL,
    [publication_id] bigint NOT NULL,
	PRIMARY KEY (venue_series_id, publication_id)
)

CREATE TABLE [dbo].[dblp_venue_publication] (
    [venue_id] bigint NOT NULL,
    [publication_id] bigint NOT NULL,
	PRIMARY KEY (venue_id, publication_id)	
)

CREATE TABLE [dbo].[dblp_cited_by] (
	[publication1_id] bigint NOT NULL,
	[publication2_id] bigint NOT NULL,
	PRIMARY KEY (publication1_id, publication2_id)
)