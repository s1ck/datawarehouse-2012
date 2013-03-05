use dwhprak06

-- join the cube

select top 100
	* 
from
	cube_Publication pub
inner join
	cube_AuthorPublication authpub
on
	pub.id = authpub.Publication_Id
inner join
	cube_Author auth
on
	authpub.Author_Id = auth.id
inner join
	cube_Title title
on
	pub.titleId = title.id
inner join
	cube_Time time
on
	pub.year = time.year
inner join
	cube_VenueSeries venser
on
	pub.venueSeriesId = venser.id
--order by titleId
