#' @export
print.pkg_serialized_package <- function(x, ...) {
  writeLines(sprintf("Serialized package: {%s} (%s)", attr(x, "name"), format(object.size(x))))
  invisible(x)
}
