 use [dwhprak06]

IF OBJECT_ID('dbo.get_part') IS NOT NULL drop function [dbo].[get_part]
IF OBJECT_ID('dbo.splitstring') IS NOT NULL drop function [dbo].[splitstring]
IF OBJECT_ID('dbo.count_occurences') IS NOT NULL drop function [dbo].[count_occurences]
IF OBJECT_ID('dbo.build_denormalized_table') IS NOT NULL drop function [dbo].[build_denormalized_table]

GO

-- Returns the number of occurences of @pattern in @string
CREATE FUNCTION [dbo].[count_occurences] (
	@string varchar(MAX),
	@pattern varchar(100)
) RETURNS
	int
AS
BEGIN
	-- Subtract the length of the string without the pattern occurences from
	-- the original length to get the total length of all pattern occurences, 
	-- then divide it with the length of one pattern.

	-- LEN cannot be used here, because it uses RTRIM intenally and strips tailing whitespaces
	-- out of the pattern, so DATALENGTH is the right choice
	RETURN (DATALENGTH(@string) - DATALENGTH(REPLACE(@string, @pattern, ''))) / DATALENGTH(@pattern);
END

GO

CREATE FUNCTION [dbo].[splitstring] (		
		@stringToSplit VARCHAR(MAX),
		@seperator nvarchar(3) 
) RETURNS
	@returnList TABLE ([value] [nvarchar] (500))
AS
BEGIN
	DECLARE @name NVARCHAR(255)
	DECLARE @pos INT

	WHILE CHARINDEX(@seperator, @stringToSplit) > 0
	BEGIN
		SET @pos  = CHARINDEX(@seperator, @stringToSplit)  
		SET @name = SUBSTRING(@stringToSplit, 1, @pos-1)

		SET @name = RTRIM(LTRIM(@name))
		INSERT INTO @returnList 
			SELECT @name

		SET @stringToSplit = SUBSTRING(@stringToSplit, @pos+1, LEN(@stringToSplit)-@pos)
	END

	INSERT INTO @returnList
		SELECT RTRIM(LTRIM(@stringToSplit))
	RETURN
END

GO

 CREATE FUNCTION [dbo].[get_part] (
	-- input text
	@value varchar(4000), 
	-- which part of it
	@part int,
	-- seperator char
    @seperator varchar(3),
	-- trim true / false
	@trim bit = 1
)
RETURNS varchar(4000)
AS 
BEGIN
	DECLARE @start int,
		@finish int,
		@seplen int,
		@return varchar(4000)
	
	SET @start = 1
	SET @finish = CHARINDEX(@seperator, @value, @start)
	SET @seplen = DATALENGTH(@seperator)
	WHILE (@part > 1 AND @finish > 0) 
	BEGIN
		SET @start = @finish + @seplen
		SET @finish = CHARINDEX(@seperator, @value, @start)
		SET @part = @part - 1
	END

	IF @part > 1 --not found
		SET @start = LEN(@value) + @seplen 
	IF @finish = 0 --last token on line
		SET @finish = LEN(@value) + @seplen 

	SET @return = SUBSTRING(@value, @start, @finish - @start)

	IF @trim = 1
		SET @return = LTRIM(RTRIM(@return))
	RETURN @return
End

GO

CREATE FUNCTION [dbo].[build_denormalized_table] (
	@additional varchar(4000),
	@clean bit = 1
) 
RETURNS @result TABLE (
	[author] varchar(1000),
	[author_pos] int,
	[venue_series] varchar(1000),
	[year] int,
	[source] varchar(1000)
)
AS
BEGIN
	DECLARE @occurences int,
		@authors varchar(1000),
		@author varchar(255),
		@author_count int,
		@venue_series varchar(1000),
		@year int,
		@year_string varchar(10),
		@source varchar(1000),
		@tmp_string varchar(1000),
		@tmp_int int,
		@i int

	-- do some little cleaning if wanted
	IF @clean = 1
	BEGIN						  
		-- remove some special chars if wanted
		SET @additional = REPLACE(@additional, '&hellip;', '')
		-- remove leading and tailing whitespaces
		SET @additional = LTRIM(RTRIM(@additional))
	END
	
	SET @occurences = [dbo].[count_occurences](@additional, ' - ')

	-- process venue_series and year
	IF @occurences >= 1
		-- in 31 cases, there are 3 ' - ' seperators in the string, this handles it
		IF @occurences = 3
			SET @tmp_string = [dbo].[get_part](@additional, 2, ' - ', 1) + ' - ' + [dbo].[get_part](@additional, 3, ' - ', 1)
		ELSE
			SET @tmp_string = [dbo].[get_part](@additional, 2, ' - ', 1)

		-- in some cases part 2 is just the year, so check it and leave the rest
		IF ISNUMERIC(@tmp_string) = 1
			SET @year = @tmp_string
		ELSE
		BEGIN
			SET @tmp_int = [dbo].[count_occurences](@tmp_string, ',')
		
			-- venue-series
			SET @venue_series = [dbo].[get_part](@tmp_string, 1,',', 1) 

			-- year
			-- if there are more than one comma, there is ususally a year in it on the last position
			IF @tmp_int > 0				
				--SET @year_string = [dbo].[get_part](@tmp_string, @tmp_int + 1, ',', 1)
				--SET @year_string = LTRIM(RTRIM(@year_string))
				SET @i = PATINDEX('%[0-9][0-9][0-9][0-9]%', @tmp_string)
				SET @year_string = SUBSTRING(@tmp_string, @i, 4)
				IF ISNUMERIC(@year_string) = 1
					SET @year = @year_string
		END

	-- process source
	if @occurences >= 2
		IF @occurences = 2
			SET @source = [dbo].[get_part](@additional, 3, ' - ', 1)
		ELSE
			-- for the string with 3 seperators
			SET @source = [dbo].[get_part](@additional, 4, ' - ', 1)

	-- authors are always available
	SET @authors = [dbo].[get_part](@additional, 1, ' - ', 1)
	SET @author_count = [dbo].[count_occurences](@authors, ',') + 1	
	SET @i = 1
	WHILE @i <= @author_count
	BEGIN
		SET @author = [dbo].[get_part](@authors, @i, ',', 1)
		-- when there are special chars before the author has length 0
		IF LEN(@author) > 0		
			INSERT INTO @result (author, author_pos, year, venue_series, source)
				SELECT @author, @i, @year, @venue_series, @source
		SET @i = @i + 1		
	END

	RETURN
END

GO

SELECT	
	gs.id,
	gs.additional,
	result.author,
	result.author_pos,
	result.venue_series,
	result.year,
	result.source
FROM 
	[dbo].[gs_denormalized] as gs
OUTER APPLY
	[dbo].[build_denormalized_table](gs.Additional, 1) as result
--WHERE
--	gs.id = 12292286922714753276

-- Analytical Queries

-- get number of occurences of ' - ' and the corresponding number of entities
-- SELECT [dbo].[count_occurences](additional,' - ') as number_of_seps, count(id) FROM gs_denormalized GROUP BY [dbo].[count_occurences](additional,' - ') ORDER BY number_of_seps DESC

-- TODO:

-- some years are in 2-digit format and not separated by , from the venue_series
-- when there are special chars like &hellip; at the beginning of the authors field, this is counted as one author, so the pos for the others is not correct

-- handle cases where there are 3 seperators [DONE]
-- SELECT [dbo].[count_occurences](additional,' - ') as number_of_seps, additional, id FROM gs_denormalized WHERE [dbo].[count_occurences](additional, ' - ') = 3

-- handle cases where there are 0 seperators
-- SELECT [dbo].[count_occurences](additional,' - ') as number_of_seps, additional, id FROM gs_denormalized WHERE [dbo].[count_occurences](additional, ' - ') = 0 ORDER BY additional