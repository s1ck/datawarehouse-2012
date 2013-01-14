use dwhprak06


INSERT INTO 
	[dbo].[acm_self_cited] (publication1_id, publication2_id, num_same_authors)
	SELECT 
		pub1 as publication1_id,
		pub2 as publication2_id,
		-- there are 9 tuples with different same_author_count from Part 1 and Part 2, we take the max to have unique tuples in the result
		MAX(same_author_count) as same_author_count
	FROM (
		/*
		Part 1:

		This query selects all publication tuples where puplication 1 is cited by publication 2 and both share at least one author.
		Both publications exist in the acm_publication relation.
		*/
		SELECT
			pub1,
			pub2,
			count(*) as same_author_count
		FROM (
			SELECT
				cited.publication1_id as pub1,
				cited.publication2_id as pub2
			from 
				acm_cited_by cited
		) as subsub
		OUTER APPLY (
			-- Intersect of Authors fom Publication 1 and 2 (self citing)
			-- Authors from Publication 1
			SELECT 
				acm_author.id
			FROM
				acm_author
			JOIN
				acm_author_publication
			ON
				acm_author.id = acm_author_publication.author_id
			AND
				acm_author_publication.publication_id = pub1
			INTERSECT
			-- Authors from Publication 2
			SELECT 
				acm_author.id
			FROM
				acm_author
			JOIN
				acm_author_publication
			ON
				acm_author.id = acm_author_publication.author_id
			AND
				acm_author_publication.publication_id = pub2
		) as author
		WHERE
			author.id IS NOT NULL
		GROUP BY
			-- group to get number of same authors between two publications
			pub1,pub2
		HAVING
			count(*) > 0
		-- put this all together with those publications where publication 2 is NOT in
		-- acm_publication (we compare the authors names to get a match)
		UNION
		/*
		Part 2:		

		Select all publication tuples which have similar author names (exact match).
		*/		
		SELECT
			pub1,
			pub2,
			count(*) as same_author_count
		FROM (
			SELECT
				cited.publication1_id as pub1,
				cited.publication2_id as pub2
			FROM 
				acm_cited_by cited			
		) as subsub
		OUTER APPLY (
			-- Authors from Publication 1
			SELECT 
				acm_author.id
			FROM
				acm_author
			JOIN
				acm_author_publication
			ON
				acm_author.id = acm_author_publication.author_id
			AND
				acm_author_publication.publication_id = pub1
			INTERSECT
			-- 
			SELECT
				author_l.id
			FROM
				acm_author author_l
			JOIN(
				-- get all authors from the citingPub.text attribute
				SELECT DISTINCT		
					result.author as name
				FROM 
					[dbo].[acm_cited_by] as [cited_by]
				OUTER APPLY
					[dbo].[build_denormalized_authors_table]([cited_by].[text]) as result
				WHERE
					cited_by.publication2_id = pub2
			) as author_r
			ON
				author_l.name = author_r.name	
			) as author
		WHERE
			author.id IS NOT NULL
		-- this is reeeaaalllllyyy slow (takes about 26 mins instead of 30s)
		--AND
			--NOT EXISTS (SELECT acm_self.publication1_id FROM acm_self_cited acm_self WHERE acm_self.publication1_id = pub1 AND acm_self.publication2_id = pub2)
		GROUP BY
			pub1,pub2
		HAVING
			count(*) > 0
		) as union_dups
	GROUP BY
		pub1, pub2
	--ORDER BY
		--same_author_count DESC











