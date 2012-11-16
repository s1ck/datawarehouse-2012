 use [dwhprak06]

IF OBJECT_ID('dbo.get_part') IS NOT NULL drop function [dbo].[get_part]
IF OBJECT_ID('dbo.last_index_of') IS NOT NULL drop function [dbo].[last_index_of]
IF OBJECT_ID('dbo.splitstring') IS NOT NULL drop function [dbo].[splitstring]
IF OBJECT_ID('dbo.count_occurences') IS NOT NULL drop function [dbo].[count_occurences]
IF OBJECT_ID('dbo.build_denormalized_table') IS NOT NULL drop function [dbo].[build_denormalized_table]

IF OBJECT_ID('dbo.gs_tmp') IS NOT NULL drop table [dbo].[gs_tmp]

GO
-- Returns the last index of @pattern in @string or len(string) if the pattern is not inside
CREATE FUNCTION [dbo].[last_index_of] (
	@pattern varchar(MAX),
	@string varchar(MAX)
) RETURNS
	int
AS
BEGIN
	RETURN LEN(@string) - CHARINDEX(REVERSE(@pattern), REVERSE(@string))
END

GO

-- Returns the number of occurences of @pattern in @string
CREATE FUNCTION [dbo].[count_occurences] (
	@string varchar(MAX),
	@pattern varchar(MAX)
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

-- splits the given given strint at the seperator value and returns a table with all parts
CREATE FUNCTION [dbo].[splitstring] (		
		@stringToSplit varchar(MAX),
		@separator varchar(3) 
) RETURNS
	@returnList TABLE ([value] [varchar] (500))
AS
BEGIN
	DECLARE @name varchar(255)
	DECLARE @pos int

	WHILE CHARINDEX(@separator, @stringToSplit) > 0
	BEGIN
		SET @pos  = CHARINDEX(@separator, @stringToSplit)  
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
    @separator varchar(3),
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
	SET @finish = CHARINDEX(@separator, @value, @start)
	SET @seplen = DATALENGTH(@separator)
	WHILE (@part > 1 AND @finish > 0) 
	BEGIN
		SET @start = @finish + @seplen
		SET @finish = CHARINDEX(@separator, @value, @start)
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
		@i int,
		@j int

	-- do some little cleaning if wanted
	IF @clean = 1
	BEGIN						  
		-- remove some special chars if wanted
		SET @additional = REPLACE(@additional, '&hellip;', '')
		-- remove leading and tailing whitespaces
		SET @additional = LTRIM(RTRIM(@additional))
	END
	
	-- ' - ' is the main seperator in the additional string	
	SET @occurences = [dbo].[count_occurences](@additional, ' - ')

	-- process venue_series and year
	IF @occurences >= 1
		-- in 31 cases, there are 3 ' - ' seperators in the string, this handles it
		IF @occurences = 3
			-- build a new part 2
			SET @tmp_string = [dbo].[get_part](@additional, 2, ' - ', 1) + ' - ' + [dbo].[get_part](@additional, 3, ' - ', 1)
		ELSE
			SET @tmp_string = [dbo].[get_part](@additional, 2, ' - ', 1)

		-- in some cases part 2 is just the year, so check it and leave the rest
		IF ISNUMERIC(@tmp_string) = 1
			SET @year = @tmp_string
		-- in some other cases part2 is already the source field (which has no year in it)
		ELSE IF PATINDEX('% [0-9][0-9][0-9][0-9]%', @tmp_string) = 0 AND @occurences = 1
			SET @source = @tmp_string
		ELSE
		BEGIN
			-- number of commata in part 2
			SET @tmp_int = [dbo].[count_occurences](@tmp_string, ',')
		
			-- year
			-- if there is at least one commata, there is ususally a year after the commata
			IF @tmp_int > 0 -- try to find 4-digit years after the last commata
				SET @year_string = [dbo].[get_part](@tmp_string, @tmp_int + 1, ',', 1)
			ELSE -- in case there is no comma, try to find a 4-digit year in the venue_series and take this one
				SET @year_string = @tmp_string
			SET @i = PATINDEX('%[0-9][0-9][0-9][0-9]%', @year_string)
			IF @i > 0
				SET @year = SUBSTRING(@year_string, @i, 4)

			-- venue-series
			-- venue series is anything before the last commata
			IF @tmp_int > 2
				SET @venue_series = SUBSTRING(@tmp_string, 0, [dbo].[last_index_of](',', @tmp_string))
			ELSE
				SET @venue_series = [dbo].[get_part](@tmp_string, 1,',', 1)
		END

	-- process source
	if @occurences >= 2
		IF @occurences = 2
			SET @source = [dbo].[get_part](@additional, 3, ' - ', 1)
		ELSE
			-- for the string with 3 seperators
			SET @source = [dbo].[get_part](@additional, 4, ' - ', 1)

	-- process authors (authors are always available)
	-- insert one row for each author including its position in the string
	SET @authors = [dbo].[get_part](@additional, 1, ' - ', 1)
	SET @author_count = [dbo].[count_occurences](@authors, ',') + 1	
	SET @i = 1 -- for the author pos
	SET @j = 1 -- for the while loop
	WHILE @j <= @author_count
	BEGIN
		SET @author = [dbo].[get_part](@authors, @j, ',', 1)
		-- remove the '...' from the authors name
		--IF PATINDEX('%&hellip;%', @author) > 0
		--	SET @author = LTRIM(RTRIM(REPLACE(@author, '&hellip;', '')))
		-- when there are special chars before the author has length 0		
		IF (LEN(@author) > 0)
		BEGIN
			INSERT INTO @result (author, author_pos, year, venue_series, source)
				SELECT @author, @i, @year, @venue_series, @source
			SET @i = @i + 1
		END
		SET @j = @j + 1
	END

	RETURN
END

GO

CREATE TABLE [dbo].[gs_tmp] (
	[gs_id] numeric(20,0),
	[title] varchar(1000),
	[url] varchar(600),
	[no_of_citings] int,
    --[additional] varchar(1000),
	[author] varchar(200),
	[author_pos] smallint,
	[venue_series] varchar(500),
	[year] int,
	[source] varchar(255)
	PRIMARY KEY (gs_id, author, author_pos)
)

INSERT INTO [dbo].[gs_tmp] (gs_id, title, url, no_of_citings, author, author_pos, venue_series, year, source)
	SELECT	--TOP 100
		gs.id as id,
		gs.title,
		gs.url,
		gs.no_of_citings,
		--gs.additional as additional,
		result.author,
		result.author_pos,
		result.venue_series,
		result.year as year,
		result.source
	FROM 
		[dbo].[gs_denormalized] as gs
	OUTER APPLY
		[dbo].[build_denormalized_table](gs.Additional, 0) as result 


-- Analytical Queries

-- get number of occurences of ' - ' and the corresponding number of entities
-- SELECT [dbo].[count_occurences](additional,' - ') as number_of_seps, count(id) FROM gs_denormalized GROUP BY [dbo].[count_occurences](additional,' - ') ORDER BY number_of_seps DESC

-- TODO:

-- when there are special chars like &hellip; at the beginning of the authors field, this is counted as one author, so the pos for the others is not correct [DONE]

-- handle cases where there are 3 seperators [DONE]
-- SELECT [dbo].[count_occurences](additional,' - ') as number_of_seps, additional, id FROM gs_denormalized WHERE [dbo].[count_occurences](additional, ' - ') = 3

-- handle cases where there are 0 seperators [DONE]
-- SELECT [dbo].[count_occurences](additional,' - ') as number_of_seps, additional, id FROM gs_denormalized WHERE [dbo].[count_occurences](additional, ' - ') = 0 ORDER BY additional

-- handle part 2 with multiple commas (currently only the first part is used as venue_series) [DONE]

-- check if additional only contains of <author> - <source> (validate with id 11238173839627016) [DONE]

-- if the year is not the last (comma seperated) part in the part2, then try to find a 4-digit number in whole part2 [DONE]

-- some years are in 2-digit format and not separated by , from the venue_series (validate with 3620827803844651)

-- check if it makes sense to store the author pos when the author string starts with '...'

-- problem-ids (not complete):

-- 8623493352720403, 23798054753065399 (shortened names because of '...' removal)