# This script compares the current version of pacific_salmon_smu_cu_du_x_walk.csv with a previous version
# and reports any differences in the data.


compare_crosswalks <- function() {
  # Get the current working directory and project root
  cwd <- getwd()
  project_root <- dirname(dirname(cwd))
  
  # Path for the CHANGELOG.md
  CHANGELOG_path <- file.path(project_root, "CHANGELOG.md")
  
  # Define paths
  # previous_data_path <- file.path(project_root, "supplemental_materials", "previous_version")
  # current_file <- file.path(project_root, "pacific_salmon_smu_cu_du_x_walk_2025-06-13.csv")
  # previous_file <- file.path(previous_data_path, "pacific_salmon_smu_cu_du_x_walk_2025-06-12.csv")
  
  
  # Ask user to input filenames
  current_filename <- readline(prompt = "Enter the current CSV filename (e.g., pacific_salmon_smu_cu_du_x_walk_2025-06-13.csv): ")
  previous_filename <- readline(prompt = "Enter the previous CSV filename (e.g., pacific_salmon_smu_cu_du_x_walk_2025-06-12.csv): ")
  
  # Define paths
  previous_data_path <- file.path(project_root, "supplemental_materials", "previous_version")
  current_file <- file.path(project_root, current_filename)
  previous_file <- file.path(previous_data_path, previous_filename)
  
  # Read data
  current_data <- read.csv(current_file, stringsAsFactors = FALSE)
  previous_data <- read.csv(previous_file, stringsAsFactors = FALSE)
  
  # Define key column
  key_col <- "CU.Full.Index"
  
  # Validate key column presence
  if (!(key_col %in% colnames(current_data)) || !(key_col %in% colnames(previous_data))) {
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
  compare_cols <- setdiff(names(current_matched), "Key")
  
  comparison_matrix <- mapply(function(col) {
    curr_col <- current_matched[[col]]
    prev_col <- previous_matched[[col]]
    (curr_col == prev_col) | (is.na(curr_col) & is.na(prev_col))
  }, compare_cols)
  
  row_diff <- !apply(comparison_matrix, 1, all)
  differing_indices <- which(row_diff)
  
  # If no differences and no additions/deletions, return 'No changes'
  if (length(differing_indices) == 0 && length(only_in_current) == 0 && length(only_in_previous) == 0) {
    return("No changes")
  }
  
  # Format date
  formatted_date <- format(Sys.Date(), "%Y.%m.%d")
  
  # Function to report differences for a single row
  report_differences <- function(key, curr_row, prev_row) {
    text <- sprintf("##### CU FULL INDEX: %s\n", key)
    for (col in compare_cols) {
      curr_val <- curr_row[[col]]
      prev_val <- prev_row[[col]]
      col_print <- gsub("\\.", " ", col)
      if (!((is.na(curr_val) && is.na(prev_val)) || identical(curr_val, prev_val))) {
        text <- paste0(
          text,
          sprintf("- **%s**: Changed from `'%s'` to `'%s'` \n", col_print, prev_val, curr_val)
        )
      }
    }
    text
  }
  
  # Start building output text
  output_text <- sprintf("## [%s]\n", formatted_date)
  
  for (i in differing_indices) {
    output_text <- paste0(
      output_text,
      report_differences(current_matched$Key[i], current_matched[i, ], previous_matched[i, ]),
      "\n --- \n"
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
