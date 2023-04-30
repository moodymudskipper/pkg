.onLoad <- function(...) {
  # no need to query CRAN every time, we can restart or execute a refresh_CRAN() helper if we want to have latest info
  # available_packages <<- memoise::memoise(available_packages)
  # fetch_cran_page <<- memoise::memoise(fetch_cran_page)
  # package_db <<- memoise::memoise(package_db)
}
