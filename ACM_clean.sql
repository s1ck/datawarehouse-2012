use [dwhprak06]

-- DROP TEMPORARY TABLES

if OBJECT_ID('dbo.acm_author_tmp') IS NOT NULL DROP TABLE [dbo].[acm_author_tmp]
if OBJECT_ID('dbo.acm_citing_pub_tmp') IS NOT NULL DROP TABLE [dbo].[acm_citing_pub_tmp]
if OBJECT_ID('dbo.acm_publication_tmp') IS NOT NULL DROP TABLE [dbo].[acm_publication_tmp]
if OBJECT_ID('dbo.acm_venue_tmp') IS NOT NULL DROP TABLE [dbo].[acm_venue_tmp]
if OBJECT_ID('dbo.acm_venue_series_tmp') IS NOT NULL DROP TABLE [dbo].[acm_venue_series_tmp]