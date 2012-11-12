USE [dwhprak06]

if OBJECT_ID('dbo.gs_denormalized') IS NOT NULL drop table [dbo].[gs_denormalized]

CREATE TABLE [dbo].[gs_denormalized] (
    [id] numeric(20,0) NOT NULL PRIMARY KEY,
    [title] nvarchar(1000),
    [url] nvarchar(1000),
    [no_of_citings] int,
    [additional] nvarchar(1000)
)