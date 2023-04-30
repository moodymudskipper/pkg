
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pkg

pkgs and repos as R6 objects

## examples

``` r
library(pkg)

# create a new package, by default a temp dir is associated to it
# with `p <- Package$new(".")` you'll be working in your working directory and it
# would fetch the package info from there
p <- Package$new()

# A print method summarizes the object
p
#> <pkg_Package> /var/folders/mp/qvg2y_jx63bgk_s0xxh2zr140000gp/T//RtmpwC6veI/pkg1bb6445c9b57
#> Package: pkg1bb6445c9b57
#> Title: What the Package Does (One Line, Title Case)
#> Version: 0.0.0.9000

# we can edit the description
p$DESCRIPTION$set(Package = "math", Title = "Basic math")
p
#> <pkg_Package> /var/folders/mp/qvg2y_jx63bgk_s0xxh2zr140000gp/T//RtmpwC6veI/pkg1bb6445c9b57
#> Package: math
#> Title: Basic math
#> Version: 0.0.0.9000

# We can add functions using this idiom and create a function in its own script
# no `p$add` element is actually created! instead `p$R$add.R` is created and populated
p$add <- function(x, y) {x + y}
p$R$add.R
#> <pkg_Script> add.R
#> add <- function(x, y) {
#>   x + y
#> }

# This script might be edited interactively
# p$R$add.R$edit()

# we can add to the script with this idiom
# here again `p$R$add.R$subtract` is not created, but `p$R$add.R` is updated
p$R$add.R$subtract <- function(x, y) {x - y}
p$R$add.R$foo <- letters # we're not limited to functions
p$R$add.R
#> <pkg_Script> add.R
#> add <- function(x, y) {
#>   x + y
#> }
#> 
#> subtract <- function(x, y) {
#>   x - y
#> }
#> 
#> foo <- c(
#>   "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l",
#>   "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y",
#>   "z"
#> )

# if the script doesn't already exist it's created
p$R$other.R$multiply <- function(x, y) {x * y}
p$R$other.R
#> <pkg_Script> other.R
#> multiply <- function(x, y) {
#>   x * y
#> }

# I can load the package already and use it as I would with devtools::load_all()
p$load()
#> ℹ Loading math
add(1, 2)
#> [1] 3

# the associated folder is not always in sync but now it is since we needed to dump to load
list.files(p$path, recursive = T)
#> [1] "DESCRIPTION" "NAMESPACE"   "R/add.R"     "R/other.R"

# We can dump manually as well
p$dump()

# we also have repo objects, with methods that are essentially wrappers around {gert}
glue_repo <- Repo$new("https://github.com/tidyverse/glue")
glue_repo
#> <pkg_Repo>
#> Package: glue
#> Version: 1.6.2.9000
#> remote: origin
#> upstream: origin/main
#> commit: cbac82a2aa76298a6df59e78ecf636a989c6b1c9

glue_repo$tag$list() |> head(3)
#>                           name                                    ref
#> 1 pkgdown-update-released-site refs/tags/pkgdown-update-released-site
#> 2                       v1.1.0                       refs/tags/v1.1.0
#> 3                       v1.1.1                       refs/tags/v1.1.1
#>                                     commit
#> 1 2997a17ffcadf003ca5078e9ac0be97d98ee79e3
#> 2 2983e0a1c5d1f9e656b874004456c4bfe9cf1a25
#> 3 88b8bfb33a9adc0605239d8fafd67ec4908267c0

# we can pick a version and convert it to a package object
glue_1.1.0 <- glue_repo$tag$as_pkg("v1.1.0")

glue_1.1.0
#> <pkg_Package> /var/folders/mp/qvg2y_jx63bgk_s0xxh2zr140000gp/T//RtmpwC6veI/file1bb66624d329
#> Package: glue
#> Title: Interpreted String Literals
#> Version: 1.1.0

# we can load it and use it as if it was installed
glue_1.1.0$load(export_all = FALSE, quiet = TRUE)
glue("{letters[1:3]}!")
#> a!
#> b!
#> c!

# both packages are there
search()
#>  [1] ".GlobalEnv"        "package:glue"      "package:testthat" 
#>  [4] "devtools_shims"    "package:math"      "package:pkg"      
#>  [7] "package:stats"     "package:graphics"  "package:grDevices"
#> [10] "package:utils"     "package:datasets"  "package:methods"  
#> [13] "Autoloads"         "package:base"
```
