use [dwhprak06]

if OBJECT_ID('dbo.acm_author_institution') IS NOT NULL drop table [dbo].[acm_author_institution]
if OBJECT_ID('dbo.acm_venue_publication') IS NOT NULL drop table [dbo].[acm_venue_publication]
if OBJECT_ID('dbo.acm_author_publication') IS NOT NULL drop table [dbo].[acm_author_publication]
if OBJECT_ID('dbo.acm_cited_by') IS NOT NULL drop table [dbo].[acm_cited_by]
if OBJECT_ID('dbo.acm_venue') IS NOT NULL drop table [dbo].[acm_venue]
if OBJECT_ID('dbo.acm_venue_series') IS NOT NULL drop table [dbo].[acm_venue_series]
if OBJECT_ID('dbo.acm_institution') IS NOT NULL drop table [dbo].[acm_institution]
if OBJECT_ID('dbo.acm_author') IS NOT NULL drop table [dbo].[acm_author]
if OBJECT_ID('dbo.acm_fulltext') IS NOT NULL drop table [dbo].[acm_fulltext]
if OBJECT_ID('dbo.acm_publication') IS NOT NULL drop table [dbo].[acm_publication]

-- Publication

CREATE TABLE [dbo].[acm_publication] (
	[id] bigint NOT NULL PRIMARY KEY,
	[title] nvarchar(1000) NOT NULL,	
	[start_page] int,
	[end_page] int
)
-- 5516
INSERT INTO [dbo].[acm_publication] (id, title, start_page, end_page) 
	SELECT		
		distinct(pub.id) as id,
		pub.title as title,		 
		pub.start_page as start_page, 
		pub.end_page as end_page
	FROM 
		dbo.acm_publication_tmp pub	

-- eo Publication

-- Fulltext

CREATE TABLE [dbo].[acm_fulltext] (
	[id] bigint NOT NULL PRIMARY KEY IDENTITY,
	[publication_id] bigint NOT NULL,
	[fulltext] nvarchar(255),
	FOREIGN KEY ([publication_id]) REFERENCES [dbo].[acm_publication](id)
)

INSERT INTO [dbo].[acm_fulltext] (publication_id, fulltext)
	SELECT
		distinct(pub.id),
		pub.fulltext
	FROM
		[dbo].[acm_publication_tmp] pub
	WHERE pub.fulltext IS NOT NULL

-- eo fulltext

-- Author

CREATE TABLE [dbo].[acm_author] (
	[id] bigint NOT NULL PRIMARY KEY IDENTITY,
	[name] nvarchar(255) NOT NULL	
)

INSERT INTO [dbo].[acm_author] (name)
	SELECT
		distinct(name)		
	FROM
		[dbo].[acm_author_tmp]

-- eo Author

-- Institution

CREATE TABLE [dbo].[acm_institution] (
	[id] bigint NOT NULL PRIMARY KEY IDENTITY,
	[name] nvarchar(255)
)

INSERT INTO [dbo].[acm_institution] (name)
	SELECT
		distinct(institution) as name
	FROM
		[dbo].[acm_author_tmp]

-- eo Institution

-- VenueSeries

CREATE TABLE [dbo].[acm_venue_series] (
	[id] nvarchar(15) NOT NULL PRIMARY KEY,
	[name] nvarchar(70)
)

INSERT INTO [dbo].[acm_venue_series] (id, name)
	SELECT
		distinct(id),
		text as name
	FROM
		[dbo].[acm_venue_series_tmp]

-- eo VenueSeries

-- Venue

CREATE TABLE [dbo].[acm_venue] (
	[id] bigint NOT NULL PRIMARY KEY IDENTITY,
	-- need this because of id 645926 (2 different years)
	[oid] bigint NOT NULL,
	[year] int,
	[name] nvarchar(255),
	[venue_series_id] nvarchar(15) NOT NULL,
	FOREIGN KEY (venue_series_id) REFERENCES [dbo].[acm_venue_series](id)
)

INSERT INTO [dbo].[acm_venue] (oid, year, name, venue_series_id)
	SELECT
		distinct(venue.id) as oid,
		venue.year,
		venue.text as name,
		venue_series.id as venue_series_id
	FROM
		[dbo].[acm_venue_tmp] venue,
		[dbo].[acm_venue_series_tmp] venue_series
	WHERE
		venue.publication_id = venue_series.publication_id

-- eo Venue

-- Cited_by

CREATE TABLE [dbo].[acm_cited_by] (
	[publication1_id] bigint NOT NULL,
	[publication2_id] bigint NOT NULL,
	[text] nvarchar(4000),
	PRIMARY KEY (publication1_id, publication2_id),
	FOREIGN KEY (publication1_id) REFERENCES [dbo].[acm_publication](id)
	-- there cannot be a foreign key relation because there	
	-- are citing pubs which are no existing publications
	-- FOREIGN KEY (publication2_id) REFERENCES [dbo].[acm_publication](id)
)

INSERT INTO [dbo].[acm_cited_by] (publication1_id, publication2_id, text)
	SELECT
		distinct(pub.id) as publication1_id,
		cb.id as publication2_id,
		cb.text as text
	FROM
		[dbo].[acm_publication_tmp] pub,
		[dbo].[acm_citing_pub_tmp] cb
	WHERE
		pub.publication_id = cb.publication_id

-- Author_Publication

CREATE TABLE [dbo].[acm_author_publication] (
	[author_id] bigint NOT NULL,
	[publication_id] bigint NOT NULL,
	[pos] tinyint,
	[institution_id] bigint,
	PRIMARY KEY (author_id, publication_id, institution_id),
	FOREIGN KEY (author_id) REFERENCES [dbo].[acm_author](id),
	FOREIGN KEY (publication_id) REFERENCES [dbo].[acm_publication](id),
	FOREIGN KEY (institution_id) REFERENCES [dbo].[acm_institution](id)
)

INSERT INTO [dbo].[acm_author_publication] (author_id, publication_id, pos, institution_id)
	SELECT
		distinct(author.id) as author_id,
		pub.id as pub_id,
		author_tmp.pos as pos,
		inst.id as institution_id
	FROM
		[dbo].[acm_author] author,
		[dbo].[acm_author_tmp] author_tmp,
		[dbo].[acm_publication_tmp] pub,
		[dbo].[acm_institution] inst
	WHERE
		author_tmp.publication_id = pub.publication_id
	AND
		author.name = author_tmp.name
	AND
		author_tmp.institution = inst.name

-- eo Author_Publication

-- Venue_Publication

CREATE TABLE [dbo].[acm_venue_publication] (
	[venue_id] bigint NOT NULL,
	[publication_id] bigint NOT NULL,
	PRIMARY KEY (venue_id, publication_id),
	FOREIGN KEY (venue_id) REFERENCES [dbo].[acm_venue](id),
	FOREIGN KEY (publication_id) REFERENCES [dbo].[acm_publication](id)
)

INSERT INTO [dbo].[acm_venue_publication] (venue_id, publication_id)
	SELECT
		venue.id as venue_id,
		pub.id as publication_id
	FROM
		[dbo].[acm_venue] venue,
		[dbo].[acm_venue_tmp] venue_tmp,
		[dbo].[acm_publication_tmp] pub
	WHERE
		venue_tmp.publication_id = pub.publication_id
	AND
		venue.oid = venue_tmp.id

-- eo Venue_Publication

-- Venue_Venueseries
/*
CREATE TABLE [dbo].[acm_venue_venueseries] (
	[venue_id] bigint NOT NULL,
	[venueseries_id] nvarchar(15) NOT NULL,
	PRIMARY KEY (venue_id, venueseries_id),
	FOREIGN KEY (venue_id) REFERENCES [dbo].[acm_venue](id),
	FOREIGN KEY (venueseries_id) REFERENCES [dbo].[acm_venue_series](id)
)

INSERT INTO [dbo].[acm_venue_venueseries] (venue_id, venueseries_id)
	SELECT
		distinct(venue.id) as venue_id,
		venueseries.id as venueseries_id
	FROM
		[dbo].[acm_venue] venue,
		[dbo].[acm_venue_tmp] venue_tmp,
		[dbo].[acm_venue_series_tmp] venueseries
	WHERE
		venue.oid = venue_tmp.id
	AND
		venue_tmp.publication_id = venueseries.publication_id
*/
-- eo Venue_Venueseries

-- Author_Institution

CREATE TABLE [dbo].[acm_author_institution] (
	[author_id] bigint NOT NULL,
	[institution_id] bigint NOT NULL,
	PRIMARY KEY (author_id, institution_id),
	FOREIGN KEY (author_id) REFERENCES [dbo].[acm_author](id),
	FOREIGN KEY (institution_id) REFERENCES [dbo].[acm_institution](id)
)

INSERT INTO [dbo].[acm_author_institution] (author_id, institution_id)
	SELECT
		distinct(author.id) as author_id,
		institution.id as institution_id
	FROM
		[dbo].[acm_author_tmp] as author_tmp,
		[dbo].[acm_author] as author,
		[dbo].[acm_institution] as institution
	WHERE
		author_tmp.institution = institution.name
	AND
		author_tmp.name = author.name

-- eo Author_Institution
