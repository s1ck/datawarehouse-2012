use dwhprak06

select 
	gs_id as publication_id
from 
	gs_tmp
EXCEPT 
SELECT 
	pub.id as publication_id			
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
	
	
