# R Script for Change Tracking

This script compares the current version of `pacific_salmon_smu_cu_du_x_walk.csv` with a previous version and reports any differences.

## 📌 How It Works

1. Move the existing `pacific_salmon_smu_cu_du_x_walk_yyyy-mm-dd.csv` from the project root directory to `supplemental_materials/previous_version/`. 
2. Run `NuSEDS_query.sql` (located in the `supplemental_materials` folder) against the NuSEDS Oracle database to generate the updated SMU/CU/DU crosswalk data.
3. Export the new SMU/CU/DU crosswalk as `pacific_salmon_smu_cu_du_x_walk_yyyy-mm-dd.csv` (where yyyy-mm-dd is the current date) and place it in the project root directory.
4. Open and run 01_change_tracking.R in RStudio, and when prompted, enter the filenames for the current (new) and previous crosswalk CSV files.

## 📝 Output

- If there are **differences** between the new and previous versions of `pacific_salmon_smu_cu_du_x_walk.csv`, a detailed changelog will be inserted into `CHANGELOG.md` with the current date as the version header.
- If there are **no differences**, the script will return: No changes and `CHANGELOG.md` will remain unchanged.

