use [dwhprak06] 

/*
The DBLP data doesn't differ between venue and venue_series. As we want to make
all schemas similiar, we created a venue relation, attached the publications year
to it and linked it n:m with the publication relation.

The venue relation got a 1:n relation to venue_series to join the original data.

In short:

venue_series --- n:m --- publication

became

venue_series --- 1:n --- venue --- n:m --- publication
*/
INSERT INTO [dbo].[dblp_venue] (year, venue_series_id, publication_id)
	SELECT 
		pub.year as year,
		venue_series.id as venue_series_id,
		pub.id as publication_id
	FROM
		[dbo].[dblp_publication] pub,
		[dbo].[dblp_venue_series] venue_series,		
		[dbo].[dblp_venue_series_publication] venue_series_publication
	WHERE
		venue_series.id =  venue_series_publication.venue_series_id
	AND	
		venue_series_publication.publication_id = pub.id

INSERT INTO [dbo].[dblp_venue_publication] (venue_id, publication_id)
	SELECT 
		venue.id as venue_id,
		venue.publication_id as publication_id
	FROM
		[dbo].[dblp_venue] as venue

		

