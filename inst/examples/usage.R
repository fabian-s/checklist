global <- 1
library(mvtnorm)

# check usage
usage <- function(x, y, unused) {
  ok <- "ok"
  unknown <- 2 * unknown
  use_loaded_pkg <- rmvnorm(1, m = c(x, y))
  pkg_via_ns <- MASS::as.fractions(y)
  call_user_function <- user_function(x)
  assigned_but_unused <- 4
  from_global <- global + 1
  
  list(ok, unknown, use_loaded_pkg, pkg_via_ns, call_user_function,
       from_global)
}

# comment
user_function <- function(x) x
