use dwhprak06

SELECT 
		--ins_fuzzy.[_key_in]
     -- ,ins_fuzzy.[_key_out]
    --  ,ins_fuzzy.[_score]
   --   ,ins_fuzzy.[id]
	  ins.name as name
    --  ,ins_fuzzy.[name] as name_clean
	  ,ins2.name as group_name
    --  ,ins_fuzzy.[name_clean] as group_name_clean
      ,ins_fuzzy.[_Similarity_name]
  FROM 
	[dwhprak06].[dbo].[acm_institution_fuzzy_grouped] ins_fuzzy
JOIN
	[dbo].[acm_institution] ins
ON
	ins.id = ins_fuzzy._key_in
JOIN
	[dbo].[acm_institution] ins2
ON
	ins2.id = ins_fuzzy._key_out
--WHERE
--	NOT _key_in = _key_out
--	ins_fuzzy.[name] like '%leipzig%'
  ORDER BY
	_key_out,
	_Similarity_name ASC

