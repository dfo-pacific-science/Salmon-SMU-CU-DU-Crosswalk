#!/usr/bin/env Rscript

# Automation script to process new crosswalk version
# Usage: Rscript process_new_version.R [new_file.csv]
#
# If new_file.csv is not provided, script will auto-detect the most recent
# dated CSV file matching the pattern pacific_salmon_smu_cu_du_x_walk_YYYY-MM-DD.csv

library(here)
library(yaml)

# Helpers ---------------------------------------------------------------
normalize_names <- function(nms) {
  nms <- sub("^\\ufeff", "", nms)        # strip BOM if present
  nms <- sub("^X\\.+", "", nms)          # remove R's BOM-prefix artefact
  nms <- gsub("\\.", "_", nms)
  nms <- gsub(" ", "_", nms)
  nms
}

derive_old_date <- function(current_file, previous_version_dir, changelog_path) {
  # Prefer CHANGELOG date, then dated files in previous_version, then file mtime, then today.
  if (file.exists(changelog_path)) {
    changelog_lines <- readLines(changelog_path)
    for (line in changelog_lines) {
      date_match <- regmatches(line, regexpr("^## \\[\\d{4}\\.\\d{2}\\.\\d{2}\\]", line))
      if (length(date_match) > 0) {
        date_str <- gsub("^## \\[|\\]$", "", date_match)
        return(gsub("\\.", "-", date_str))
      }
    }
  }
  
  dated_prev <- list.files(here(previous_version_dir), pattern = "\\d{4}-\\d{2}-\\d{2}", full.names = FALSE)
  if (length(dated_prev) > 0) {
    dated_prev <- sort(dated_prev, decreasing = TRUE)
    prev_date_match <- regmatches(dated_prev[1], regexpr("\\d{4}-\\d{2}-\\d{2}", dated_prev[1]))
    if (length(prev_date_match) > 0) return(prev_date_match)
  }
  
  if (file.exists(here(current_file))) {
    return(format(file.info(here(current_file))$mtime, "%Y-%m-%d"))
  }
  
  format(Sys.Date(), "%Y-%m-%d")
}

generate_data_dictionary_md_from_schema <- function(schema, output_path = here("DataDictionary.md")) {
  cls <- schema$classes$CrosswalkRecord
  slot_defs <- schema$slots
  enums <- schema$enums
  
  lines <- c(
    "# Data Dictionary",
    "",
    "_This file is auto-generated from `DataDictionary.schema.yaml`. Do not edit by hand._",
    "",
    "Columns are underscore-delimited and align with `pacific_salmon_smu_cu_du_x_walk.csv`. Controlled vocabularies come from LinkML enums; all other fields are free text strings unless stated.",
    ""
  )
  
  for (slot in unlist(cls$slots)) {
    s_def <- slot_defs[[slot]]
    desc <- if (!is.null(s_def$description)) s_def$description else ""
    range <- if (!is.null(s_def$range)) s_def$range else ""
    
    lines <- c(lines, sprintf("## %s", slot), "")
    if (nzchar(desc)) {
      lines <- c(lines, desc, "")
    }
    
    if (nzchar(range) && !is.null(enums[[range]]) && !is.null(enums[[range]]$permissible_values)) {
      vals <- names(enums[[range]]$permissible_values)
      if (length(vals) > 0) {
        lines <- c(lines, "**Acceptable Values**", "")
        for (v in vals) {
          lines <- c(lines, sprintf("- `%s`", v))
        }
        lines <- c(lines, "")
      }
    }
  }
  
  writeLines(lines, output_path)
  cat(sprintf("  ✓ Wrote markdown data dictionary to %s\n", output_path))
}

sync_schema_and_docs <- function(col_names,
                                 schema_path = here("DataDictionary.schema.yaml"),
                                 output_path = here("DataDictionary.md")) {
  if (!file.exists(schema_path)) {
    warning(sprintf("Schema not found at %s; skipping schema sync", schema_path))
    return(invisible(NULL))
  }
  
  schema <- yaml::read_yaml(schema_path)
  if (is.null(schema$classes$CrosswalkRecord) || is.null(schema$slots)) {
    warning("Schema missing CrosswalkRecord class or slots; skipping schema sync")
    return(invisible(NULL))
  }
  
  cls <- schema$classes$CrosswalkRecord
  schema_slots <- normalize_names(unlist(cls$slots))
  col_names_clean <- normalize_names(col_names)
  
  missing_in_schema <- setdiff(col_names_clean, schema_slots)
  extra_in_schema <- setdiff(schema_slots, col_names_clean)
  
  if (length(missing_in_schema) == 0 && length(extra_in_schema) == 0) {
    cat("  ✓ Data columns align with schema\n")
  } else {
    if (length(missing_in_schema) > 0) {
      cat(sprintf("  ⚠ Columns not defined in schema (will be added): %s\n",
                  paste(missing_in_schema, collapse = ", ")))
      # Add new slots with placeholder descriptions
      for (nm in missing_in_schema) {
        if (is.null(schema$slots[[nm]])) {
          schema$slots[[nm]] <- list(
            description = "Column present in data; description to be completed.",
            range = "string"
          )
        }
      }
      cls$slots <- as.list(c(unlist(cls$slots), missing_in_schema))
      schema$classes$CrosswalkRecord <- cls
      yaml::write_yaml(schema, schema_path)
      cat(sprintf("  ✓ Updated schema at %s\n", schema_path))
    }
    if (length(extra_in_schema) > 0) {
      warning(sprintf("Schema defines slots not present in data (no automatic removal): %s",
                      paste(extra_in_schema, collapse = ", ")))
    }
  }
  
  # Regenerate Markdown data dictionary from the (possibly updated) schema
  generate_data_dictionary_md_from_schema(schema, output_path)
}

# Parse command line arguments
args <- commandArgs(trailingOnly = TRUE)
new_file_arg <- args

# Constants
current_file <- "pacific_salmon_smu_cu_du_x_walk.csv"
file_pattern <- "^pacific_salmon_smu_cu_du_x_walk_\\d{4}-\\d{2}-\\d{2}\\.csv$"
previous_version_dir <- file.path("supplemental_materials", "previous_version")

cat("=== Processing New Crosswalk Version ===\n\n")

# Step 1: Find or validate the new file
if (length(new_file_arg) > 0) {
  new_file <- new_file_arg[1]
  if (!file.exists(new_file)) {
    stop(sprintf("Error: New file not found: %s", new_file))
  }
  cat(sprintf("Using specified file: %s\n", new_file))
} else {
  # Auto-detect the most recent dated file
  all_files <- list.files(here(), pattern = file_pattern, full.names = FALSE)
  if (length(all_files) == 0) {
    stop("Error: No dated CSV files found matching pattern: pacific_salmon_smu_cu_du_x_walk_YYYY-MM-DD.csv\n",
         "Please specify the filename as an argument: Rscript process_new_version.R <filename>")
  }
  # Sort by filename (which includes date) to get most recent
  all_files <- sort(all_files, decreasing = TRUE)
  new_file <- all_files[1]
  cat(sprintf("Auto-detected most recent file: %s\n", new_file))
}

# Extract date from new filename
new_date_match <- regmatches(new_file, regexpr("\\d{4}-\\d{2}-\\d{2}", new_file))
if (length(new_date_match) == 0) {
  stop("Error: Could not extract date from filename. File must match pattern: pacific_salmon_smu_cu_du_x_walk_YYYY-MM-DD.csv")
}
new_date <- new_date_match

# Get date for old version from most recent CHANGELOG entry
CHANGELOG_path <- here("CHANGELOG.md")
old_date <- NULL
if (file.exists(CHANGELOG_path)) {
  changelog_lines <- readLines(CHANGELOG_path)
  # Look for most recent version entry (format: ## [YYYY.MM.DD])
  for (line in changelog_lines) {
    date_match <- regmatches(line, regexpr("^## \\[\\d{4}\\.\\d{2}\\.\\d{2}\\]", line))
    if (length(date_match) > 0) {
      # Extract date and convert YYYY.MM.DD to YYYY-MM-DD
      date_str <- gsub("^## \\[|\\]$", "", date_match)
      old_date <- gsub("\\.", "-", date_str)
      break
    }
  }
}

# If no date found in CHANGELOG, use file modification date or current date
old_date <- derive_old_date(current_file, previous_version_dir, CHANGELOG_path)
cat(sprintf("Using %s as archive date for current file\n", old_date))

# Step 2: Format the new file (convert column names to underscores)
cat("\nStep 1: Formatting new CSV file...\n")
cat(sprintf("  Reading %s...\n", new_file))
smu.crosswalk.src <- read.csv(here(new_file), stringsAsFactors = FALSE, check.names = FALSE)

cat("  Converting column names (dots and spaces to underscores)...\n")
names(smu.crosswalk.src) <- normalize_names(names(smu.crosswalk.src))

# Save formatted version temporarily
formatted_new_file <- sprintf("pacific_salmon_smu_cu_du_x_walk_%s_formatted.csv", new_date)
write.csv(smu.crosswalk.src, here(formatted_new_file), row.names = FALSE, na = "")
cat(sprintf("  ✓ Formatted file saved temporarily\n"))

cat("\nStep 1b: Synchronizing LinkML schema and data dictionary...\n")
sync_schema_and_docs(names(smu.crosswalk.src))

# Step 3: Compare with current version and update CHANGELOG
cat("\nStep 2: Comparing versions and updating CHANGELOG...\n")
cat(sprintf("  Comparing new version (%s) with current version (%s)...\n", new_file, current_file))

# Change tracking function
compare_and_update_changelog <- function(new_file_path, old_file_path) {
  CHANGELOG_path <- here("CHANGELOG.md")
  
  if (!file.exists(new_file_path)) {
    stop(sprintf("New file not found: %s", new_file_path))
  }
  if (!file.exists(old_file_path)) {
    stop(sprintf("Old file not found: %s", old_file_path))
  }
  
  # Read data
  new_data <- read.csv(new_file_path, stringsAsFactors = FALSE, check.names = FALSE)
  old_data <- read.csv(old_file_path, stringsAsFactors = FALSE, check.names = FALSE)
  
  # Normalize column names to underscores (handle both space and dot formats)
  names(new_data) <- normalize_names(names(new_data))
  names(old_data) <- normalize_names(names(old_data))
  
  # Define key column
  key_col <- "CU_Full_Index"
  
  if (!(key_col %in% colnames(new_data)) || !(key_col %in% colnames(old_data))) {
    stop(sprintf("Column '%s' not found in one or both datasets.", key_col))
  }
  
  # Rename key column
  names(new_data)[names(new_data) == key_col] <- "Key"
  names(old_data)[names(old_data) == key_col] <- "Key"
  
  # Find differences
  keys_new <- new_data$Key
  keys_old <- old_data$Key
  only_in_new <- setdiff(keys_new, keys_old)
  only_in_old <- setdiff(keys_old, keys_new)
  common_keys <- intersect(keys_new, keys_old)
  
  new_matched <- new_data[new_data$Key %in% common_keys, ]
  old_matched <- old_data[old_data$Key %in% common_keys, ]
  new_matched <- new_matched[order(new_matched$Key), ]
  old_matched <- old_matched[order(old_matched$Key), ]
  
  # Compare columns
  common_cols <- intersect(setdiff(names(new_matched), "Key"), setdiff(names(old_matched), "Key"))
  
  if (length(common_cols) == 0) {
    differing_indices <- integer(0)
  } else {
    comparison_matrix <- mapply(function(col) {
      new_col <- new_matched[[col]]
      old_col <- old_matched[[col]]
      (new_col == old_col) | (is.na(new_col) & is.na(old_col))
    }, common_cols)
    
    if (is.vector(comparison_matrix)) {
      row_diff <- !comparison_matrix
    } else {
      row_diff <- !apply(comparison_matrix, 1, all)
    }
    differing_indices <- which(row_diff)
  }
  
  # Format date for CHANGELOG (YYYY.MM.DD format)
  formatted_date <- gsub("-", ".", new_date)
  
  # Track change types
  change_types <- list(dfo_area = 0, cu_common_name = 0, du_info = 0, other = 0)
  dfo_area_cus <- character()
  cu_common_name_cus <- character()
  du_info_cus <- character()
  
  # Function to report differences
  report_differences <- function(key, new_row, old_row) {
    text <- sprintf("##### CU FULL INDEX: %s\n", key)
    du_fields <- list()
    
    for (col in common_cols) {
      new_val <- new_row[[col]]
      old_val <- old_row[[col]]
      col_print <- gsub("_", " ", col)
      
      if (!((is.na(new_val) && is.na(old_val)) || identical(new_val, old_val))) {
        if (col == "DFO_Area") {
          change_types$dfo_area <<- change_types$dfo_area + 1
          dfo_area_cus <<- c(dfo_area_cus, key)
        } else if (col == "CU_Common_Name" && (is.na(old_val) || old_val == "")) {
          change_types$cu_common_name <<- change_types$cu_common_name + 1
          cu_common_name_cus <<- c(cu_common_name_cus, key)
        } else if (grepl("^DU_", col)) {
          du_fields[[col]] <- list(old = old_val, new = new_val)
        } else {
          change_types$other <<- change_types$other + 1
        }
        
        if (col == "CU_Common_Name" && (is.na(old_val) || old_val == "")) {
          text <- paste0(text, sprintf("- **CU Common Name Added**: `'%s'`\n", new_val))
        } else if (!grepl("^DU_", col) || col == "DU_Acronym") {
          if (!grepl("^DU_", col)) {
            old_display <- ifelse(is.na(old_val) || old_val == "", "''", old_val)
            new_display <- ifelse(is.na(new_val) || new_val == "", "''", new_val)
            text <- paste0(text, sprintf("- **%s**: `'%s'` → `'%s'`\n", col_print, old_display, new_display))
          }
        }
      }
    }
    
    # Consolidate DU information
    if (length(du_fields) > 0) {
      du_parts <- character()
      du_field_names <- c("DU_Name" = "Name", "DU_Number" = "Number", "DU_Full_Index" = "Index", "DU_Acronym" = "Acronym")
      for (field in names(du_field_names)) {
        if (!is.null(du_fields[[field]]) && !is.na(du_fields[[field]]$new) && du_fields[[field]]$new != "") {
          du_parts <- c(du_parts, sprintf("%s=`'%s'`", du_field_names[field], du_fields[[field]]$new))
        }
      }
      
      if (length(du_parts) > 0) {
        change_types$du_info <<- change_types$du_info + 1
        du_info_cus <<- c(du_info_cus, key)
        text <- paste0(text, sprintf("- **DU Information Added**: %s\n", paste(du_parts, collapse = ", ")))
      }
    }
    
    text
  }
  
  # Generate summary
  summary_text <- "### Summary\n"
  summary_items <- character()
  
  if (change_types$dfo_area > 0) {
    # Check if it's a bulk standardization
    if (length(unique(dfo_area_cus)) == change_types$dfo_area) {
      summary_items <- c(summary_items, 
        sprintf("- **DFO Area Standardization**: %d CUs updated (see detailed changes below)", change_types$dfo_area))
    } else {
      summary_items <- c(summary_items, 
        sprintf("- **DFO Area Changes**: %d CUs with DFO Area updates", change_types$dfo_area))
    }
  }
  
  if (change_types$cu_common_name > 0) {
    summary_items <- c(summary_items, 
      sprintf("- **CU Common Name Additions**: %d CUs received common names (previously empty)", change_types$cu_common_name))
  }
  
  if (change_types$du_info > 0) {
    summary_items <- c(summary_items, 
      sprintf("- **DU Information Additions**: %d CUs received new DU information (names, numbers, indices, acronyms)", change_types$du_info))
  }
  
  if (change_types$other > 0) {
    summary_items <- c(summary_items, 
      sprintf("- **Other Changes**: %d CUs with other field updates", change_types$other))
  }
  
  total_changed <- length(differing_indices)
  if (length(only_in_new) > 0) {
    summary_items <- c(summary_items, 
      sprintf("- **New CUs Added**: %d CUs", length(only_in_new)))
  }
  if (length(only_in_old) > 0) {
    summary_items <- c(summary_items, 
      sprintf("- **CUs Deleted**: %d CUs", length(only_in_old)))
  }
  
  if (length(summary_items) == 0 && total_changed == 0 && length(only_in_new) == 0 && length(only_in_old) == 0) {
    summary_text <- paste0(summary_text, "- No data changes detected\n")
  } else {
    summary_text <- paste0(summary_text, paste(summary_items, collapse = "\n"), "\n")
    summary_text <- paste0(summary_text, sprintf("- **Total CUs Modified**: %d CUs with one or more changes\n", total_changed))
    
    # Add note about additions/deletions if applicable
    if (length(only_in_new) == 0 && length(only_in_old) == 0) {
      summary_text <- paste0(summary_text, "- **No CU Additions or Deletions**: All existing CUs retained\n")
    }
    
    summary_text <- paste0(summary_text, "\n**Impact for Analysts**: \n")
    summary_text <- paste0(summary_text, "- *[Manual summary of impact and required actions - to be filled in]*\n")
  }
  
  summary_text <- paste0(summary_text, "\n### Detailed Changes\n\n")
  
  # Build output
  output_text <- sprintf("## [%s]\n\n%s", formatted_date, summary_text)
  
  for (i in differing_indices) {
    output_text <- paste0(
      output_text,
      report_differences(new_matched$Key[i], new_matched[i, ], old_matched[i, ]),
      "\n"
    )
  }
  
  if (length(only_in_new) > 0) {
    output_text <- paste0(
      output_text,
      sprintf("- The new CU(s) added: %s\n", paste(only_in_new, collapse = ", "))
    )
  }
  
  if (length(only_in_old) > 0) {
    output_text <- paste0(
      output_text,
      sprintf("- The CU(s) deleted: %s\n", paste(only_in_old, collapse = ", "))
    )
  }
  
  # Insert into CHANGELOG.md
  if (file.exists(CHANGELOG_path)) {
    changelog_lines <- readLines(CHANGELOG_path)
    insert_position <- 4
    updated_changelog <- append(changelog_lines, output_text, after = insert_position - 1)
    writeLines(updated_changelog, CHANGELOG_path)
    cat("  ✓ CHANGELOG.md updated\n")
  } else {
    warning(sprintf("CHANGELOG.md not found at path: %s", CHANGELOG_path))
  }
  
  return(invisible(NULL))
}

# Run comparison
compare_and_update_changelog(formatted_new_file, current_file)

# Step 4: Move old version to previous_version folder with date
cat("\nStep 3: Archiving old version...\n")

# Create previous_version directory if it doesn't exist
if (!dir.exists(here(previous_version_dir))) {
  dir.create(here(previous_version_dir), recursive = TRUE)
  cat(sprintf("  ✓ Created directory: %s/\n", previous_version_dir))
}

# Create dated filename for old version
old_version_file <- sprintf("pacific_salmon_smu_cu_du_x_walk_%s.csv", old_date)
old_version_path <- file.path(previous_version_dir, old_version_file)

if (file.exists(here(current_file))) {
  file.copy(here(current_file), here(old_version_path), overwrite = TRUE)
  cat(sprintf("  ✓ Old version saved as: %s\n", old_version_path))
} else {
  cat(sprintf("  Note: No existing %s file to archive\n", current_file))
}

# Step 5: Replace current file with new version (strip date from filename)
cat("\nStep 4: Replacing current file...\n")
file.copy(here(formatted_new_file), here(current_file), overwrite = TRUE)
cat(sprintf("  ✓ Replaced %s with new version (date removed from filename)\n", current_file))

# Step 6: Archive raw input and clean up temporary files
raw_dir <- file.path(previous_version_dir, "raw_inputs")
if (!dir.exists(here(raw_dir))) {
  dir.create(here(raw_dir), recursive = TRUE)
  cat(sprintf("  ✓ Created directory for raw inputs: %s/\n", raw_dir))
}
raw_dest <- file.path(raw_dir, sprintf("%s_raw.csv", tools::file_path_sans_ext(basename(new_file))))
file.copy(here(new_file), here(raw_dest), overwrite = TRUE)
cat(sprintf("  ✓ Raw input preserved as: %s\n", raw_dest))

cat("\nStep 5: Cleaning up...\n")
file.remove(here(formatted_new_file))
cat(sprintf("  ✓ Removed temporary formatted file\n"))
file.remove(here(new_file))
cat(sprintf("  ✓ Removed original dated file from workspace (kept archived at %s)\n", raw_dest))

# Final summary
cat("\n🏁=== Update Complete ===🐟\n")
cat(sprintf("✓ Old version moved to: %s\n", old_version_path))
cat(sprintf("✓ New version installed as: %s\n", current_file))
cat(sprintf("✓ CHANGELOG.md updated with changes\n\n"))
cat("⚠️  IMPORTANT: Please manually review and fill in the 'Impact for Analysts' section in CHANGELOG.md\n")
