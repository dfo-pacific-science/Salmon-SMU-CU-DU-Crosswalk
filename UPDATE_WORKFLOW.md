# Update Workflow

## Quick Start

```bash
Rscript process_new_version.R [pacific_salmon_smu_cu_du_x_walk_YYYY-MM-DD.csv]
```

If no filename is provided, the script auto-detects the most recent dated CSV file. Run this command from the repository root.

## Process

The script automatically:
1. Formats the new CSV (column names to underscores)
2. Compares with current version and updates CHANGELOG.md
3. Archives old version to `supplemental_materials/previous_version/` with date
4. Replaces current file (removes date from filename)
5. Preserves the raw, unformatted input in `supplemental_materials/previous_version/raw_inputs/`
6. Cleans up temporary files
7. Validates columns against the LinkML schema (`DataDictionary.schema.yaml`), updating the schema and `DataDictionary.md` when new columns are detected.

## After Running

1. **Review CHANGELOG.md** and fill in "Impact for Analysts" section
2. **Commit**:
   ```bash
   git add pacific_salmon_smu_cu_du_x_walk.csv CHANGELOG.md supplemental_materials/previous_version/
   git commit -m "Update crosswalk to version YYYY.MM.DD"
   git tag vYYYY.MM.DD && git push origin main --tags
   ```
3. **Create GitHub Release** with tag (gets version-specific DOI)

> Dependencies: scripts assume `here` and `yaml` are installed.
