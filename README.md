# checklist

<!-- badges: start -->
<!-- badges: end -->

Inspired by projects like [`{goodpractice}`](https://github.com/MangoTheCat/goodpractice) and [`{checkers}`](https://github.com/ropenscilabs/checkers), this package implements a semi-automated checklist for scripts and program files.  

Its ostensible primary purpose is to help people in my programming classes write better
code (i.e., come to grips with me being uptight and obsessive-compulsive about spaces and indentation).  
It's actual primary purpose is to save me from having to write out repetitive nagging comments about sloppy homework.

## Installation

``` r
remotes::install_github("fabian-s/checklist")
```

## Example


`{checklist}` only has one function, called `checklist`.  
The input for `checklist` is the path to a single R script file or a folder containing R scripts. 
`checklist` then runs a lot of different checks for proper formatting and sensible coding style on these. 
It is fairly likely to produce a lot of false positives, so use your judgment. 


```r
checklist::checklist(
  system.file("examples", package = "checklist")
)
```

```
## Starting checks.
## Checking file extensions.
## Always use the same file extension for the same filetype. You use R & r.
## #---------------------------------------------------------------#
## Running linters:
## bad format and filename.r:1:1: style: Use only standard letters, numbers,'_' and '-' and no spaces in file and folder names.
## bad format and filename
## ^  ~      ~   ~
## bad format and filename.r:2:1: style: Variable and function name style should be snake_case.
## this.is.rather.bad = function(buckelName)
## ^~~~~~~~~~~~~~~~~~
## bad format and filename.r:2:20: style: Use <-, not =, for assignment.
## this.is.rather.bad = function(buckelName)
##                    ^
## bad format and filename.r:2:31: style: Variable and function name style should be snake_case.
## this.is.rather.bad = function(buckelName)
##                               ^~~~~~~~~~
## bad format and filename.r:3:5: style: Opening curly braces should never go on their own line and should always be followed by a new line.
##     {
##     ^
## bad format and filename.r:4:3: warning: Function "sapply" is undesirable. As an alternative, use vapply() or lapply().
##   sapply(buckelName, function(x)c(x,1,2,  5 ))
##   ^~~~~~
## bad format and filename.r:4:37: style: Commas should always have a space after.
##   sapply(buckelName, function(x)c(x,1,2,  5 ))
##                                     ^
## bad format and filename.r:4:39: style: Commas should always have a space after.
##   sapply(buckelName, function(x)c(x,1,2,  5 ))
##                                       ^
## bad format and filename.r:4:44: style: Do not place spaces around code in parentheses or square brackets.
##   sapply(buckelName, function(x)c(x,1,2,  5 ))
##                                            ^
## bad format and filename.r:5:1: style: Lines should not be more than 80 characters.
##   "pofjulakljlkjflkajlkjlkjalsdkjaldkjalkjalkdjlaskdjalkdjallkjadlkjssdgsgsgdfsgsdgsg"
## ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## doubledots.R:3:15: style: functions should not forward ... multiple times.
##   stats::plot(...)
##               ^~~
## doubledots.R:4:13: style: functions should not forward ... multiple times.
##   stats::lm(...)
##             ^~~
## no_comment.R:1:1: style: Functions need comments defining their purpose, arguments & returns.
## no_comment <- function() {
## ^
## swipe_complicated.R:6:1: style: functions should have cyclomatic complexity of less than 10, this has 11.
## swipe <- function(swiper, picture, profile) {
## ^
## swipe_complicated.R:8:16: warning: Use `[[` instead of `$`  to extract an element.
##     if (picture$attractive) {
##                ^
## usage.R:2:1: warning: Function "library" is undesirable. As an alternative, use roxygen2's @importFrom statement in packages, or `::` in scripts.
## library(mvtnorm)
## ^~~~~~~
## using_TF.R:2:27: style: Use TRUE instead of the symbol T.
## using_tf <- function(y = T) {
##                          ~^
## using_TF.R:3:10: style: Use FALSE instead of the symbol F.
##   !y == F
##         ~^
## #---------------------------------------------------------------#
## Checking usage in file <bad format and filename.r>:
## Checking usage in file <doubledots.R>:
## Checking usage in file <no_comment.R>:
## Checking usage in file <swipe_complicated.R>:
## Checking usage in file <usage.R>:
## usage: warning in rmvnorm(1, m = c(x, y)): partial argument match of 'm' to 'mean' (~/checklist/examples/usage.R:8)
## usage: possible error in rmvnorm(1, m = c(x, y)): argument 2 matches multiple formal arguments (~/checklist/examples/usage.R:8)
## usage: no visible binding for global variable 'global' (~/checklist/examples/usage.R:12)
## usage: local variable 'assigned_but_unused' assigned but may not be used (~/checklist/examples/usage.R:11)
## usage: parameter 'unused' may not be used
## Checking usage in file <using_TF.R>:
## #---------------------------------------------------------------#
## Ok, so far so good. If anything has come up above, please look into it & get it fixed.
## (But some of the lints and alerts above may also be false positives --
## use your judgement, since you're using this package you must have excellent taste anyway...)
## The easiest way to fix the formatting is to run 'styler::style_dir'.
## #---------------------------------------------------------------#
## Now for some non-automated checks you need to do yourself:
## Think about defensive programming ----
## Did you include argument checks (using {checkmate}) in all your functions?
## Did you think about things like missing values, zero-length inputs, etc.?
## Did you run a bunch of tests and examples for these? 
## (y/n)
## Think about code smells ----
## Did you try to avoid conditional complexity?
## (avoiding 'else', homogenizing inputs, using early exits, etc..)
## You never did 'copy-paste-modify' anywhere, right? Keep it DRY, don't get WET!
## (y/n)
## Re-check your variable and function names --
## Are they meaningful, precise, unique, concise? Do they follow a consistent scheme?
## Did you avoid abbreviations and one-letter-names?
## #---------------------------------------------------------------#
## Ok, please fix everything that came up and then run me again to make sure. Bye!
```
