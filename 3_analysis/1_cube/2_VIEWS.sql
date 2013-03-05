use dwhprak06

IF OBJECT_ID('dbo.CUBE_DBLP_ACM_AUTHOR') IS NOT NULL DROP VIEW [dbo].[CUBE_DBLP_ACM_AUTHOR]
IF OBJECT_ID('dbo.CUBE_DBLP_GS') IS NOT NULL DROP VIEW [dbo].[CUBE_DBLP_GS]
IF OBJECT_ID('dbo.CUBE_DBLP_ACM_CITINGS') IS NOT NULL DROP VIEW [dbo].[CUBE_DBLP_ACM_CITINGS]
IF OBJECT_ID('dbo.CUBE_DBLP_ACM_SELF_CITINGS') IS NOT NULL DROP VIEW [dbo].[CUBE_DBLP_ACM_SELF_CITINGS]

-- get the surrogate institution for relevant dblp authors
GO
CREATE VIEW CUBE_DBLP_ACM_AUTHOR AS
SELECT
	acm_auth_pub.publication_id AS pub_id
	,dblp_auth.id AS auth_id
	,acm_inst_surrogate.name AS inst_name
FROM
	dbo.acm_author_publication acm_auth_pub
JOIN
	dbo.acm_author acm_auth
ON
	acm_auth_pub.author_id = acm_auth.id
JOIN
	dbo.dblp_author dblp_auth
ON
	dblp_auth.fullname = acm_auth.name
JOIN
	dbo.acm_institution acm_inst
ON
	acm_auth_pub.institution_id = acm_inst.id
JOIN
	acm_institution acm_inst_surrogate
ON
	acm_inst.surrogate_name_id = acm_inst_surrogate.id

-- get the sum of citings per dblp publication from acm
GO
CREATE VIEW CUBE_DBLP_ACM_CITINGS AS
SELECT
	dblp_acm.dblp_id as dblp_pubId
	,COUNT(*) as citingsACM
FROM
	dblp_acm
INNER JOIN
	acm_cited_by as acm_cited
ON
	dblp_acm.acm_id = acm_cited.publication1_id
GROUP BY
	dblp_acm.dblp_id

-- get the sum of self citings per dblp publication from acm	
GO
CREATE VIEW CUBE_DBLP_ACM_SELF_CITINGS AS
SELECT
	dblp_acm.dblp_id as dblp_pubId
	,COUNT(*) as citingsACMSelf
FROM
	dblp_acm
INNER JOIN
	acm_self_cited as acm_self
ON
	dblp_acm.acm_id = acm_self.publication1_id
GROUP BY
	dblp_acm.dblp_id

-- get the sum of citings per dblp publication from google scholar	
GO
CREATE VIEW CUBE_DBLP_GS AS
SELECT
	dblp_pub.id as dblp_pubId
	,SUM(gs_pub.no_of_citings) as citingsGS
FROM
	dblp_publication as dblp_pub
INNER JOIN
	dblp_gs
ON
	dblp_pub.id = dblp_gs.dblp_id
INNER JOIN
	gs_publication as gs_pub
ON
	dblp_gs.gs_id = gs_pub.id
GROUP BY
	dblp_pub.id
	