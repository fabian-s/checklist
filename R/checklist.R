#' Obsessive compulsive checks for style and structure
#' 
#' Run a semi-automated checklist on all files at `path`.
#' 
#' @param path defaults to working directory
#' @examples 
#' # run checklist() on the terrible examples that come with the package:
#' checklist::checklist(system.file("examples", package = "checklist"))
#' @export
checklist <- function(path = ".") {
  run_checks(path)
  
  message("Ok, so far so good. If anything has come up above, please look into it & get it fixed.")
  message("(But some of the lints and alerts above may also be false positives --")
  message("use your judgement, since you're using this package you must have excellent taste anyway...)")
  message("The easiest way to fix the formatting is to run 'styler::style_dir' or 'styler::style_file'")
  message("#---------------------------------------------------------------#")
  
  nag_user()
  
  message("Ok, please fix everything that came up and then run me again to make sure. Bye!\n")
  invisible(NULL)
}

run_checks <- function(path) {
  if (!file.exists(path)) stop("Can't find directory or file at ", path, ".")
  message("Starting checks.")
  try(check_extensions(path))
  message("#---------------------------------------------------------------#")
  message("Running linters:")
  lint_this <- ifelse(dir.exists(path), lintr::lint_dir, lintr::lint)
  lints <- try(lint_this(path, linters = checklist_linters))
  if (length(lints)) print(lints) else "Excellent!! -- lintr found no style problems!"
  message("#---------------------------------------------------------------#")
  try(check_usage(path))
  message("#---------------------------------------------------------------#")
  invisible(NULL)
}

nag_user <- function() {
  message("Now for some non-automated checks you need to do yourself:")
  defensive <- readline(
    paste0("Think about defensive programming ----\n",
           "Did you include argument checks (using {checkmate}) in all your functions?\n",
           "Did you think about things like missing values, zero-length inputs, etc.?\n",
           "Did you run a bunch of tests and examples for these?\n",
           "(y/n)"))
  if (defensive == "n") message("Uh oh! You're asking for trouble. Please do that now.")
  smell <- readline(
    paste0("Think about code smells ----\n",
           "Did you try to avoid conditional complexity?\n", 
           "(avoiding 'else', homogenizing inputs, using early exits, etc..)\n",
           "You never did 'copy-paste-modify' anywhere, right? Keep it DRY, don't get WET!\n",
           "(y/n)"))
  if (smell == "n") message("Not good! Go back and make it better, please...")
  names <- readline(
    paste0("Re-check your variable and function names --\n",
           "Are they meaningful, precise, unique, concise? Do they follow a consistent scheme?\n",
           "Did you avoid abbreviations and one-letter-names?\n",
           "(y/n)"))
  if (names == "n") message("Well, do better. Try to make your code easy to understand.")
  message("#---------------------------------------------------------------#")
  invisible(NULL)
}