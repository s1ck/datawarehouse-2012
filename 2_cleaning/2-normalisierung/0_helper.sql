use dwhprak06 

IF OBJECT_ID('dbo.remove_email') IS NOT NULL DROP FUNCTION [dbo].[remove_email]
IF OBJECT_ID('dbo.remove_numbers') IS NOT NULL DROP FUNCTION [dbo].[remove_numbers]
IF OBJECT_ID('dbo.normalize_patterns') IS NOT NULL DROP FUNCTION [dbo].[normalize_patterns]
IF OBJECT_ID('dbo.crap_grepper') IS NOT NULL DROP FUNCTION [dbo].[crap_grepper]
IF OBJECT_ID('dbo.university_stripper') IS NOT NULL DROP FUNCTION [dbo].[university_stripper]


GO

-- searches for parts with an @ in it and removes them (can't be a university name)

CREATE FUNCTION [dbo].[remove_email] (
	@text varchar(max)
) RETURNS varchar(255)
AS
BEGIN
	DECLARE @pos int,
		@i int,
		@parts int,		
		@mail varchar(255)

	SET @pos = CHARINDEX('@', @text)	
	WHILE @pos > 0 -- there is at least one an email in it
	BEGIN
		-- check how many parts this thingy has
		SET @parts = [dbo].[count_occurences](@text, ' ')
		IF @parts > 1
		BEGIN
			SET @i = 1
			SET @mail =[dbo].[get_part](@text, @i, ' ', 1)
			WHILE CHARINDEX('@', @mail) = 0
			BEGIN
				SET @i = @i + 1			
				SET @mail =[dbo].[get_part](@text, @i, ' ', 1)
			END
			-- replace it
			SET @text = REPLACE(@text, @mail, '')
			SET @pos = CHARINDEX('@', @text) -- check for more emails
		END
	END
	return @text
END

GO

CREATE FUNCTION [dbo].[remove_numbers](
	@text varchar(max)
)
RETURNS varchar(255)
AS
BEGIN
	DECLARE @number varchar(255)
		,@stop int
	WHILE PATINDEX('%[0-9]%', @text) > 0
	BEGIN
		SET @number = SUBSTRING(@text, PATINDEX('%[0-9]%', @text), LEN(@text))
		SET @stop = PATINDEX('%[^0-9]%', @number)
		IF @stop = 0
			SET @stop = LEN(@number) + 1
		SET @number = SUBSTRING(@number, 0, @stop)
		SET @text = REPLACE(@text, @number, '')
	END
	return @text
END

GO

CREATE FUNCTION [dbo].[normalize_patterns] (
	@text varchar(255)
)
RETURNS varchar(255)
AS
BEGIN
	-- replacement rules	
	SET @text = REPLACE(@text, 'Technische Univ.', 'Technical University of')
	SET @text = REPLACE(@text, 'Technische Universität', 'Technical University of')
	SET @text = REPLACE(@text, 'Universität', 'University of')
	SET @text = REPLACE(@text, 'Univ.', 'University')
	SET @text = REPLACE(@text, 'Institut für Informatik', 'Institute for Computer Science')
	
	RETURN @text
END

GO

CREATE FUNCTION [dbo].[university_stripper] (
	@text varchar(255)
)
RETURNS varchar(255)
AS
BEGIN
	DECLARE @start int,
		@stop int

	SET @start = PATINDEX('%university of%', @text)
	IF @start > 0
	BEGIN
		-- crashed with things like 'University of Western Ontario'
		--SET @stop = CHARINDEX(' ', @text, @start + 14)
		--IF @stop = 0
		SET @stop = LEN(@text) + 1
		SET @text = SUBSTRING(@text, @start, @stop - @start)
	END
	RETURN @text
END

GO

CREATE FUNCTION [dbo].[crap_grepper] (
	@text varchar(255)
)
RETURNS varchar(255)
AS
BEGIN
	-- replace crap
	SET @text = REPLACE(@text, '(', '')
	SET @text = REPLACE(@text, ')', '')
	SET @text = REPLACE(@text, ';', '')
	SET @text = REPLACE(@text, ',', '')
	SET @text = REPLACE(@text, ':', '')
	--SET @text = REPLACE(@text, '-', '') -- often used in addresses
	SET @text = REPLACE(@text, 'Email', '')
	SET @text = REPLACE(@text, 'email', '')
	SET @text = REPLACE(@text, 'E-Mail', '')
	SET @text = REPLACE(@text, 'e-mail', '')
	SET @text = REPLACE(@text, 'e-Mail', '')
	SET @text = REPLACE(@text, 'Mail', '')
	SET @text = REPLACE(@text, 'mail', '')
	SET @text = REPLACE(@text, '  ', ' ')

	RETURN @text
END
