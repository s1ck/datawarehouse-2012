use [dwhprak06]

IF OBJECT_ID('dbo.fk_dblp_author_publication_author') IS NULL AND OBJECT_ID('dbo.fk_dblp_author_publication_pub') IS NULL
ALTER TABLE [dbo].[dblp_author_publication] ADD
	CONSTRAINT [fk_dblp_author_publication_author] FOREIGN KEY ([author_id]) REFERENCES [dbo].[dblp_author](id),
	CONSTRAINT [fk_dblp_author_publication_pub] FOREIGN KEY ([publication_id]) REFERENCES [dbo].[dblp_publication](id)
	
IF OBJECT_ID('dbo.fk_dblp_venue_publication_venue') IS NULL AND OBJECT_ID('dbo.fk_dblp_venue_publication_publication') IS NULL
ALTER TABLE [dbo].[dblp_venue_publication] ADD
	CONSTRAINT [fk_dblp_venue_publication_venue] FOREIGN KEY ([venue_id]) REFERENCES [dbo].[dblp_venue](id),
	CONSTRAINT [fk_dblp_venue_publication_pub] FOREIGN KEY ([publication_id]) REFERENCES [dbo].[dblp_publication](id)
	
IF OBJECT_ID('dbo.fk_dblp_cited_by_pub1') IS NULL AND OBJECT_ID('dbo.fk_dblp_cited_by_pub2') IS NULL
ALTER TABLE [dbo].[dblp_cited_by] ADD
	CONSTRAINT [fk_dblp_cited_by_pub1] FOREIGN KEY (publication1_id) REFERENCES [dbo].[dblp_publication](id),
	CONSTRAINT [fk_dblp_cited_by_pub2] FOREIGN KEY (publication2_id) REFERENCES [dbo].[dblp_publication](id)
