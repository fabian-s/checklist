#' @import lintr
nonportable_names_linter <- function(source_file) {
  if (is.null(source_file[["file_lines"]])) {
    # abort if source_file is an expression and not entire file
    return(NULL)
  }
  filename <- tools::file_path_sans_ext(basename(source_file[["filename"]]))
  hits <- !grepl("^[0-9a-zA-Z\\_\\/\\-]+$",
                 strsplit(filename, "")[[1]])
  if (!any(hits)) {
    return(list(NULL))
  }
  hit_list <- lapply(which(hits), rep, each = 2)
  lintr::Lint(
    filename = source_file[["filename"]],
    line_number = 1,
    column_number = 1,
    type = "style",
    message = "Use only standard letters, numbers,'_' and '-' and no spaces in file and folder names.",
    line = filename,
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
      filename = source_file[["filename"]],
      line_number = line,
      column_number = 1,
      type = "style",
      message = "Functions need comments defining their purpose, arguments & returns.",
      line = source_file[["file_lines"]][line],
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
  
  # as logical so zero matches don't make <which> tap out.
  fun_defs <- which(as.logical(
    zoo::rollapply(parse_data[["token"]],
                                   width = 7,
                                   function(tokens)
                                     all(tokens == fun_def_tokens1) |
                                     all(tokens == fun_def_tokens2))))
  parse_data[fun_defs, "line1"]
}

check_preceding_comment <- function(first_lines, source_file) {
  # is at least one entire line above a comment?
  vapply(first_lines,
         function(line) {
           if (line == 1) return(FALSE)
           grepl(pattern = "^[[:blank:]]*#", 
                 source_file[["file_lines"]][line - 1])
         }, logical(1))
}

#-------------------------------------------------------------------------------

multiple_dot_args_linter <- function(source_file) {
  if (!is.null(source_file[["file_lines"]])) {
    # abort if source_file is entire file, not a top level expression.
    return(NULL)
  }
  parsed <- source_file$parsed_content
  has_dot_args <- any(parsed$text == "..." & parsed$token == "SYMBOL_FORMALS")
  if (!has_dot_args) {
    return(NULL)
  }
  dot_call_locs <- get_dot_call_locs(parsed)
  if (sum(!duplicated(parsed[dot_call_locs, "text"])) < 2) {
    return(NULL)
  }
  lapply(dot_call_locs, function(loc) {
    lint <- parsed[loc + which(parsed$text[-(1:loc)] == "...")[1],]
    Lint(
      filename = source_file[["filename"]],
      line_number = lint[["line1"]],
      column_number = lint[["col1"]],
      ranges = list(c(lint[["col1"]], lint[["col2"]])),
      type = "style",
      message = "functions should not forward ... multiple times.",
      line = source_file$lines[as.character(lint[["line1"]])],
      linter = "multiple_dots_linter"
    )
  })
}

get_dot_call_locs <- function(parsed) {
  # parsed[parsed$line1 %in% c(21, 22),]
  dot_locs <- which((parsed$text == "...") & (parsed$token == "SYMBOL"))
  # find the expr that contains the arguments of the function calls to
  # which the dots belong
  dot_parents <-
    subset(parsed, parent %in%
             subset(parsed, id %in% parsed[dot_locs, "parent"])$parent)$id
  # find lines of function calls for these argument list expressions
  # ignore list(...)
  with(parsed,
       which(parent %in% dot_parents &
               token == "SYMBOL_FUNCTION_CALL" &
               text != "list"))
}

#-------------------------------------------------------------------------------

cyclocomp_linter <- function(complexity_limit = 25) {
function(source_file) {
  if (!is.null(source_file[["file_lines"]])) {
    # abort if source_file is entire file, not a top level expression.
    return(NULL)
  }
  complexity <- lintr:::try_silently(
    cyclocomp::cyclocomp(parse(text = source_file$content))
  )
  if (inherits(complexity, "try-error")) return(NULL)
  if (complexity <= complexity_limit) return(NULL)
  lintr::Lint(
    filename = source_file[["filename"]],
    line_number = source_file[["line"]][1],
    column_number = source_file[["column"]][1],
    type = "style",
    message = paste0(
      "functions should have cyclomatic complexity of less than ",
      complexity_limit, ", this has ", complexity,"."
    ),
    ranges = list(c(source_file[["column"]][1], source_file[["column"]][1])),
    line = source_file$lines[1],
    linter = "cyclocomp_linter"
  )
}
}
