 use [dwhprak06]

IF OBJECT_ID('dbo.gs_author_publication') IS NOT NULL drop table [dbo].[gs_author_publication]
IF OBJECT_ID('dbo.gs_author') IS NOT NULL drop table [dbo].[gs_author]
IF OBJECT_ID('dbo.gs_venue_publication') IS NOT NULL drop table [dbo].[gs_venue_publication]
IF OBJECT_ID('dbo.gs_publication') IS NOT NULL drop table [dbo].[gs_publication]
IF OBJECT_ID('dbo.gs_origin') IS NOT NULL drop table [dbo].[gs_origin]
IF OBJECT_ID('dbo.gs_venue') IS NOT NULL drop table [dbo].[gs_venue]
IF OBJECT_ID('dbo.gs_venue_series') IS NOT NULL drop table [dbo].[gs_venue_series]

IF OBJECT_ID('dbo.get_venue_series_NULL_id') IS NOT NULL DROP FUNCTION [dbo].[get_venue_series_NULL_id]

GO

-- returns the id of the venue_series which is attached to NULL
-- because we do not know how to update via subselect!
CREATE FUNCTION get_venue_series_NULL_id()
RETURNS INT
AS
BEGIN
	DECLARE @result int
	SELECT @result = id FROM gs_venue_series where name IS NULL
	RETURN @result
END

GO

-- author
CREATE TABLE [dbo].[gs_author] (
	[id] bigint NOT NULL PRIMARY KEY IDENTITY,
	[name] varchar(100)
)
INSERT INTO [dbo].[gs_author] (name)
	SELECT DISTINCT([author])
	FROM [dbo].[gs_tmp]
-- eo author

-- origin
CREATE TABLE [dbo].[gs_origin] (
	[id] bigint NOT NULL PRIMARY KEY IDENTITY,
	[text] varchar(255),
)
INSERT INTO [dbo].[gs_origin] ([text])
	SELECT DISTINCT([source])
	FROM [dbo].[gs_tmp]
-- eo origin

-- publication
CREATE TABLE [dbo].[gs_publication] (
	[id] numeric(20,0) NOT NULL PRIMARY KEY,
	[title] varchar(1000),
	[url] varchar(1000),
	[no_of_citings] int,
	[origin_id] bigint,
	FOREIGN KEY ([origin_id]) REFERENCES [dbo].[gs_origin]([id])
)
INSERT INTO [dbo].[gs_publication] ([id], [title], [url], [no_of_citings], [origin_id])
	SELECT DISTINCT -- because of the different authors in tmp
		[gs_tmp].[gs_id],
		[gs_tmp].[title],
		[gs_tmp].[url],
		[gs_tmp].[no_of_citings],
		[gs_origin].[id]
	FROM
		[dbo].[gs_tmp]		
	LEFT OUTER JOIN 
		[dbo].[gs_origin]
	ON
		[gs_tmp].[source] = [gs_origin].[text]
-- eo publication

-- author_publication
CREATE TABLE [dbo].[gs_author_publication] (
	[author_id] bigint,
	[publication_id] numeric(20,0),
	[pos] smallint,
	FOREIGN KEY ([author_id]) REFERENCES [dbo].[gs_author](id),
	FOREIGN KEY ([publication_id]) REFERENCES [dbo].[gs_publication](id),
	PRIMARY KEY ([author_id], [publication_id], [pos])
)
INSERT INTO [dbo].[gs_author_publication] ([author_id], [publication_id], [pos])
	SELECT DISTINCT
		[gs_author].[id],
		[gs_tmp].[gs_id],
		[gs_tmp].[author_pos]
	FROM [dbo].[gs_author], [dbo].[gs_tmp]
	WHERE [gs_author].[name] = [gs_tmp].[author]
-- eo author publication

-- venue series
CREATE TABLE [dbo].[gs_venue_series] (
	[id] bigint NOT NULL PRIMARY KEY IDENTITY,
	[name] varchar(500)
)
INSERT INTO [dbo].[gs_venue_series] ([name])
	SELECT 
		DISTINCT([venue_series])
	FROM 
		[dbo].[gs_tmp]
-- eo venue series

-- venue
CREATE TABLE [dbo].[gs_venue] (
	[id] bigint NOT NULL PRIMARY KEY IDENTITY,
	[publication_id] numeric(20,0),
	[title] varchar(255),
	[year] int,
	[venue_series_id] bigint
	--FOREIGN KEY ([venue_series_id]) REFERENCES [dbo].[gs_venue_series](id)
)

INSERT INTO [dbo].[gs_venue] ([publication_id], [year], [venue_series_id])	
	SELECT DISTINCT
		tmp.gs_id as publication_id,
		tmp.year as year,		
		vs.id as venue_series_id
	FROM
		gs_tmp tmp
	LEFT OUTER JOIN
		gs_venue_series vs
	ON
		vs.name = tmp.venue_series
		
UPDATE 
	[dbo].[gs_venue]
SET
	[venue_series_id] = [dbo].[get_venue_series_NULL_id]()
WHERE
	[venue_series_id] IS NULL


ALTER TABLE [dbo].[gs_venue] 
	ADD CONSTRAINT fk_gs_venue_venue_series_id FOREIGN KEY ([venue_series_id]) REFERENCES [dbo].[gs_venue_series](id)
-- eo venue

-- venue publication
CREATE TABLE [dbo].[gs_venue_publication] (
	[venue_id] bigint,
	[publication_id] numeric(20,0),
	FOREIGN KEY ([venue_id]) REFERENCES [dbo].[gs_venue](id),
	FOREIGN KEY ([publication_id]) REFERENCES [dbo].[gs_publication](id),
	PRIMARY KEY ([venue_id], [publication_id])
)

INSERT INTO [dbo].[gs_venue_publication] ([venue_id], [publication_id])
	SELECT DISTINCT 
		id,
		publication_id
	FROM
		[dbo].[gs_venue]	

-- eo venue publication



--CREATE TABLE [dbo].[publication](
--	[id] NUMERIC(20,0) PRIMARY KEY,
-- 	[title] varchar(400),

--)
--WHERE
--	gs.id = 8623493352720403