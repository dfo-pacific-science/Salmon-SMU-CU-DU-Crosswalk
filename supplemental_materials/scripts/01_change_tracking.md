# R Script for Change Tracking

This script compares the current version of `pacific_salmon_smu_cu_du_x_walk.csv` with a previous version and reports any differences.

## 📌 How It Works

1. Run `NuSEDS_query.sql` (located in the `supplemental_materials` folder) against the NuSEDS Oracle database to generate the updated SMU/CU/DU crosswalk data.
2. Export the new SMU/CU/DU crosswalk as `pacific_salmon_smu_cu_du_x_walk.csv` and place it in the project root directory.
3. To compare with a previous version, retrieve the previous version from a GitHub release:
   - **Option A**: Download from the [GitHub Releases](https://github.com/dfo-pacific-science/Salmon-SMU-CU-DU-Crosswalk/releases) page
   - **Option B**: Use Git to retrieve a specific release tag:
     ```bash
     git show <tag-name>:pacific_salmon_smu_cu_du_x_walk.csv > previous_version.csv
     ```
     For example: `git show v2025.07.28:pacific_salmon_smu_cu_du_x_walk.csv > previous_version.csv`
4. Open and run `01_change_tracking.R` in RStudio, and when prompted, enter:
   - Current CSV filename: `pacific_salmon_smu_cu_du_x_walk.csv`
   - Previous CSV filename: `previous_version.csv` (or the path where you saved it)

**Note**: Previous versions are maintained through GitHub releases (each with a version-specific DOI) and Git history. Use the [Releases](https://github.com/dfo-pacific-science/Salmon-SMU-CU-DU-Crosswalk/releases) page or `git tag` to find the appropriate release tag for comparison.

## 📝 Output

- If there are **differences** between the new and previous versions of `pacific_salmon_smu_cu_du_x_walk.csv`, a detailed changelog will be inserted into `CHANGELOG.md` with the current date as the version header.
- If there are **no differences**, the script will return: No changes and `CHANGELOG.md` will remain unchanged.
