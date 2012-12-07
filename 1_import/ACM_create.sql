USE [dwhprak06]

if OBJECT_ID('dbo.acm_author_tmp') IS NOT NULL drop table [dbo].[acm_author_tmp]
if OBJECT_ID('dbo.acm_citing_pub_tmp') IS NOT NULL drop table [dbo].[acm_citing_pub_tmp]
if OBJECT_ID('dbo.acm_publication_tmp') IS NOT NULL drop table [dbo].[acm_publication_tmp]
if OBJECT_ID('dbo.acm_venue_tmp') IS NOT NULL drop table [dbo].[acm_venue_tmp]
if OBJECT_ID('dbo.acm_venue_series_tmp') IS NOT NULL drop table [dbo].[acm_venue_series_tmp]

/*
The ACM Data is imported in temporary tables first. After that, the data will be normalized into the final schema.
*/

CREATE TABLE [dbo].[acm_author_tmp] (
	-- defined by XSD
    [pos] tinyint,
    [name] nvarchar(255),
    [institution] nvarchar(255),
	-- line number in source XML
    [publication_id] numeric(20,0)
)

-- mapping table between publications
CREATE TABLE [dbo].[acm_citing_pub_tmp] (
	-- manual attributes
	[pk_id] bigint NOT NULL PRIMARY KEY IDENTITY,

	-- defined by XSD
	-- publication A ...
	-- line number in source XML
	[publication_id] numeric(20,0) NOT NULL,
	-- ... has cited publication B
    [id] bigint NOT NULL,
    [text] nvarchar(4000)    
)

CREATE TABLE [dbo].[acm_publication_tmp] (
    [id] bigint,
    [title] nvarchar(1000),
    [fulltext] nvarchar(255),
    [start_page] int,
    [end_page] int,
	-- line number in source XML
    [publication_id] numeric(20,0)
)

CREATE TABLE [dbo].[acm_venue_tmp] (
    [id] bigint,
    [year] int,
    [text] nvarchar(255),
	-- line number in source XML
    [publication_id] numeric(20,0)
)

CREATE TABLE [dbo].[acm_venue_series_tmp] (
    [id] nvarchar(255),
    [text] nvarchar(255),
	-- line number in source XML
    [publication_id] numeric(20,0)
)
