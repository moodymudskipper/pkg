
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pkg

Is it trolling to have a {pkg} package on CRAN ?

There’s not much here at the moment, just exploring an idea : could we
have a package object ?

A package is made of several identifiable and structured components such
as DESCRIPTION fields, imports, exports, documentation, build_ignore…

All the information needed to create a package can be stored into a list
of data frames. We could build a R6 object around it.

This would allow us to programatically edit a package, subset, combine,
move functions from a file to another, apply deep checks that are
currently hard to do, export/unexport function, add example, cmd check
or test at the function or script level easily…

We can export a pkg object to a new location or just overwrite it at
it’s current location.

R6 is nice because we can `pkg$test()`, `pkg$build()`,
`pkg$new(README_Rmd = TRUE, ...)`, we can do a lot and we don’t need to
remember anything.

The info it contains would be non redundant, which is not the case at
all in a package folder where : \* README.md depends on README.rmd \*
roxygen tags are redundant with NAMESPACE \* pkgdown website

Integrity would be guaranteed at all steps (or at least easily
testable), which is not the case at the moment.

We could in principle do everything by manipulating the object but
obviously we like to use our gui to write and read code in scripts so we
might have a `pkg$sync_in()` / `pkg$sync_out()` to respectively absorb
changes to the directory or export the directory.

. We’d work in the gui as we do now, and when it’s convenient call
`pkg$something()`

Since a package is linked to its repo and issue tracker we can also do
all the git stuff from the object (commit, push, pull, PR…), display
issues, etc…

Lurkers welcome in the issue tracker for random ideas or discuss mine.
