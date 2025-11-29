# This script compares the current version of pacific_salmon_smu_cu_du_x_walk.csv with a previous version
# and reports any differences in the data.

library(here)

normalize_names <- function(nms) {
  nms <- sub("^\\ufeff", "", nms)        # strip BOM if present
  nms <- sub("^X\\.+", "", nms)          # remove R's BOM-prefix artefact
  nms <- gsub("\\.", "_", nms)
  nms <- gsub(" ", "_", nms)
  nms
}

compare_crosswalks <- function() {
  # Project root
  project_root <- here::here()
  
  # Path for the CHANGELOG.md
  CHANGELOG_path <- file.path(project_root, "CHANGELOG.md")
  
  # Define paths
  # previous_data_path <- file.path(project_root, "supplemental_materials", "previous_version")
  # current_file <- file.path(project_root, "pacific_salmon_smu_cu_du_x_walk_2025-06-13.csv")
  # previous_file <- file.path(previous_data_path, "pacific_salmon_smu_cu_du_x_walk_2025-06-12.csv")
  
  
  # Ask user to input filenames
  current_filename <- readline(prompt = "Enter the current CSV filename (e.g., pacific_salmon_smu_cu_du_x_walk.csv): ")
  previous_filename <- readline(prompt = "Enter the previous CSV filename or path (e.g., previous_version.csv or path/to/file.csv): ")
  
  # Define paths
  # Current file is in project root
  current_file <- file.path(project_root, current_filename)
  # Previous file can be anywhere - check if it's a full path or relative path
  if (file.exists(previous_filename)) {
    previous_file <- previous_filename
  } else if (file.exists(file.path(project_root, previous_filename))) {
    previous_file <- file.path(project_root, previous_filename)
  } else {
    stop(sprintf("Previous file not found: %s", previous_filename))
  }
  
  # Read data - files should already have underscores in column names
  current_data <- read.csv(current_file, stringsAsFactors = FALSE, check.names = FALSE)
  previous_data <- read.csv(previous_file, stringsAsFactors = FALSE, check.names = FALSE)
  names(current_data) <- normalize_names(names(current_data))
  names(previous_data) <- normalize_names(names(previous_data))
  
  # Define key column (using underscore format)
  key_col <- "CU_Full_Index"
  
  # Validate key column presence
  if (!(key_col %in% colnames(current_data)) || !(key_col %in% colnames(previous_data))) {
    cat("Current columns:", paste(colnames(current_data), collapse=", "), "\n")
    cat("Previous columns:", paste(colnames(previous_data), collapse=", "), "\n")
    stop(sprintf("Column '%s' not found in one or both datasets.", key_col))
  }
  
  # Rename key column for simplicity
  names(current_data)[names(current_data) == key_col] <- "Key"
  names(previous_data)[names(previous_data) == key_col] <- "Key"
  
  # Extract keys
  keys_current <- current_data$Key
  keys_previous <- previous_data$Key
  
  # Find new and deleted keys
  only_in_current <- setdiff(keys_current, keys_previous)
  only_in_previous <- setdiff(keys_previous, keys_current)
  
  # Get keys common to both datasets
  common_keys <- intersect(keys_current, keys_previous)
  
  # Filter matching rows
  current_matched <- current_data[current_data$Key %in% common_keys, ]
  previous_matched <- previous_data[previous_data$Key %in% common_keys, ]
  
  # Sort rows by Key for alignment
  current_matched <- current_matched[order(current_matched$Key), ]
  previous_matched <- previous_matched[order(previous_matched$Key), ]
  
  # Identify differing rows
  # Only compare columns that exist in both datasets
  common_cols <- intersect(setdiff(names(current_matched), "Key"), 
                           setdiff(names(previous_matched), "Key"))
  compare_cols <- common_cols
  
  if (length(compare_cols) == 0) {
    differing_indices <- integer(0)
  } else {
    comparison_matrix <- mapply(function(col) {
      curr_col <- current_matched[[col]]
      prev_col <- previous_matched[[col]]
      (curr_col == prev_col) | (is.na(curr_col) & is.na(prev_col))
    }, compare_cols)
    
    # Handle case where comparison_matrix might be a vector instead of matrix
    if (is.vector(comparison_matrix)) {
      row_diff <- !comparison_matrix
    } else {
      row_diff <- !apply(comparison_matrix, 1, all)
    }
    differing_indices <- which(row_diff)
  }
  
  # If no differences and no additions/deletions, return 'No changes'
  if (length(differing_indices) == 0 && length(only_in_current) == 0 && length(only_in_previous) == 0) {
    return("No changes")
  }
  
  # Format date
  formatted_date <- format(Sys.Date(), "%Y.%m.%d")
  
  # Analyze changes for summary
  change_types <- list(
    dfo_area = 0,
    cu_common_name = 0,
    du_info = 0,
    other = 0
  )
  
  du_info_cus <- character()
  cu_common_name_cus <- character()
  dfo_area_cus <- character()
  
  # Function to report differences for a single row
  report_differences <- function(key, curr_row, prev_row) {
    text <- sprintf("##### CU FULL INDEX: %s\n", key)
    du_fields <- list()
    
    for (col in compare_cols) {
      curr_val <- curr_row[[col]]
      prev_val <- prev_row[[col]]
      col_print <- gsub("_", " ", col)
      
      if (!((is.na(curr_val) && is.na(prev_val)) || identical(curr_val, prev_val))) {
        # Track change types for summary
        if (col == "DFO_Area") {
          change_types$dfo_area <<- change_types$dfo_area + 1
          dfo_area_cus <<- c(dfo_area_cus, key)
        } else if (col == "CU_Common_Name" && (is.na(prev_val) || prev_val == "")) {
          change_types$cu_common_name <<- change_types$cu_common_name + 1
          cu_common_name_cus <<- c(cu_common_name_cus, key)
        } else if (grepl("^DU_", col)) {
          du_fields[[col]] <- list(prev = prev_val, curr = curr_val)
        } else {
          change_types$other <<- change_types$other + 1
        }
        
        # Format output - use arrow notation for cleaner display
        if (col == "CU_Common_Name" && (is.na(prev_val) || prev_val == "")) {
          text <- paste0(text, sprintf("- **CU Common Name Added**: `'%s'`\n", curr_val))
        } else if (length(du_fields) > 0 && col == "DU_Acronym") {
          # Skip individual DU fields - will consolidate below
        } else if (!grepl("^DU_", col)) {
          # Use arrow notation for non-DU fields
          prev_display <- ifelse(is.na(prev_val) || prev_val == "", "''", prev_val)
          curr_display <- ifelse(is.na(curr_val) || curr_val == "", "''", curr_val)
          text <- paste0(text, sprintf("- **%s**: `'%s'` → `'%s'`\n", col_print, prev_display, curr_display))
        }
      }
    }
    
    # Consolidate DU information if present
    if (length(du_fields) > 0) {
      du_parts <- character()
      if (!is.null(du_fields$DU_Name) && !is.na(du_fields$DU_Name$curr) && du_fields$DU_Name$curr != "") {
        du_parts <- c(du_parts, sprintf("Name=`'%s'`", du_fields$DU_Name$curr))
      }
      if (!is.null(du_fields$DU_Number) && !is.na(du_fields$DU_Number$curr) && du_fields$DU_Number$curr != "") {
        du_parts <- c(du_parts, sprintf("Number=`'%s'`", du_fields$DU_Number$curr))
      }
      if (!is.null(du_fields$DU_Full_Index) && !is.na(du_fields$DU_Full_Index$curr) && du_fields$DU_Full_Index$curr != "") {
        du_parts <- c(du_parts, sprintf("Index=`'%s'`", du_fields$DU_Full_Index$curr))
      }
      if (!is.null(du_fields$DU_Acronym) && !is.na(du_fields$DU_Acronym$curr) && du_fields$DU_Acronym$curr != "") {
        du_parts <- c(du_parts, sprintf("Acronym=`'%s'`", du_fields$DU_Acronym$curr))
      }
      
      if (length(du_parts) > 0) {
        change_types$du_info <<- change_types$du_info + 1
        du_info_cus <<- c(du_info_cus, key)
        text <- paste0(text, sprintf("- **DU Information Added**: %s\n", paste(du_parts, collapse = ", ")))
      }
    }
    
    text
  }
  
  # Generate summary section
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
  if (length(only_in_current) > 0) {
    summary_items <- c(summary_items, 
      sprintf("- **New CUs Added**: %d CUs", length(only_in_current)))
  }
  if (length(only_in_previous) > 0) {
    summary_items <- c(summary_items, 
      sprintf("- **CUs Deleted**: %d CUs", length(only_in_previous)))
  }
  
  if (length(summary_items) == 0 && total_changed == 0 && length(only_in_current) == 0 && length(only_in_previous) == 0) {
    summary_text <- paste0(summary_text, "- No data changes detected\n")
  } else {
    summary_text <- paste0(summary_text, paste(summary_items, collapse = "\n"), "\n")
    summary_text <- paste0(summary_text, sprintf("- **Total CUs Modified**: %d CUs with one or more changes\n", total_changed))
    
    # Add impact note placeholder
    summary_text <- paste0(summary_text, "\n**Impact for Analysts**: \n")
    summary_text <- paste0(summary_text, "- *[Manual summary of impact and required actions - to be filled in]*\n")
  }
  
  summary_text <- paste0(summary_text, "\n### Detailed Changes\n\n")
  
  # Start building output text
  output_text <- sprintf("## [%s]\n\n%s", formatted_date, summary_text)
  
  for (i in differing_indices) {
    output_text <- paste0(
      output_text,
      report_differences(current_matched$Key[i], current_matched[i, ], previous_matched[i, ]),
      "\n"
    )
  }
  
  if (length(only_in_current) > 0) {
    output_text <- paste0(
      output_text,
      sprintf("- The new CU(s) added: %s\n", paste(only_in_current, collapse = ", "))
    )
  }
  
  if (length(only_in_previous) > 0) {
    output_text <- paste0(
      output_text,
      sprintf("- The CU(s) deleted: %s\n", paste(only_in_previous, collapse = ", "))
    )
  }
  
  # Insert into CHANGELOG.md if file exists
  if (file.exists(CHANGELOG_path)) {
    changelog_lines <- readLines(CHANGELOG_path)
    insert_position <- 4
    updated_changelog <- append(changelog_lines, output_text, after = insert_position - 1)
    writeLines(updated_changelog, CHANGELOG_path)
  } else {
    warning(sprintf("CHANGELOG.md not found at path: %s", CHANGELOG_path))
  }
  
  return(output_text)
}

# Run and print the report
cat(compare_crosswalks(), "\n\nChange results have been saved into CHANGELOG.md")
