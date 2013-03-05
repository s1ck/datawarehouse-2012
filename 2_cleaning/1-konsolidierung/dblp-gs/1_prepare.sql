use [dwhprak06]


-- mapping table
IF OBJECT_ID('dbo.dblp_gs') IS NOT NULL DROP TABLE [dbo].[dblp_gs]

-- venue series views
IF OBJECT_ID('dbo.GS_PUBLICATION_VLDB') IS NOT NULL DROP VIEW [dbo].[GS_PUBLICATION_VLDB]
IF OBJECT_ID('dbo.GS_PUBLICATION_SIGMOD') IS NOT NULL DROP VIEW [dbo].[GS_PUBLICATION_SIGMOD]
IF OBJECT_ID('dbo.GS_PUBLICATION_TRANSACTIONS') IS NOT NULL DROP VIEW [dbo].[GS_PUBLICATION_TRANSACTIONS]

-- validation view
IF OBJECT_ID('dbo.DBLP_GS_VALIDATION_VIEW') IS NOT NULL DROP VIEW [dbo].[DBLP_GS_VALIDATION_VIEW]

-- DBLP-GS mapping table

GO 

CREATE TABLE [dbo].[dblp_gs] (
    [dblp_id] bigint,
    [gs_id] numeric(20,0),
    [_Similarity] real,
    [_Confidence] real,
    [_Similarity_title] real,
    PRIMARY KEY ([dblp_id], [gs_id])
)

GO
-- view contains all publications that could have sth to do with 'VLDB' or 'very large database'
CREATE VIEW dbo.GS_PUBLICATION_VLDB AS
SELECT
	pub.id
	,pub.title
	,ven.year 
	,venser.name
FROM
	[dbo].gs_publication AS pub
JOIN
	dbo.gs_venue_publication As venpub
ON
	pub.id = venpub.publication_id
JOIN
	dbo.gs_venue AS ven
ON
	ven.id = venpub.venue_id
JOIN
	dbo.gs_venue_series AS venser
ON
	ven.venue_series_id = venser.id
WHERE
	ven.venue_series_id in (
	SELECT [id]
	  FROM
			[dwhprak06].[dbo].[gs_venue_series]
	  WHERE 
			name LIKE '%VLDB%'
	  OR
			name LIKE '%very large database%')

GO
-- view contains all publications that could have sth to do with 'SIGMOD' or 'management of data'
CREATE VIEW dbo.GS_PUBLICATION_SIGMOD AS
SELECT
	pub.id
	,pub.title
	,ven.year 
	,venser.name
FROM
	dbo.gs_publication AS pub
JOIN
	dbo.gs_venue_publication As venpub
ON
	pub.id = venpub.publication_id
JOIN
	dbo.gs_venue AS ven
ON
	ven.id = venpub.venue_id
JOIN
	dbo.gs_venue_series AS venser
ON
	ven.venue_series_id = venser.id
WHERE
	ven.venue_series_id in (
	SELECT [id]
	  FROM
			[dwhprak06].[dbo].[gs_venue_series]
	  WHERE 
	  		name LIKE '%sigmod%'
	  OR
			name LIKE '%management of data%')

GO
-- view contains all publications that could have sth to do with 'transactions
-- on database' or 'TODS'
CREATE VIEW dbo.GS_PUBLICATION_TRANSACTIONS AS
SELECT
	pub.id
	,pub.title
	,ven.year 
	,venser.name
FROM
	dbo.gs_publication AS pub
JOIN
	dbo.gs_venue_publication As venpub
ON
	pub.id = venpub.publication_id
JOIN
	dbo.gs_venue AS ven
ON
	ven.id = venpub.venue_id
JOIN
	dbo.gs_venue_series AS venser
ON
	ven.venue_series_id = venser.id
WHERE
	ven.venue_series_id in (
	SELECT [id]
	  FROM
			[dwhprak06].[dbo].[gs_venue_series]
	  WHERE 
	  		name LIKE '%transactions on database%'
	  OR
			name LIKE '%TODS%'
			)

/*
Create validation views
*/
GO

CREATE VIEW 
	[dbo].[DBLP_GS_VALIDATION_VIEW]
AS SELECT
	mapping.dblp_id,
	dblp.title as dblp_title,
	dblp.start_page as dblp_start_page,
	dblp.end_page as dblp_end_page,
	mapping.gs_id ,
	gs.title as gs_title,	
	mapping._Similarity_title as sim_title
FROM
	[dbo].[dblp_gs] mapping
INNER JOIN
	[dbo].[dblp_publication] dblp
ON
	dblp.id = mapping.dblp_id
INNER JOIN
	[dbo].[gs_publication] gs
ON
	gs.id = mapping.gs_id

