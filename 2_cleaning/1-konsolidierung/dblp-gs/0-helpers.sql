use dwhprak06 

-- get all DBLP publications from venue series associated to ACM Trans. Database Syst.

SELECT
	pub.id
	,pub.title
FROM
	dblp_publication pub
JOIN
	dblp_venue_publication pubven
ON
	pub.id = pubven.publication_id
JOIN
	dblp_venue ven
ON
	ven.id = pubven.publication_id
JOIN
	dblp_venue_series venser
ON
	ven.venue_series_id = venser.id
WHERE
	venser.id = 65677
AND
	pub.id 
NOT IN (
	SELECT
		dblp_id
	FROM
		[dbo].[dblp_gs]
)

-- get all DBLP publications from venue series associated to VLDB

SELECT
	pub.id
	,pub.title
	,venser.name
FROM
	dblp_publication pub
JOIN
	dblp_venue_publication pubven
ON
	pub.id = pubven.publication_id
JOIN
	dblp_venue ven
ON
	ven.id = pubven.publication_id
JOIN
	dblp_venue_series venser
ON
	ven.venue_series_id = venser.id
WHERE
	venser.id
IN (
	SELECT 
		[id]
	FROM
		[dwhprak06].[dbo].[dblp_venue_series]
	WHERE 
		name LIKE '%vldb%'
	OR
		name LIKE '%very large database%'
)
AND
	pub.id 
NOT IN (
	SELECT
		dblp_id
	FROM
		[dbo].[dblp_gs]
)

-- get all DBLP publications from venue series associated to SIGMOD

SELECT
	pub.id
	,pub.title
FROM
	dblp_publication pub
JOIN
	dblp_venue_publication pubven
ON
	pub.id = pubven.publication_id
JOIN
	dblp_venue ven
ON
	ven.id = pubven.publication_id
JOIN
	dblp_venue_series venser
ON
	ven.venue_series_id = venser.id
WHERE
	venser.id
IN (
	SELECT 
		[id]
	FROM
		[dwhprak06].[dbo].[dblp_venue_series]
	WHERE 
		name LIKE '%sigmod%'
	OR
		name LIKE '%management of data%'
)
AND
	pub.id 
NOT IN (
	SELECT
		dblp_id
	FROM
		[dbo].[dblp_gs]
)