# names methods

# Repo -------------------------------------------------------------------------

#' @export
names.pkg_Repo <- function(x) {
  setdiff(ls(x, all.names = TRUE), c("initialize", "print", "clone", ".__enclos_env__", "private"))
}

#' @export
.DollarNames.pkg_Repo <- function(x, pattern="") {
  names(x)
}

# Package ----------------------------------------------------------------------

#' @export
names.pkg_Package <- function(x) {
  setdiff(ls(x, all.names = TRUE), c("initialize", "print", "clone", ".__enclos_env__", ".private"))
}

#' @export
.DollarNames.pkg_Package <- function(x, pattern="") {
  names(x)
}

# Description ------------------------------------------------------------------

#' @export
names.pkg_DESCRIPTION <- function(x) {
  setdiff(ls(x, all.names = TRUE), c("initialize", "print", "clone", ".__enclos_env__", ".private"))
}

#' @export
.DollarNames.pkg_DESCRIPTION <- function(x, pattern="") {
  names(x)
}

# Namespace --------------------------------------------------------------------

#' @export
names.pkg_NAMESPACE <- function(x) {
  setdiff(ls(x, all.names = TRUE), c("initialize", "print", "clone", ".__enclos_env__", ".private"))
}

#' @export
.DollarNames.pkg_NAMESPACE <- function(x, pattern="") {
  names(x)
}

# rscript ----------------------------------------------------------------------

#' @export
names.pkg_rscript <- function(x) {
  setdiff(ls(x, all.names = TRUE), c("initialize", "print", "clone", ".__enclos_env__", ".private"))
}

#' @export
.DollarNames.pkg_rscript<- function(x, pattern="") {
  names(x)
}
