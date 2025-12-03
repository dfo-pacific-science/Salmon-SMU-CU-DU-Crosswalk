# Salmon-SMU-CU-DU-Crosswalk-Table 

Welcome to the Salmon stock management unit (SMU) – conservation unit (CU) – designatable unit (DU) crosswalk repository.

The Salmon SMU-CU-DU crosswalk describes how salmon groups are related to each other. It links between Science and Fisheries and Resource Management Branches, as well as across organizations (Fisheries and Oceans Canada (DFO), Committee on the Status of Endangered Wildlife in Canada (COSEWIC)) to help communicate and assess salmon stocks at distinct levels.

## Official Record

This crosswalk data is part of the official **Pacific Salmon Conservation Units, Sites & Status** dataset published by Fisheries and Oceans Canada on the [Open Canada data portal](https://open.canada.ca/data/en/dataset/1ac00a39-4770-443d-8a6b-9656c06df6a3). The official record includes the SMU/CU/DU Lookup Table along with related datasets, data dictionaries, and reference materials. This GitHub repository provides version-controlled access to the crosswalk data with enhanced programmatic access capabilities.

## Table Terminology

- **Stock Management Unit (SMU)**  
  A stock management unit (SMU) is a group of one or more conservation units (CU) that are managed together with the objective of achieving an outlook category (from well below average to abundant).

- **Conservation Unit (CU)**  
  A Conservation Unit (CU) is a group of wild Pacific salmon sufficiently isolated from other groups that, if extirpated, is very unlikely to recolonize naturally within an acceptable timeframe, such as a human lifetime or a specified number of salmon generations.

- **Designatable Unit (DU)**  
  A Designatable Unit (DU), as defined by the Committee on the Status of Endangered Wildlife in Canada (COSEWIC), refers to a population or group of populations within a species that has been determined to be unique for conservation purposes. A DU represents the individuals that exist within a geographical area(s) and exhibit unique genetic traits or a unique genetic heritage that makes them discrete and evolutionarily significant units of the taxonomic species. Significant means that the unit is important to the evolutionary legacy of the species as a whole and, if it were lost, is unlikely to be replaced through natural dispersion. DUs exist at a scale similar to the conservation unit or CU and may approximate a Stock Management Unit (SMU) in some cases.

## Features

- Linkages between stock units
- Tracking of CU revisions
- Life history types
- Common vocabulary for DFO

## Data dictionary

The data dictionary now lives in Markdown (`DataDictionary.md`) generated from the LinkML YAML schema (`DataDictionary.schema.yaml`). Columns are underscore-delimited and controlled vocabularies are enumerated; the schema is the source of truth for automated checks. The legacy CSV dictionary is no longer used.

## Downloading the Data

### Option 1: Download Raw CSV File (For Non-GitHub Users)

If you're not familiar with GitHub, you can download the CSV file directly:

1. Navigate to the main page of this repository
2. Click on the file `pacific_salmon_smu_cu_du_x_walk.csv`
3. Click the **"Raw"** button (top right of the file view)
4. Right-click on the page and select **"Save As"** (or use Ctrl+S / Cmd+S)
5. Save the file to your desired location

Alternatively, you can use this direct link format (replace `[branch]` with `main` or the specific branch):
```
https://raw.githubusercontent.com/dfo-pacific-science/Salmon-SMU-CU-DU-Crosswalk/[branch]/pacific_salmon_smu_cu_du_x_walk.csv
```

### Option 2: Extract with R Code

Download the crosswalk CSV file (base R only):

```r
download.file(
  url = "https://raw.githubusercontent.com/dfo-pacific-science/Salmon-SMU-CU-DU-Crosswalk/[branch]/pacific_salmon_smu_cu_du_x_walk.csv",
  destfile = "pacific_salmon_smu_cu_du_x_walk.csv",
  mode = "wb"
)

crosswalk <- read.csv(
  "pacific_salmon_smu_cu_du_x_walk.csv",
  stringsAsFactors = FALSE,
  check.names = FALSE
)
```


## Versioning and Citation

This dataset uses **GitHub Releases** for version management. Each new version is published as a GitHub release with a version tag (e.g., `2025.07.31`). **Each release receives a version-specific DOI** that should be used when citing the dataset.

### How to Cite

When using this dataset in your work, please cite the specific version you used:
- **Version-specific DOI**: Each GitHub release includes a DOI that should be used for citation
- **Release Tag**: Reference the specific release tag (e.g., `v2025.07.31`) in your citation
- **GitHub Release URL**: The release page URL provides access to the version-specific data and documentation

To access a specific version:
1. Navigate to the [Releases](https://github.com/dfo-pacific-science/Salmon-SMU-CU-DU-Crosswalk/releases) page
2. Select the version you need
3. Use the DOI and release information provided on that page for citation

### Accessing Previous Versions

Previous versions are available through:
- **GitHub Releases**: Browse all releases on the repository's Releases page
- **Git History**: Use Git commands to access previous versions:
  ```bash
  git show <tag-name>:pacific_salmon_smu_cu_du_x_walk.csv > previous_version.csv
  ```

## CHANGELOG

Here we track what changes between different versions of the dataset. Each version is published as a GitHub release with a version-specific DOI. The version tag (e.g., `[2025.07.31]`) corresponds to the GitHub release tag and should be cited when using these data to be clear which version of the data you used for an analysis.

The dataset is reviewed and updated every three months, or sooner if multiple changes are detected in the NuSEDS (New Salmon Escapement Database System), to ensure that the published data remain current and accurate. If no changes are detected during a scheduled update, the existing release will remain unchanged.



## Feedback
For recommended Conservation Unit revisions, please fill out the [CU Review Request Form (English)](https://open.canada.ca/data/dataset/1ac00a39-4770-443d-8a6b-9656c06df6a3/resource/11c61292-603b-4662-8b27-09579a50f6d8).
Use the [Census Sites Look up table](https://open.canada.ca/data/en/dataset/1ac00a39-4770-443d-8a6b-9656c06df6a3/resource/011c9f73-beb5-47c2-873d-ac6835fc0bcb) to find the relevant Population ID(s) needed to complete the form.


Alternatively, you may contact the Salmon Data Unit directly at: DFO.SECUData-DonneesESUC.MPO@dfo-mpo.gc.ca 

---
# What's in the supplemental material?

**Note**: Previous versions of the crosswalk data are maintained through GitHub releases and Git history. Each version is published as a GitHub release with a version-specific DOI. To access previous versions, you can:
- Browse the [Releases](https://github.com/dfo-pacific-science/Salmon-SMU-CU-DU-Crosswalk/releases) page for all published versions
- Use Git commands such as `git log`, `git show`, or `git checkout` with the appropriate release tag
- Each release includes a version-specific DOI for proper citation

## NuSEDS_query.sql

This SQL query is designed to extract and display information from the Nuseds_V2_0.SMU_CU_DU_CROSSWALK_VW view. It retrieves details about DFO administrative areas, species, stock management units (SMUs), conservation units (CUs), and their respective life history types. The commented-out lines indicate additional columns that can be included if needed, such as Designatable Unit Name, Number, Index, and Acronym. The results are ordered by DFO administrative area and species for better organization and readability.


## scripts

Used for tracking data changes over time and performing quality checks.
