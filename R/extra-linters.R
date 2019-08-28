#' @import lintr
nonportable_names_linter <- function(source_file) {
  if (is.null(source_file[["file_lines"]])) {
    # abort if source_file is an expression and not entire file
    return(NULL)
  }
  filename <- tools::file_path_sans_ext(source_file$filename)
  hits <- !grepl("^[0-9a-zA-Z\\_\\/\\-]+$",
                 strsplit(filename, "")[[1]])
  if (!any(hits)) {
    return(list(NULL))
  }
  hit_list <- lapply(which(hits), rep, each = 2)
  lintr::Lint(
    filename = source_file$filename,
    line_number = 1,
    column_number = 1,
    type = "style",
    message = "Use only standard letters, numbers,'_' and '-' and no spaces in file and folder names.",
    line = source_file$filename,
    linter = "nonportable_names_linter",
    ranges = hit_list
  )
}

#-------------------------------------------------------------------------------

#' @import utils
undocumented_function_linter <- function(source_file) {
  if (is.null(source_file[["file_lines"]])) {
    # abort if source_file is an expression and not entire file
    return(NULL)
  }
  parse_data <- utils::getParseData(parse(text = source_file[["file_lines"]],
                                   keep.source = TRUE))
  first_lines <- find_fun_defs(parse_data)
  has_comments <- check_preceding_comment(first_lines, source_file)
  lapply(first_lines[!has_comments], function(line) {
    lintr::Lint(
      filename = source_file$filename,
      line_number = line,
      column_number = 1,
      type = "style",
      message = "Functions need comments defining their purpose, arguments & returns.",
      line = source_file$file_lines[line],
      linter = "undocumented_function_linter",
      ranges = list(c(1, 1))
    )
  })
}


#'@importFrom zoo rollapply
find_fun_defs <- function(parse_data) {
  # every function definition looks like this:
  fun_def_tokens1 <-
    c("expr",
      "SYMBOL",
      "expr",
      "LEFT_ASSIGN",
      "expr",
      "FUNCTION",
      "'('")
  # ... or maybe uses = not <- for assignment:
  fun_def_tokens2 <- fun_def_tokens1
  fun_def_tokens2[4] <- "EQ_ASSIGN"

  fun_defs <- which(zoo::rollapply(parse_data$token,
                                   width = 7,
                                   function(tokens)
                                     all(tokens == fun_def_tokens1) |
                                     all(tokens == fun_def_tokens2)))
  parse_data[fun_defs, "line1"]
}

check_preceding_comment <- function(first_lines, source_file) {
  # is at least one entire line above a comment?
  vapply(first_lines,
         function(line) {
           if (line == 1) return(FALSE)
           grepl(pattern = "^[[:blank:]]*#", 
                 source_file$file_lines[line - 1])
         }, logical(1))
}
