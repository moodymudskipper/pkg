fetch_description <- function(path = "DESCRIPTION", fallback_name = NULL) {
  if (!file.exists(path)) return(default_description(name = fallback_name))
  # TODO: add cleanup
  as.data.frame(read.dcf(path))
}

fetch_r <- function(path = "R") {
  paths <- list.files(path, full.names = TRUE)
  if (!length(paths)) return(NULL)
  lapply(setNames(paths, basename(paths)), readLines)
}
