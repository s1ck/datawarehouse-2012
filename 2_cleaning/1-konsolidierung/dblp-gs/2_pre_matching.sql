use [dwhprak06]

/*
Pre-matching on exact matches between google scholar and dblb
*/

-- match on publication titles
-- NOTE: 
-- on the google scholar site there can be multiple entries for one publication
-- this is because the gs publications where inserted based on their existing google scholar ids
-- we need to keep those because in the 3rd task we need to sum up the no_of_cititings

INSERT INTO [dbo].[dblp_gs] (dblp_id, gs_id, _Similarity, _Confidence, _Similarity_title) (
	SELECT
		dblp.id as dblp_id
		--,dblp.title as dblp_title
		,gs.id as gs_id
		--,gs.title as gs_title
		,1.0 as _Similarity
		,1.0 as _Confidence
		,1.0 as _Similarity_title
	FROM
		dbo.dblp_publication dblp
		,dbo.gs_publication gs
	WHERE
		LOWER(dblp.title) = LOWER(gs.title)
	AND
		LOWER(dblp.title)
	NOT IN ('introduction','preface','editorial','foreword')
)