use [dwhprak06]
/*
This is the prepare script for the consolidation of DBLP and ACM.
*/
-- venue series views for acm
IF OBJECT_ID('dbo.acm_publication_vldb_journal') IS NOT NULL DROP VIEW [dbo].[ACM_PUBLICATION_VLDB_JOURNAL]
IF OBJECT_ID('dbo.acm_publication_sigmod_journal') IS NOT NULL DROP VIEW [dbo].[ACM_PUBLICATION_SIGMOD_JOURNAL]
IF OBJECT_ID('dbo.acm_publication_transactions_journal') IS NOT NULL DROP VIEW [dbo].[ACM_PUBLICATION_TRANSACTIONS_JOURNAL]
IF OBJECT_ID('dbo.acm_publication_vldb_series') IS NOT NULL DROP VIEW [dbo].[ACM_PUBLICATION_VLDB_SERIES]
IF OBJECT_ID('dbo.acm_publication_sigmod_series')  IS NOT NULL DROP VIEW [dbo].[ACM_PUBLICATION_SIGMOD_SERIES]

-- TODO venue series view for google scholar

-- mapping table
IF OBJECT_ID('dbo.dblp_acm') IS NOT NULL DROP TABLE [dbo].[dblp_acm]

-- validation views

IF OBJECT_ID('dbo.dblp_acm_validation_view') IS NOT NULL DROP VIEW [dbo].[DBLP_ACM_VALIDATION_VIEW]


/*
Create Consolidation Target Tables
*/ 

-- DBLP-ACM

GO

CREATE TABLE [dbo].[dblp_acm] (
    [dblp_id] bigint,
    [acm_id] bigint,
    [_Similarity] real,
    [_Confidence] real,
    [_Similarity_title] real,
    PRIMARY KEY ([dblp_id], [acm_id])
)


GO
-- ACM Publications of VLDB (Journal)

CREATE VIEW 
	[dbo].[ACM_PUBLICATION_VLDB_JOURNAL]
AS SELECT     
	dbo.acm_publication.id, 
	dbo.acm_publication.title
FROM         
	dbo.acm_publication 
INNER JOIN
	dbo.acm_venue_publication 
ON 
	dbo.acm_publication.id = dbo.acm_venue_publication.publication_id 
INNER JOIN
	dbo.acm_venue 
ON 
	dbo.acm_venue_publication.venue_id = dbo.acm_venue.id 
INNER JOIN
	dbo.acm_venue_series 
ON 
	dbo.acm_venue.venue_series_id = dbo.acm_venue_series.id	
WHERE     
	(dbo.acm_venue_series.id = 'J869')
AND
	dbo.acm_publication.id
NOT IN (
	SELECT
		acm_id
	FROM
		[dbo].[dblp_acm]
)
	
GO
-- ACM Publications of SIGMOD (Journal)

CREATE VIEW 
	[dbo].[ACM_PUBLICATION_SIGMOD_JOURNAL]
AS SELECT     
	dbo.acm_publication.id, 
	dbo.acm_publication.title
FROM         
	dbo.acm_publication 
INNER JOIN
	dbo.acm_venue_publication 
ON 
	dbo.acm_publication.id = dbo.acm_venue_publication.publication_id 
INNER JOIN
	dbo.acm_venue 
ON 
	dbo.acm_venue_publication.venue_id = dbo.acm_venue.id 
INNER JOIN
	dbo.acm_venue_series 
ON 
	dbo.acm_venue.venue_series_id = dbo.acm_venue_series.id	
WHERE     
	(dbo.acm_venue_series.id = 'J689')
AND
	dbo.acm_publication.id
NOT IN (
	SELECT
		acm_id
	FROM
		[dbo].[dblp_acm]
)


GO
-- ACM Transactions on Database Systems (Journal)

CREATE VIEW 
	[dbo].[ACM_PUBLICATION_TRANSACTIONS_JOURNAL]
AS SELECT     
	dbo.acm_publication.id, 
	dbo.acm_publication.title
FROM         
	dbo.acm_publication 
INNER JOIN
	dbo.acm_venue_publication 
ON 
	dbo.acm_publication.id = dbo.acm_venue_publication.publication_id 
INNER JOIN
	dbo.acm_venue 
ON 
	dbo.acm_venue_publication.venue_id = dbo.acm_venue.id 
INNER JOIN
	dbo.acm_venue_series 
ON 
	dbo.acm_venue.venue_series_id = dbo.acm_venue_series.id	
WHERE     
	(dbo.acm_venue_series.id = 'J777')
AND
	dbo.acm_publication.id
NOT IN (
	SELECT
		acm_id
	FROM
		[dbo].[dblp_acm]
)
	
-- ACM Publications of VLDB (Series)
GO

CREATE VIEW 
	[dbo].[ACM_PUBLICATION_VLDB_SERIES]
AS SELECT     
	dbo.acm_publication.id, 
	dbo.acm_publication.title
FROM         
	dbo.acm_publication 
INNER JOIN
	dbo.acm_venue_publication 
ON 
	dbo.acm_publication.id = dbo.acm_venue_publication.publication_id 
INNER JOIN
	dbo.acm_venue 
ON 
	dbo.acm_venue_publication.venue_id = dbo.acm_venue.id 
INNER JOIN
	dbo.acm_venue_series 
ON 
	dbo.acm_venue.venue_series_id = dbo.acm_venue_series.id	
WHERE     
	(dbo.acm_venue_series.id = 'SERIES11272')
AND
	dbo.acm_publication.id
NOT IN (
	SELECT
		acm_id
	FROM
		[dbo].[dblp_acm]
)

-- ACM Publications of SIGMOD (Series)
GO

CREATE VIEW 
	[dbo].[ACM_PUBLICATION_SIGMOD_SERIES]
AS SELECT     
	dbo.acm_publication.id, 
	dbo.acm_publication.title
FROM         
	dbo.acm_publication 
INNER JOIN
	dbo.acm_venue_publication 
ON 
	dbo.acm_publication.id = dbo.acm_venue_publication.publication_id 
INNER JOIN
	dbo.acm_venue 
ON 
	dbo.acm_venue_publication.venue_id = dbo.acm_venue.id 
INNER JOIN
	dbo.acm_venue_series 
ON 
	dbo.acm_venue.venue_series_id = dbo.acm_venue_series.id	
WHERE     
	(dbo.acm_venue_series.id = 'SERIES473')
AND
	dbo.acm_publication.id
NOT IN (
	SELECT
		acm_id
	FROM
		[dbo].[dblp_acm]
)

/*
Create validation views
*/
GO

CREATE VIEW 
	[dbo].[DBLP_ACM_VALIDATION_VIEW]
AS SELECT
	mapping.dblp_id,
	dblp.title as dblp_title,
	--dblp_author.firstname as dblp_firstname,
	--dblp_author.lastname as dblp_lastname,
	--dblp_author.fullname as dblp_fullname,
	dblp.start_page as dblp_start_page,
	dblp.end_page as dblp_end_page,
	mapping.acm_id ,
	acm.title as acm_title,
	--acm_author.name as acm_name,
	acm.start_page as acm_start_page,
	acm.end_page as acm_end_page,
	mapping._Similarity_title as sim_title
FROM
	[dbo].[dblp_acm] mapping
INNER JOIN
	[dbo].[dblp_publication] dblp
ON
	dblp.id = mapping.dblp_id
INNER JOIN
	[dbo].[acm_publication] acm
ON
	acm.id = mapping.acm_id
--INNER JOIN
--	[dbo].[dblp_author_publication] dblp_author_pub
--ON
--	dblp_author_pub.publication_id = dblp.id
--INNER JOIN
--	[dbo].[dblp_author] dblp_author
--ON
--	dblp_author.id = dblp_author_pub.author_id
--INNER JOIN
--	[dbo].[acm_author_publication] acm_author_pub
--ON
--	acm_author_pub.publication_id = acm.id
--INNER JOIN
--	[dbo].[acm_author] acm_author
--ON
--	acm_author.id = acm_author_pub.author_id



