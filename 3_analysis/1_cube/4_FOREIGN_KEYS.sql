use dwhprak06

-- updates
--UPDATE cube_Publication SET year = -1 WHERE year IS NULL;
--UPDATE cube_Publication SET venueSeriesId = -1 WHERE venueSeriesId IS NULL;
--UPDATE cube_Publication SET titleId = -1 WHERE titleId IS NULL;
	

-- Foreign Keys

-- AuthorPublication -> Author
ALTER TABLE cube_AuthorPublication
ADD CONSTRAINT fk_author
FOREIGN KEY (Author_Id)
REFERENCES cube_Author(id);
	
-- AuthorPublication -> Publication
ALTER TABLE cube_AuthorPublication
ADD CONSTRAINT fk_publication
FOREIGN KEY (Publication_Id)
REFERENCES cube_Publication(id);

-- Publication -> Time
ALTER TABLE cube_Publication
ADD CONSTRAINT fk_time
FOREIGN KEY (year)
REFERENCES cube_Time(year);

-- Publication -> VenueSeries
ALTER TABLE cube_Publication
ADD CONSTRAINT fk_venueseries
FOREIGN KEY (venueSeriesId)
REFERENCES cube_VenueSeries(id);

-- Publication -> Title
ALTER TABLE cube_Publication
ADD CONSTRAINT fk_title
FOREIGN KEY (titleId)
REFERENCES cube_Title(id);