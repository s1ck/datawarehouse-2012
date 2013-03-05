use dwhprak06

-- author
-- this is not deterministic!!!
UPDATE
	dbo.cube_Author
SET
	dbo.cube_Author.institution = view_auth.inst_name
FROM
	dbo.cube_Author cube_auth
INNER JOIN
	dbo.CUBE_DBLP_ACM_AUTHOR view_auth
ON
	cube_auth.id = view_auth.auth_id
	
-- citings gs
UPDATE
	dbo.cube_Publication
SET
	dbo.cube_Publication.citingsGS = dblp_gs.citingsGS
FROM
	dbo.cube_Publication pub
JOIN
	dbo.CUBE_DBLP_GS dblp_gs
ON
	pub.titleId = dblp_gs.dblp_pubId
	
-- acm citings
UPDATE
	dbo.cube_Publication
SET
	dbo.cube_Publication.citingsACM = dblp_acm.citingsACM 
FROM
	dbo.cube_Publication as pub
JOIN
	dbo.CUBE_DBLP_ACM_CITINGS as dblp_acm
ON
	pub.titleId = dblp_acm.dblp_pubId
	
-- acm self citings
UPDATE
	dbo.cube_Publication
SET
	dbo.cube_Publication.citingsACMSelf = dblp_acm.citingsACMSelf
FROM
	dbo.cube_Publication as pub
JOIN
	dbo.CUBE_DBLP_ACM_SELF_CITINGS as dblp_acm
ON
	pub.titleId = dblp_acm.dblp_pubId