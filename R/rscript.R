Rscript <- R6::R6Class(
  "pkg_rscript",
  public = list(
    initialize = function(data, name) {
      private$data <- data
      private$name <- name
      self$.private <- private
    },
    print = function(...) {
      header <- sprintf("%s %s", cli::col_grey("<pkg_Script>"), cli::col_green(private$name))
      writeLines(c(header, prettycode::highlight(private$data)))
    },
    .private = NULL,
    edit = function() {
      flat_file_edit(self, private)
    }
  ),
  private = list(
    data = NULL,
    name = NULL
  )
)


#' @export
`$<-.pkg_rscript` <- function(x, name, value) {
  if (name %in% ls(x, all.names = TRUE)) return(NextMethod())
  code <- constructive::construct_multi(
    setNames(list(value), name),
    constructive::opts_function(environment = FALSE),
    check = FALSE
  )
  e <- x$.__enclos_env__$private
  e$data <- c(e$data, code$code)
  x
}
