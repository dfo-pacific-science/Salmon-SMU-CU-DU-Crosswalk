select 
scd.cu_dfo_area as "DFO Area",
scd.cu_species as "Species Name",
scd.smu_name as "SMU Name",
scd.FULL_SMU_IN as "SMU Full Index",
scd.smu_lh_type as "SMU Life History Type",
scd.CU_NAME as "CU Name",
--scd.COMMON_NAME as "CU Common Name",
scd.FULL_CU_IN as "CU Full Index",
scd.CU_LH_TYPE as  "CU Life History Type",
scd.cu_type as "CU Type",
scd.DU_NAME as "DU Name",
scd.DU_NUMBER as "DU Number",
scd.FULL_DU_IN as "DU Full Index",
scd.DU_ACRO as "DU Acronym"
from Nuseds_V2_0.SMU_CU_DU_CROSSWALK_VW scd order by scd.cu_dfo_area, scd.cu_species; 


-- This SQL query is designed to extract and display information from the Nuseds_V2_0.SMU_CU_DU_CROSSWALK_VW view.
-- It retrieves details about DFO administrative areas, species, stock management units (SMUs), conservation units (CUs), Designatable Units (DUs) and their respective life history types.
-- The results are ordered by DFO  area and species for better organization and readability.
