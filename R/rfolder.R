new_rfolder <- function(rscripts) {
  structure(
    class = "pkg_rfolder",
    mapply(
      FUN = Rscript$new,
      data = rscripts,
      name = names(rscripts),
      SIMPLIFY = FALSE
    )
  )
}

#' @export
`$<-.pkg_rfolder` <- function(x, name, value) {
  if (!endsWith(name, ".R")) stop("R scripts must have a '.R' extension")
  if (!is.list(value)) return(NextMethod())
  code <- constructive::construct_multi(
    value,
    constructive::opts_function(environment = FALSE),
    check = FALSE
  )
  rscripts <- lapply(x, function(rscript) rscript$.__enclos_env__$private$data)
  rscripts[[name]] <- code$code
  new_rfolder(rscripts)
}
