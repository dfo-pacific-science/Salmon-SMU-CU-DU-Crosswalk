# CHANGELOG
All notable changes to this project will be documented in this file.

## [2025.11.28]

### Summary

- **DFO Area Standardization**: Updated all affected CUs from `YUKON TRANSBOUNDARY` to `YUKON AND TRANSBOUNDARY` across Chinook, Chum, Coho, Pink, and Sockeye units to match current DFO terminology.
- **CU Common Name Additions**: Added common names for selected Chinook, Coho, and Sockeye CUs (e.g., Fraser and Interior and Yukon/Transboundary groups) to improve interpretability in reports and tools.
- **DU Information Additions**: Populated DU name, number, index, and acronym for several previously incomplete Yukon/Transboundary and Fraser/Interior CUs, improving linkage to COSEWIC DU information.
- **Total CUs Modified**: 83 CUs with one or more changes.
- **No CU Additions or Deletions**: All existing CUs are retained; changes are refinements to attributes only.

**Impact for Analysts**:
- Queries, dashboards, or code that filter or group on `DFO_Area` must be updated to use `YUKON AND TRANSBOUNDARY` instead of `YUKON TRANSBOUNDARY`.
- Joins or QA checks that relied on missing DU fields or CU common names may now see new non-blank values; review any logic that treated blanks as “no DU information/common name available.”
- No CU identifiers (`CU_Full_Index`) changed, and no CUs were added or removed, so time series and CU-level analyses remain structurally comparable across versions once area labels are updated.

### Detailed Changes

##### CU FULL INDEX: CK-23
- **CU Common Name Added**: `'East Vancouver Island-Nanaimo_SP_1.x'`

##### CU FULL INDEX: CK-24
- **CU Common Name Added**: `'chinook [CK] East Vancouver Island-Nanaimo and chemainus Summer Timing'`

##### CU FULL INDEX: CK-26
- **CU Common Name Added**: `'East Vancouver Island-Puntledge-summer timing'`

##### CU FULL INDEX: CK-30
- **CU Common Name Added**: `'chinook [CK] Port San Juan'`

##### CU FULL INDEX: CK-47
- **CU Common Name Added**: `'Gitnadoix'`

##### CU FULL INDEX: CK-52
- **CU Common Name Added**: `'Middle Skeena'`

##### CU FULL INDEX: CK-59
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`
- **DU Information Added**: Name=`'Unuk River, Stream, Summer'`, Number=`'51'`, Index=`'CK-DU-51'`, Acronym=`'UNUK'`

##### CU FULL INDEX: CK-60
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CK-61
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CK-62
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`
- **DU Information Added**: Name=`'Whiting River, Stream, Summer'`, Number=`'54'`, Index=`'CK-DU-54'`, Acronym=`'WHITING'`

##### CU FULL INDEX: CK-63
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CK-64
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CK-65
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CK-66
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`
- **DU Information Added**: Name=`'Chilkat, Stream, Summer'`, Number=`'58'`, Index=`'CK-DU-58'`, Acronym=`'LYNN'`

##### CU FULL INDEX: CK-67
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CK-68
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CK-69
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CK-70
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CK-71
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CK-72
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CK-73
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CK-74
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CK-75
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CK-76
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CK-77
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CK-78
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CK-79
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CK-9000
- **CU Common Name Added**: `'Hatchery Exclusion-Lower Fraser River'`

##### CU FULL INDEX: CK-9001
- **CU Common Name Added**: `'Hatchery Exclusion-Barkley Sound'`

##### CU FULL INDEX: CM-33
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CM-35
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CM-36
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CM-37
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CM-38
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CM-39
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CM-40
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CM-42
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CM-43
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CM-44
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CM-45
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CM-46
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CM-48
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CO-02
- **CU Common Name Added**: `'coho [CO] Lower Fraser-A'`

##### CU FULL INDEX: CO-03
- **CU Common Name Added**: `'coho [CO] Lower Fraser-B'`

##### CU FULL INDEX: CO-06
- **CU Common Name Added**: `'coho [CO] Middle Fraser'`

##### CU FULL INDEX: CO-28
- **CU Common Name Added**: `'coho [CO] Brim-Wahoo'`

##### CU FULL INDEX: CO-38
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`
- **DU Information Added**: Name=`'Unuk'`, Number=`'31'`, Index=`'CO-DU-31'`, Acronym=`'Unuk'`

##### CU FULL INDEX: CO-39
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CO-40
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`
- **DU Information Added**: Name=`'Whiting River'`, Number=`'33'`, Index=`'CO-DU-33'`, Acronym=`'Whiting'`

##### CU FULL INDEX: CO-41
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CO-42
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CO-43
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CO-44
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`
- **DU Information Added**: Name=`'Chilkat'`, Number=`'35'`, Index=`'CO-DU-35'`, Acronym=`'LYNN'`

##### CU FULL INDEX: CO-45
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: CO-46
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: PKE-13
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: PKO-19
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: SEL-01-01
- **DU Information Added**: Name=`'Osoyoos'`, Number=`'50'`, Index=`'SEL-DU-50'`

##### CU FULL INDEX: SEL-06-08
- **CU Common Name Added**: `'sockeye-lake type [SEL] Mckinley-S'`

##### CU FULL INDEX: SEL-06-09
- **CU Common Name Added**: `'sockeye-lake type [SEL] Nadina-Es'`

##### CU FULL INDEX: SEL-06-15
- **CU Common Name Added**: `'sockeye-lake type [SEL] Takla/Trembleur-S'`

##### CU FULL INDEX: SEL-06-19
- **CU Common Name Added**: `'Seton-Summer timing'`

##### CU FULL INDEX: SEL-09-01
- **CU Common Name Added**: `'sockeye-lake type [SEL] Kamloops-L'`

##### CU FULL INDEX: SEL-09-04
- **CU Common Name Added**: `'Adams-Early Summer timing'`

##### CU FULL INDEX: SEL-09-05
- **CU Common Name Added**: `'Momich-Early Summer timing'`

##### CU FULL INDEX: SEL-10-02
- **CU Common Name Added**: `'(X)North Barriere-Early Summer timing'`

##### CU FULL INDEX: SEL-21-08
- **CU Common Name Added**: `'sockeye-lake type [SEL] Nilkitkwa'`

##### CU FULL INDEX: SEL-21-10
- **CU Common Name Added**: `'sockeye-lake type [SEL] Swan'`

##### CU FULL INDEX: SEL-25-01
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`
- **DU Information Added**: Name=`'Border'`, Number=`'184'`, Index=`'SEL-DU-184'`

##### CU FULL INDEX: SEL-26-01
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: SEL-26-02
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: SEL-26-03
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: SEL-27-01
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`
- **DU Information Added**: Name=`'Whiting'`, Number=`'188'`, Index=`'SEL-DU-188'`

##### CU FULL INDEX: SEL-28-01
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: SEL-28-02
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: SEL-28-03
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: SEL-28-05
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: SEL-30-01
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: SEL-30-02
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: SEL-30-03
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`

##### CU FULL INDEX: SER-08
- **DU Information Added**: Name=`'East Vancouver Island-Georgia Strait; East Vancouver Island-Southern Fjords; South Coast - Georgia Strait; South Coast - Southern Fjords'`, Number=`'26; 28; 25; 27'`, Index=`'SER-DU-26; SER-DU-28; SER-DU-25; SER-DU-27'`

##### CU FULL INDEX: SER-23
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`
- **DU Information Added**: Name=`'Chilkat River'`, Number=`'48'`, Index=`'SER-DU-48'`

##### CU FULL INDEX: SER-24
- **DFO Area**: `'YUKON TRANSBOUNDARY'` → `'YUKON AND TRANSBOUNDARY'`


## [2025.07.31]
##### File Naming Convention Change
- **Filename Update**: The main crosswalk file has been renamed from `pacific_salmon_smu_cu_du_x_walk_YYYY-MM-DD.csv` to `pacific_salmon_smu_cu_du_x_walk.csv` (no date suffix)
- This change enhances programmatic access by providing a stable filename that can be referenced consistently
- **Version Management**: Version information is now tracked through GitHub releases, with each release receiving a version-specific DOI for citation
- See README for updated download and extraction instructions

##### Column Name Format Change
- **Column Name Format**: Column names have been standardized to use underscores instead of spaces (e.g., `DFO Area` → `DFO_Area`, `Species Name` → `Species_Name`)
- This change improves compatibility with programmatic data extraction and analysis tools
- When reading the CSV with R's `read.csv()` using `check.names = TRUE`, spaces are converted to dots; the formatting script (`supplemental_materials/scripts/formatting.R`) handles this conversion to underscores
- See README for R code examples demonstrating proper extraction methods

##### CU FULL INDEX: CK-01
- Added New column:  **CU Common Name**
- updated **DataDictionary**

## [2025.07.28]
##### CU FULL INDEX: SEL-13-09
- **CU Name**: `\'HENDERSON\'` → `\'HUCUKTLIS\'` 
- The CU(s) deleted: SEL-09-xx

#### Column Name Updates
- **Species** → **Species Name**
- **Full SMU Index** → **SMU Full Index**
- **Full CU Index** → **CU Full Index**
- **Full DU Index** → **DU Full Index**

## [2025.06.13]
- This was the first version of the data package.

