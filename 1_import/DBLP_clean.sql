use [dwhprak06] 

if OBJECT_ID('dbo.dblp_venue_series_publication') IS NOT NULL drop table [dbo].[dblp_venue_series_publication]

if OBJECT_ID('dbo.dblp_publication') IS NOT NULL
	ALTER TABLE
			[dbo].[dblp_publication]
		DROP COLUMN
			[year]
			
if OBJECT_ID('dbo.dblp_venue') IS NOT NULL
	ALTER TABLE
			[dbo].[dblp_venue]
		DROP COLUMN
			[publication_id]