use dwhprak06

IF OBJECT_ID('dbo.gs_venue') IS NOT NULL drop table [dbo].[gs_venue]

IF OBJECT_ID('dbo.SENSELESS_FUNCTION_BECAUSE_OF_OWN_STUPIDITY') IS NOT NULL DROP FUNCTION [dbo].[SENSELESS_FUNCTION_BECAUSE_OF_OWN_STUPIDITY]

GO

CREATE FUNCTION SENSELESS_FUNCTION_BECAUSE_OF_OWN_STUPIDITY()
RETURNS INT
AS
BEGIN
	DECLARE @result int
	SELECT @result = id FROM gs_venue_series where name IS NULL
	RETURN @result
END

GO

CREATE TABLE [dbo].[gs_venue] (
	[id] bigint NOT NULL PRIMARY KEY IDENTITY,
	[title] varchar(255),
	[year] int,
	[venue_series_id] bigint
	--FOREIGN KEY ([venue_series_id]) REFERENCES [dbo].[gs_venue_series](id)
)

INSERT INTO [dbo].[gs_venue] ([year], [venue_series_id])
	SELECT year, venue_series_id FROM (
		SELECT DISTINCT
			tmp.gs_id,
			tmp.year as year,		
			vs.id as venue_series_id
		FROM
			gs_tmp tmp
		LEFT OUTER JOIN
			gs_venue_series vs
		ON
			vs.name = tmp.venue_series
		) as subselect


		
UPDATE 
	[dbo].[gs_venue]
SET
	[venue_series_id] = [dbo].[SENSELESS_FUNCTION_BECAUSE_OF_OWN_STUPIDITY]()
WHERE
	[venue_series_id] IS NULL


ALTER TABLE [dbo].[gs_venue] 
	ADD CONSTRAINT fk_gs_venue_venue_series_id FOREIGN KEY ([venue_series_id]) REFERENCES [dbo].[gs_venue_series](id)