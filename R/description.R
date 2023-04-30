Description <- R6::R6Class(
  "pkg_DESCRIPTION",
  public = list(
    initialize = function(data) {
      private$data <- data
      self$.private <- private
    },
    print = function(x, ...) {
      tmp <- tempfile()
      on.exit(file.remove(tmp))
      write.dcf(private$data, tmp)
      writeLines(readLines(tmp))
    },
    .private = NULL,
    edit = function() DESCRIPTION_edit(self, private),
    set = function(Package = NA, Version  = NA, License = NA, Description  = NA, Title = NA,
                   Author = NA, Maintainer = NA, Authors.R  = NA, Depends = NA, Imports = NA,
                   Suggests = NA, Enhances = NA, LinkingTo  = NA, ...) {
      DESCRIPTION_set(private, Package, Version , License, Description, Title, Author,
                      Maintainer, Authors.R, Depends, Imports, Suggests, Enhances, LinkingTo, ...)
    }
  ),
  private = list(
    data = NULL
  )
)

default_description <- function(name) {
  data.frame(
    Package = name,
    Title = "What the Package Does (One Line, Title Case)",
    Version = "0.0.0.9000",
    `Authors@R` = 'person("First", "Last", , "first.last@example.com", role = c("aut", "cre"), comment = c(ORCID = "YOUR-ORCID-ID"))',
    Description = "What the package does (one paragraph).",
    License = "`use_mit_license()`, `use_gpl3_license()` or friends to pick a license",
    Encoding = "UTF-8",
    Roxygen = "list(markdown = TRUE)",
    RoxygenNote = as.character(packageVersion("roxygen2"))
  )
}

DESCRIPTION_edit <- function(self, private) {
  tmp <- tempfile()
  on.exit(file.remove(tmp))
  write.dcf(private$data, file = tmp)
  try(edit(file = tmp), silent = TRUE)
  private$data <- fetch_description(tmp)
  invisible(self)
}

DESCRIPTION_set <- function(private, Package = NA, Version  = NA, License = NA,
                            Description  = NA, Title = NA, Author = NA,
                            Maintainer = NA, Authors.R  = NA,
                            Depends = NA, Imports = NA, Suggests = NA,
                            Enhances = NA,
                            LinkingTo  = NA, ...) {
  # TODO: find a way to define out of R6, it might work as is if we move it: https://stackoverflow.com/questions/35108541/defining-methods-that-call-other-methods-outside-of-r6-objects
  # TODO: validation!
  # https://cran.r-project.org/doc/manuals/R-exts.html#The-DESCRIPTION-file
  # mandatory ‘Package’, ‘Version’, ‘License’, ‘Description’, ‘Title’, ‘Author’, and ‘Maintainer’
  # Author and mainainer can be generated from ‘Authors@R’
  # Date
  # ‘Depends’, ‘Imports’, ‘Suggests’, ‘Enhances’, ‘LinkingTo’ and ‘Additional_repositories’
  # SystemRequirements URL BugReports Collate ‘Collate.unix’ or ‘Collate.windows’
  # LazyDatas LazyLoad used before now ignored
  # KeepSource ByteCompile UseLTO StagedInstall ZipData Biarch BuildVignettes VignetteBuilder
  # Encoding NeedsCompilation OS_type
  #Type
  #Classification/ACM’ or ‘Classification/ACM-2012 Classification/JEL Classification/MSC Classification/MSC-2010

  args <- list(
    Package = Package, Version = Version, License = License, Description = Description,
    Title = Title, Author = Author, Maintainer = Maintainer, Authors.R = Authors.R,
    Depends = Depends, Imports = Imports, Suggests = Suggests, Enhances = Enhances, LinkingTo = LinkingTo, ...
  )
  args <- Filter(Negate(is.na), args)
  private$data <- do.call(transform, c(list(private$data), args))
  invisible(NULL)
}
