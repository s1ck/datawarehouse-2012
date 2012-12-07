use dwhprak06

-- drop tables
IF OBJECT_ID('dbo.acm_institution_fuzzy_grouped') IS NOT NULL DROP TABLE [dbo].[acm_institution_fuzzy_grouped]
IF OBJECT_ID('dbo.acm_insitution_normalized') IS NOT NULL DROP TABLE [dbo].[acm_insitution_normalized]

-- drop views
IF OBJECT_ID('dbo.acm_cleaned_institutions') IS NOT NULL DROP VIEW [dbo].[ACM_CLEANED_INSTITUTIONS]

GO

-- result table for fuzzy grouping

CREATE TABLE [dbo].[acm_institution_fuzzy_grouped] (
    [_key_in] int,
    [_key_out] int,
    [_score] real,
    [id] bigint,
    [name] nvarchar(4000),
    [name_clean] nvarchar(4000),
    [_Similarity_name] real
)

-- table for normalized institutions

CREATE TABLE [dbo].[acm_insitution_normalized] (
	[id] bigint PRIMARY KEY,
	[name] nvarchar(255)
)

GO

-- normalization of institute names for better fuzzy grouping results

INSERT INTO [dbo].[acm_insitution_normalized] (id, name) (
	SELECT 
		id,
		[dbo].[university_stripper](
			[dbo].[normalize_patterns](
				[dbo].[remove_numbers](	
					[dbo].[remove_email](
						[dbo].[crap_grepper](
							name
						)
					)
				)
			)
		)
		AS name
	FROM 
		[dbo].[acm_institution]
)
