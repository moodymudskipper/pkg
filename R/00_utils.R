# edit an R6 object representing a flat file and stored as character, like NAMESPACE or Rscripts
flat_file_edit <- function(self, private) {
  tmp <- tempfile()
  on.exit(file.remove(tmp))
  writeLines(private$data, con = tmp)
  try(edit(file = tmp), silent = TRUE)
  private$data <- fetch_namespace(tmp)
  invisible(self)
}
