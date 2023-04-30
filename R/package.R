# Package ----------------------------------------------------------------------

#' @export
Package <- R6::R6Class(
  "pkg_Package",
  public = list(
    initialize = function(path = NULL) pkg_initialize(self, private, path),
    print = function() pkg_print(self),
    .private = NULL,
    path = NULL,
    DESCRIPTION = NULL,
    NAMESPACE = NULL,
    # README = NULL,
    # LICENSE = NULL,
    # CITATION = NULL,
    R = NULL,
    # doc = NULL,
    # data = NULL,
    # inst = NULL,
    # vignettes = NULL,
    # tests = NULL,
    # src = NULL,
    dump = function() {
      pkg_dump(self)
    },
    install = function(reload = TRUE, quick = FALSE, build = !quick, args = getOption("devtools.install.args"),
                       quiet = FALSE, dependencies = NA, upgrade = "default", build_vignettes = FALSE,
                       keep_source = getOption("keep.source.pkgs"),force = FALSE, ...) {
      devtools::install(
        pkg = self$path, reload, quick, build, args, quiet, dependencies, upgrade,
        build_vignettes, keep_source, force,...
      )
    },
    load = function(reset = TRUE, recompile = FALSE, export_all = TRUE, helpers = TRUE, quiet = FALSE, ...) {
      self$dump()
      devtools::load_all(self$path, reset, recompile, export_all, helpers, quiet, ...)
    },
    build = function( path = NULL, binary = FALSE, vignettes = TRUE, manual = FALSE, args = NULL, quiet = FALSE, ...) {
      devtools::build(pkg = self$path, path, binary, vignettes, manual, args, quiet, ...)
    },
    serialize = function() {
      pkg_serialize(self)
    }
  ),
  private = list(
    dump_rfolder = dump_rfolder,
    dump_description = dump_description,
    dump_namespace = dump_namespace
  )
)


# tools ----------------------------------------------------------------------------

pkg_initialize <- function(self, private, path = NULL) {
  if (is.null(path)) path <- tempfile("pkg")
  if (!dir.exists(path)) dir.create(path)
  self$path <- path
  self$DESCRIPTION <- Description$new(
    fetch_description(file.path(path, "DESCRIPTION"), fallback_name = basename(path))
  )
  self$NAMESPACE <- Namespace$new(fetch_namespace(file.path(path, "NAMESPACE")))
  rscripts <- fetch_r(file.path(path, "R"))
  self$R <- new_rfolder(rscripts)
  self$.private <- private
}

pkg_print <- function(self) {
  fields <- c("Package", "Title", "Version")
  values <- self$DESCRIPTION$.private$data[fields]
  writeLines(c(
    cli::col_grey(paste("<pkg_Package>", self$path)),
    sprintf("%s: %s", cli::col_blue(fields), values)
  ))
}

pkg_serialize <- function(self) {
  self$dump()
  paths <- list.files(self$path, full.names = TRUE, include.dirs = TRUE)
  tmp <- tempfile(fileext = ".zip")
  on.exit(file.remove(tmp))
  zip(tmp, paths, flags="-q")
  structure(
    class = "pkg_serialized_package",
    name = self$DESCRIPTION$.private$data$Package,
    readBin(tmp, "raw", file.info(tmp)$size)
  )
}


#' @export
`$<-.pkg_Package` <- function(x, name, value) {
  if (name %in% ls(x, all.names = TRUE)) return(NextMethod())
  code <- constructive::construct_multi(
    setNames(list(value), name),
    constructive::opts_function(environment = FALSE),
    check = FALSE
  )
  rscripts <- lapply(x$R, function(rscript) rscript$.private$data)
  rscripts[[paste0(name, ".R")]] <- code$code
  x$R <- new_rfolder(rscripts)
  x
}
