#' @import rex
#' @import lintr
# from https://github.com/ropenscilabs/checkers/blob/master/R/check_lintr.R
# @ d75176d23be79
lint_dir <- function(path, relative_path = TRUE, ...) {
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
      x[["filename"]] <- rex::re_substitutes(
        x[["filename"]], 
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

checklist_linters <- list(
  lintr::assignment_linter,
  lintr::closed_curly_linter,
  lintr::commas_linter,
  lintr::commented_code_linter,
  lintr::T_and_F_symbol_linter,
  lintr::object_name_linter(styles = "snake_case"),
  checklist:::cyclocomp_linter(complexity_limit = 10),
  lintr::object_length_linter(length = 30L),
  lintr::equals_na_linter,
  lintr::extraction_operator_linter,
  lintr::function_left_parentheses_linter,
  lintr::infix_spaces_linter,
  lintr::line_length_linter(80),
  lintr::no_tab_linter,
  lintr::open_curly_linter(allow_single_line = TRUE),
  lintr::absolute_path_linter(lax = TRUE),
  lintr::seq_linter,
  lintr::spaces_inside_linter,
  lintr::spaces_left_parentheses_linter,
  lintr::T_and_F_symbol_linter,
  lintr::undesirable_function_linter(),
  lintr::undesirable_operator_linter(),
  lintr::unneeded_concatenation_linter,
  checklist:::nonportable_names_linter,
  checklist:::undocumented_function_linter,
  checklist:::multiple_dot_args_linter
)
