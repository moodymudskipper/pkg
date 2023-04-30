
pkg_dump <- function(self) {
  dump_rfolder(self)
  dump_description(self)
  dump_namespace(self)
  # dump_scripts(pkg, path)
  # dump_description(pkg, path)
  # dump_namespace(pkg, path)
  # dump_doc(pkg, path)
  # dump_data(pkg, path)
  # dump_inst(pkg, path)
  # dump_vignettes(pkg, path)
  # dump_tests(pkg, path)
  # dump_readme(pkg, path)
  # dump_license(pkg, path)
  # dump_citation(pkg, path)
  # dump_src(pkg, path)
  invisible(self)
}

dump_rfolder <- function(self) {
  rscripts <- lapply(self$R, function(rscript) rscript$.private$data)
  dir.create(file.path(self$path, "R"), showWarnings = FALSE)
  for (nm in names(rscripts)) {
    writeLines(rscripts[[nm]], file.path(self$path, "R", nm))
  }
}

dump_description <- function(self) {
  write.dcf(self$DESCRIPTION$.private$data, file.path(self$path, "DESCRIPTION"))
}

dump_namespace <- function(self) {
  writeLines(self$NAMESPACE$.private$data, file.path(self$path, "NAMESPACE"))
}
