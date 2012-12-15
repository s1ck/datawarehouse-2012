use [dwhprak06]

/*
This script contains all work to match DBLP and ACM publications without using the Fuzzy Search
*/

-- title exact matcher

INSERT INTO [dbo].[dblp_acm] (dblp_id, acm_id, _Similarity, _Confidence, _Similarity_title) (
	SELECT
		dblp.id as dblp_id
		,acm.id as acm_id
		,1.0 as _Similarity
		,1.0 as _Confidence
		,1.0 as _Similarity_title
	FROM
		[dbo].[dblp_publication] as dblp,
		[dbo].[acm_publication] as acm
	WHERE
		LOWER(dblp.title) = LOWER(acm.title)	
	AND
		LOWER(dblp.title)
	NOT IN ('introduction','preface','editorial','foreword')
	--AND
		--dblp.start_page = acm.start_page
	--AND
		--dblp.end_page = acm.end_page
)