#' Get the cache directory
#'
#' Returns the path to the directory where downloaded SEC data files are cached.
#'
#' @returns A `character()` string with the path to the cache directory.
#' @family cache
#' @export
sec_cache_dir <- function() {
  tools::R_user_dir("insidertrade", "cache")
}

#' Clear the cache
#'
#' Deletes all cached ZIP files downloaded by [sec_form345()].
#'
#' @returns `NULL` invisibly.
#' @family cache
#' @export
sec_cache_clear <- function() {
  dir <- sec_cache_dir()
  if (dir.exists(dir)) {
    unlink(dir, recursive = TRUE)
  }
  invisible()
}

sec_user_agent <- function() {
  getOption("insidertrade.user_agent") %||% "insidertrade muecke.maximilian@gmail.com"
}

sec_download <- function(url, destfile) {
  dir.create(dirname(destfile), showWarnings = FALSE, recursive = TRUE)
  h <- curl::new_handle()
  curl::handle_setheaders(h, `User-Agent` = sec_user_agent())
  curl::curl_download(url, destfile, handle = h)
  destfile
}

parse_sec_date <- function(x) {
  as.Date(x, "%d-%B-%Y")
}

`%||%` <- function(x, y) {
  if (is.null(x)) y else x # nolint
}
