use dwhprak06

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