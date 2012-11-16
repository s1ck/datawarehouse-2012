use dwhprak06

SELECT COUNT(*) from gs_author_publication where author_id IS NULL
SELECT COUNT(*) from gs_author where name IS NULL
SELECT COUNT(*) from gs_tmp where author IS NULL
SELECT COUNT(*) FROM gs_publication where origin_id IS NULL

SELECT 
	pub.id as publication_id,
	pub.title as title,
	pub.url,
	pub.no_of_citings,	
	ven.year,
	vs.name as venue_series,
	auth.name as author_name,
	auth_pub.pos as position,
	orig.text as source
FROM
	[dbo].[gs_publication] pub,
	[dbo].[gs_venue] ven,
	[dbo].[gs_venue_series] vs,
	[dbo].[gs_author] auth,
	[dbo].[gs_venue_publication] ven_pub,
	[dbo].[gs_author_publication] auth_pub,
	[dbo].[gs_origin] orig
WHERE
	pub.id = ven_pub.publication_id
	AND
	ven.id = ven_pub.venue_id
	AND
	pub.id = auth_pub.publication_id
	AND
	auth.id = auth_pub.author_id
	AND
	ven.venue_series_id = vs.id
	AND
	pub.origin_id = orig.id
ORDER BY
	pub.id, auth_pub.pos
	
--SELECT COUNT(*) FROM gs_publication 
--SELECT COUNT(*) FROM gs_venue

SELECT * FROM gs_denormalized WHERE id = 754843838241772
	