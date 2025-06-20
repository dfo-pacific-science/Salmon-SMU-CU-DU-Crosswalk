# Salmon-SMU-CU-DU-Crosswalk-Table 

Welcome to Salmon stock management unit (SMU) - conservation unit (CU) - designatable unit(DU) crosswalk  repository. 

The Salmon SMU-CU-DU crosswalk offers information on how salmon groups are related to each other. The crosswalk links between Science and Fisheries and Resource Management Branches, as well as across organizations (Fisheries and Oceans Canada (DFO), Committee on the Status of Endangered Wildlife in Canada (COSEWIC)) to help communicate and assess salmon stocks at distinct levels.

## Table Terminology
- **Stock management unit (SMU)**
A stock management unit (SMU) is a group of one or more conservation units (CU) that are managed together with the objective of achieving an outlook category (from well below average to abundant).

- **Conservation Unit (CU)**
A Conservation Unit (CU) is a group of wild Pacific salmon sufficiently isolated from other groups that, if extirpated, is very unlikely to recolonize naturally within an acceptable timeframe, such as a human lifetime or a specified number of salmon generations

- **Designatable Unit (DU)**
A Designatable Unit (DU), as defined by the Committee on the Status of Endangered Wildlife in Canada (COSEWIC), refers to a population or group of populations within a species that has been determined to be unique for conservation purposes. A DU represents the individuals that exist within a geographical area(s) and exhibit unique genetic traits or a unique genetic heritage that makes them discrete and evolutionarily significant units of the taxonomic species. Significant means that the unit is important to the evolutionary legacy of the species as a whole and if it were lost is unlikely to be replaced through natural dispersion. DUs exist at a scale similar to the conservation unit or CU and may approximate a Stock Management Unit (SMU) in some cases


## Features
 - Linkages between stock units
 - Track CU revisions
 - Life history types
 - Common vacabulary for DFO 

## Data dictionary

The data dictionary (DataDictionary.csv/DataDictionary.xlsx) provides clear and concise definitions for each column in the CrosswalkData table. This ensures consistent understanding and interpretation of the data across users.

## CHANGELOG

Here we track what changes between different versions of the dataset. Different versions of the data set will be tagged on github with a release tag showing the version (eg. [2025.05.27]) that should be cited when using these data to be clear which version of the data you used for an analysis.

The dataset is reviewed and updated every three months, or sooner if multiple changes are detected in the NuSEDS (New Salmon Escapement Database System), to ensure that the published data remain current and accurate. If no changes are detected during a scheduled update, the existing release tag will remain unchanged.



## Feedback
For recommended Conservation Unit revisions, please fill out the [CU Review Request Form (English)](https://open.canada.ca/data/dataset/1ac00a39-4770-443d-8a6b-9656c06df6a3/resource/11c61292-603b-4662-8b27-09579a50f6d8).
Use the [Census Sites Look up table](https://open.canada.ca/data/en/dataset/1ac00a39-4770-443d-8a6b-9656c06df6a3/resource/011c9f73-beb5-47c2-873d-ac6835fc0bcb) to find the relevant Population ID(s) needed to complete the form.


Alternatively, you may contact the Salmon Data Unit directly at: DFO.SECUData-DonneesESUC.MPO@dfo-mpo.gc.ca 

---
# What's in the supplemental material?


## previous_version
This folder stores previous versions of the SMU/CU/DU crosswalk data, which are used to track changes between the current and earlier version.

## NuSEDS_query.sql

This SQL query is designed to extract and display information from the Nuseds_V2_0.SMU_CU_DU_CROSSWALK_VW view. It retrieves details about DFO administrative areas, species, stock management units (SMUs), conservation units (CUs), and their respective life history types. The commented-out lines indicate additional columns that can be included if needed, such as Designatable Unit Name, Number, Index, and Acronym. The results are ordered by DFO administrative area and species for better organization and readability.


## scripts

Used for tracking data changes over time and performing quality checks.