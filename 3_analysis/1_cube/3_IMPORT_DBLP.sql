use dwhprak06

-- author
INSERT INTO cube_Author (id, name)
SELECT
	id
	,fullname
FROM
	dblp_author
	
-- VenueSeries
INSERT INTO cube_VenueSeries (id, description)
SELECT
	id
	,name
FROM
	dblp_venue_series
	
-- Title
INSERT INTO cube_Title (id, title)
SELECT
	id
	,title
FROM
	dblp_publication
	
-- Time
INSERT INTO cube_Time(year, decade )
SELECT DISTINCT
	year
	,(year - (year % 10))
FROM
	dblp_venue
	
-- Publication
INSERT INTO cube_Publication (titleId, venueSeriesId, year)
SELECT
	pub.id as titleId
	,ven.venue_series_id as venueSeriesId
	,ven.year as year	
FROM
	dblp_publication pub
LEFT OUTER JOIN
--INNER JOIN
	dblp_venue_publication venpub
ON
	pub.id = venpub.publication_id
LEFT OUTER JOIN
--INNER JOIN
	dblp_venue ven
ON
	venpub.venue_id = ven.id

-- author_publication
INSERT INTO cube_AuthorPublication (Author_Id, Publication_Id)
SELECT DISTINCT
	author_id
	,cubepub.id as Publication_Id
FROM
	dblp_author_publication authpub
INNER JOIN
	cube_Publication cubepub
ON
	authpub.publication_id = cubepub.titleId
		
