#' @export
Repo <- R6::R6Class(
  "pkg_Repo",
  public = list(
    initialize = function(path) repo_initialize(self, private, path),
    print = function() repo_print(self$path),
    .private = NULL,
    path = NULL,
    tag = NULL,
    branch = NULL,
    log = NULL
  ),
  private = list(
    data = NULL,
    # branch -------------------------------------------------------------------
    repo_branch = function()
      gert::git_branch(repo = self$path),
    repo_branch_list = function(local = NULL)
      gert::git_branch_list(local, repo = self$path),
    repo_branch_checkout = function(branch, force = FALSE, orphan = FALSE)
      gert::git_branch_checkout(branch, force, orphan, repo = self$path),
    # tag ----------------------------------------------------------------------
    repo_tag_list = function(match = "*")
      gert::git_tag_list(match, self$path),
    repo_tag_create = function(name, message, ref = "HEAD")
      gert::git_tag_create(name, message, ref, repo = self$path),
    repo_tag_delete = function(name)
      gert::git_tag_delete(name, repo = self$path),
    repo_tag_push = function(name)
      gert::git_tag_push(name, repo = self$path),
    repo_tag_checkout = function(tag)
      repo_tag_checkout(self, tag),
    repo_tag_as_pkg = function(tag)
      repo_tag_as_pkg(self, tag)
  )
)

repo_initialize <- function(self, private, path) {
  if (is.null(path)) {
    path <- tempfile()
    gert::git_init(path)
  }
  if (startsWith(path, "http")) {
    url <- path
    path <- tempfile()
    cmd <- sprintf("git clone %s.git %s", url, path)
    system(cmd)
  } else {
    git_path <- file.path(path, ".git")
    if (!dir.exists(git_path)) stop("No `.git` folder found")
  }
  tmp <- tempfile(fileext = ".zip")
  on.exit(file.remove(tmp))
  zip(tmp, path, flags="-q")

  self$path <- path
  private$data <- structure(
    class = "pkg_git",
    info = gert::git_info(path),
    readBin(tmp, "raw", file.info(tmp)$size)
  )
  self$tag <- list(
    list = private$repo_tag_list,
    create = private$repo_tag_create,
    delete = private$repo_tag_delete,
    push = private$repo_tag_push,
    checkout = private$repo_tag_checkout,
    as_pkg = private$repo_tag_as_pkg
  )
  self$branch <- list(
    branch = private$repo_branch,
    list = private$repo_branch_list,
    checkout = private$repo_branch_checkout
  )
  self$.private <- private
}

repo_print <- function(path) {
  info <- gert::git_info(path)[c("remote", "upstream", "commit")]
  desc_path <- file.path(path, "DESCRIPTION")
  if (file.exists(desc_path)) {
    header <- read.dcf(desc_path)[,c("Package", "Version")]
  } else {
    header <- c(Package = "???", Version = "???")
  }
  vec <- c(header, info)
  writeLines(c(cli::col_grey("<pkg_Repo>"), sprintf("%s: %s", cli::col_blue(names(vec)), vec)))
  # TODO: use gert::git_info() to fetch path, remote, upstream, commit
  # fetch name and version from DESCRIPTION if there is one
}

repo_tag_checkout <- function(self, tag) {
  tags <- self$tag$list()
  commit <- tags$commit[tags$name == tag]
  cmd <- sprintf("git --git-dir=%s/.git --work-tree=%s checkout %s", self$path, self$path, commit)
  out <- system(cmd, intern = TRUE, ignore.stdout = TRUE, ignore.stderr = TRUE)
}

repo_tag_as_pkg <- function(self, tag) {
  tags <- self$tag$list()
  commit <- tags$commit[tags$name == tag]
  cmd <- sprintf("git --git-dir=%s/.git --work-tree=%s checkout %s", self$path, self$path, commit)
  out <- system(cmd, intern = TRUE, ignore.stdout = TRUE, ignore.stderr = TRUE)
  Package$new(self$path)
}


