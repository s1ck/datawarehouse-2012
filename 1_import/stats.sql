USE [dwhprak06];

GO

SELECT o.name,
  ddps.row_count 
FROM sys.indexes AS i
  INNER JOIN sys.objects AS o ON i.OBJECT_ID = o.OBJECT_ID
  INNER JOIN sys.dm_db_partition_stats AS ddps ON i.OBJECT_ID = ddps.OBJECT_ID
  AND i.index_id = ddps.index_id 
WHERE i.index_id < 2  AND o.is_ms_shipped = 0 ORDER BY o.NAME 

/*
acm_author	6896
acm_author_institution	9283
acm_author_publication	14693
acm_cited_by	50461
acm_fulltext	5317
acm_institution	3975
acm_publication	5516
acm_venue	356
acm_venue_publication	6909
acm_venue_series	6


dblp_author	501821
dblp_author_publication	1960026
dblp_cited_by	0
dblp_publication	818820
dblp_venue	817108
dblp_venue_publication	817108
dblp_venue_series	3901


gs_author	89121
gs_author_publication	314876
gs_origin	14850
gs_publication	115246
gs_venue	115246
gs_venue_publication	115246
gs_venue_series	44985
sysdiagrams	3
*/