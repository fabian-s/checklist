check_usage <- function(path) {
  if (!dir.exists(path)) {
    if (!file.exists(path)) stop("can't find directory or file.")
    files <- path
  } else {
    files <- list.files(path = path,
                        pattern = "\\.[Rr]$",
                        full.names = TRUE,
                        recursive = TRUE)
  }
  sapply(files, function(f) try(check_usage_file(f)))
  invisible(NULL)
}

#' @import codetools
check_usage_file <- function(file, env) {
  message("Checking usage in file <", basename(file), ">:\n")
  env <- new.env(parent = baseenv())
  # would be safer with R.utils::withTimeout
  source(file, local = env, echo = FALSE)

  # remove all non-function objects from env so that
  # "unclean" functions using global variables trigger checks
  constants <-  setdiff(ls.str(envir = env),
                        lsf.str(envir = env))
  do.call(rm, c(constants, envir = env))

  #add namespace exports of imported packages to parent of env
  # -> partial arg matches are found, fewer false positives for unknown globals
  env <- add_imported_functions(file, env)

  codetools::checkUsageEnv(env,
                           all = TRUE, #!!
                           suppressPartialMatchArgs = FALSE)
  invisible(NULL)
}

# return a named list containing all exported objects of packages
# imported in <file>
get_imported_functions <- function(file) {
  lines <- readLines(file)
  imports <- "(library|require)\\((\"|\')*([[:alnum:]\\.]+)(\"|\')*\\)"
  packages <- lines[grepl(imports, lines)]
  packages <- gsub(imports, "\\3", packages)
  packages <- unique(gsub("\\s", "", packages))
  functions <- lapply(packages,
                      function(pkg) {
                        sapply(getNamespaceExports(pkg),
                               get, envir = getNamespace(pkg))
                      })
  unlist(functions)
}

# add namespace exports of loaded packages to parent of env
add_imported_functions <- function(file, env) {
  functions <- get_imported_functions(file)
  mapply(assign, x = names(functions), value = functions,
         MoreArgs = list(envir = parent.env(env)))
  return(env)
}

