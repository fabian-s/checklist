#' @import lintr
# from https://github.com/ropenscilabs/checkers/blob/master/R/check_lintr.R
# @ d75176d23be79
lint_dir <- function(path, relative_path = TRUE, ...)
{
  files <- dir(path = path,
               pattern = "\\.(R|r)$", recursive = TRUE,
               full.names = TRUE)
  files <- normalizePath(files)
  lints <- lintr:::flatten_lints(lapply(files, function(file) {
    lintr::lint(file, ..., parse_settings = FALSE)
  }))
  lints <- lintr:::reorder_lints(lints)
  if (relative_path == TRUE) {
    lints[] <- lapply(lints, function(x) {
      x$filename <- rex::re_substitutes(
        x$filename, 
        rex::rex(normalizePath(path), one_of("/", "\\")), 
        ""
        )
      x
    })
    attr(lints, "path") <- path
  }
  class(lints) <- "lints"
  return(lints)
}