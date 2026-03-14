#' Manage the insidertrade cache
#'
#' `sec_cache_dir()` returns the path where cached data is stored.
#' `sec_cache_clear()` deletes all cached files, including bulk data ZIPs and API responses.
#'
#' @details
#' Bulk data ZIPs from [sec_form345()] are always cached on disk. API responses from
#' [sec_tickers()] and [edgar_submissions()] are only cached when enabled with
#' `options(insidertrade.cache = TRUE)`. Cached API responses are stored for 7 days by default,
#' but this can be customized with `options(insidertrade.cache_max_age = days)`.
#'
#' @name cache
#' @examples
#' # view cache location
#' sec_cache_dir()
#'
#' \dontrun{
#' # enable API caching
#' options(insidertrade.cache = TRUE)
#'
#' # clear all cached data
#' sec_cache_clear()
#' }
NULL

#' @rdname cache
#' @export
sec_cache_dir <- function() {
  tools::R_user_dir("insidertrade", "cache")
}

#' @rdname cache
#' @export
sec_cache_clear <- function() {
  dir <- sec_cache_dir()
  if (dir.exists(dir)) {
    unlink(dir, recursive = TRUE)
  }
  invisible()
}

sec_user_agent <- function() {
  ua <- getOption("insidertrade.user_agent")
  if (is.null(ua)) {
    stop(
      "Set `options(insidertrade.user_agent = 'your@email.com')`. ",
      "The SEC requires a valid User-Agent with contact information.",
      call. = FALSE
    )
  }
  ua
}

sec_perform <- function(url) {
  req <- request(url) |>
    req_user_agent(sec_user_agent())
  if (isTRUE(getOption("insidertrade.cache", FALSE))) {
    req <- req_cache(
      req,
      path = file.path(sec_cache_dir(), "httr2"),
      max_age = getOption("insidertrade.cache_max_age", 7L) * 86400L
    )
  }
  req_perform(req)
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
