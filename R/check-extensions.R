#' @import tools
check_extensions <- function(path) {
  message("Checking file extensions.\n")
  files <- list.files(path, full.names = TRUE, recursive = TRUE)
  file_extensions <- sapply(files, tools::file_ext)
  uniques <- unique(file_extensions)
  used <- NULL
  sweave <- c("Snw", "snw")
  if (all(sweave %in% uniques))
    used <- c(used, paste(sweave, collapse = " & "))
  knitr <- c("Rnw", "rnw")
  if (all(knitr %in% uniques))
    used <- c(used, paste(knitr, collapse = " & "))
  rmd <- c("Rmd", "rmd")
  if (all(rmd %in% uniques))
    used <- c(used, paste(rmd, collapse = " & "))
  rscript <- c("R", "r")
  if (all(rscript %in% uniques))
    used <- c(used, paste(rscript, collapse = " & "))
  rds <- c("RDS", "Rds", "rds")
  if (sum(rds %in% uniques) > 1)
    used <- c(used, paste(rds[rds %in% uniques], collapse = " & "))
  rdata <- c("RData", "Rdata", "rData", "rdata", "Rda", "rda")
  if (sum(rdata %in% uniques) > 1)
    used <- c(used, paste(rdata[rdata %in% uniques], collapse = " & "))
  if (length(used) == 0) invisible(NULL)
  message(
    "Always use the same file extension for the same filetype. You use ",
    paste0(state$inconsistent_extensions, collapse = ", "), "."
  )
  invisible(NULL)
}
