use [dwhprak06]

IF OBJECT_ID('dbo.fk_author_publication_author') IS NULL AND OBJECT_ID('dbo.fk_author_publication_pub') IS NULL
ALTER TABLE [dbo].[dblp_author_publication] ADD
	CONSTRAINT [fk_author_publication_author] FOREIGN KEY ([author_id]) REFERENCES [dbo].[dblp_author](id),
	CONSTRAINT [fk_author_publication_pub] FOREIGN KEY ([publication_id]) REFERENCES [dbo].[dblp_publication](id)

IF OBJECT_ID('dbo.fk_venue_series_publication_venue_series') IS NULL AND OBJECT_ID('dbo.fk_venue_series_publication_pub') IS NULL
	ALTER TABLE [dbo].[dblp_venue_series_publication] ADD
		CONSTRAINT [fk_venue_series_publication_venue_series] FOREIGN KEY ([venue_series_id]) REFERENCES [dbo].[dblp_venue_series](id),
		CONSTRAINT [fk_venue_publication_pub] FOREIGN KEY ([publication_id]) REFERENCES [dbo].[dblp_publication](id)
