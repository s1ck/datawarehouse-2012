 use [dwhprak06]

 IF OBJECT_ID('dbo.gs_venue') IS NOT NULL
		ALTER TABLE
			[dbo].[gs_venue]
		DROP COLUMN
			[publication_id]

--IF OBJECT_ID('dbo.gs_tmp') IS NOT NULL DROP TABLE [dbo].[gs_tmp]
IF OBJECT_ID('dbo.gs_denormalized') IS NOT NULL DROP TABLE [dbo].[gs_denormalized]