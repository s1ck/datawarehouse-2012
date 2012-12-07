use dwhprak06 

-- get all DBLP publications from venue series ACM Transactions on Database Systems (Journal)

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
		[dbo].[dblp_acm]
)

-- get all DBLP publications from venue series The VLDB Journal (Journal)

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
	venser.id = 65783
AND
	pub.id 
NOT IN (
	SELECT
		dblp_id
	FROM
		[dbo].[dblp_acm]
)

-- get all DBLP publications from venue series ACM SIGMOD Record (Journal)

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
	venser.id = 65591
AND
	pub.id 
NOT IN (
	SELECT
		dblp_id
	FROM
		[dbo].[dblp_acm]
)

-- get all DBLP publications from venue series VLDB (Series)

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
	venser.id = 21
AND
	pub.id 
NOT IN (
	SELECT
		dblp_id
	FROM
		[dbo].[dblp_acm]
)

-- get all DBLP publications from venue series SIGMOD (Series)

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
	venser.id = 33
AND
	pub.id 
NOT IN (
	SELECT
		dblp_id
	FROM
		[dbo].[dblp_acm]
)