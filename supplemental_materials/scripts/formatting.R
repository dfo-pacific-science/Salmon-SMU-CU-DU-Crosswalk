# Update pacific_salmon_smu_cu_du_x_walk.csv column names:
# convert spaces (read as dots) to underscores and write the file back.
library(here)

normalize_names <- function(nms) {
  nms <- sub("^\\ufeff", "", nms)        # strip BOM if present
  nms <- sub("^X\\.+", "", nms)          # remove R's BOM-prefix artefact
  nms <- gsub("\\.", "_", nms)
  nms <- gsub(" ", "_", nms)
  nms
}

smu.crosswalk.src <- read.csv(here("pacific_salmon_smu_cu_du_x_walk.csv"), stringsAsFactors = FALSE, check.names = FALSE)

#replace dots with underscores
names(smu.crosswalk.src) <- normalize_names(names(smu.crosswalk.src))

names(smu.crosswalk.src)

#write the file back to the original location
write.csv(smu.crosswalk.src, here("pacific_salmon_smu_cu_du_x_walk.csv"), row.names = FALSE, na = "")
