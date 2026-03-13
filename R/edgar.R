#' EDGAR company submissions
#'
#' Fetch the submissions (filing history) for a given CIK number from the SEC EDGAR API.
#'
#' @param cik (`integer(1)` | `character(1)`)\cr
#'   The SEC Central Index Key for the entity.
#'
#' @returns A [data.table::data.table()] with one row per filing, containing columns such as
#'   `accession_number`, `filing_date`, `form`, `primary_document`, and others.
#' @source <https://www.sec.gov/search-filings/edgar-application-programming-interfaces>
#' @family EDGAR
#' @export
#' @examplesIf httr2::is_online()
#' \donttest{
#' # Apple Inc.
#' filings <- edgar_submissions(320193)
#' }
edgar_submissions <- function(cik) {
  stopifnot(is_count(cik) || is_string(cik, pattern = "^[0-9]+$"))
  cik <- sprintf("CIK%010d", as.integer(cik))
  url <- sprintf("https://data.sec.gov/submissions/%s.json", cik)

  body <- request(url) |>
    req_user_agent(sec_user_agent()) |>
    req_perform() |>
    resp_body_json()
  recent <- body$filings$recent
  dt <- setDT(lapply(recent, unlist))
  setnames(dt, tolower)

  if ("filingdate" %in% names(dt)) {
    setnames(dt, "filingdate", "filing_date")
    dt[, filing_date := as.Date(filing_date)]
  }
  if ("acceptancedatetime" %in% names(dt)) {
    setnames(dt, "acceptancedatetime", "acceptance_datetime")
    dt[, acceptance_datetime := as.POSIXct(acceptance_datetime, format = "%Y-%m-%dT%H:%M:%S")]
  }
  dt
}

#' EDGAR insider filings
#'
#' A convenience wrapper around [edgar_submissions()] that filters to insider trading forms
#' (Forms 3, 4, and 5).
#'
#' @inheritParams edgar_submissions
#'
#' @returns A [data.table::data.table()] with one row per insider filing.
#' @source <https://www.sec.gov/search-filings/edgar-application-programming-interfaces>
#' @family EDGAR
#' @export
#' @examplesIf httr2::is_online()
#' \donttest{
#' # Apple Inc. insider filings
#' insider <- edgar_insider_filings(320193)
#' }
edgar_insider_filings <- function(cik) {
  dt <- edgar_submissions(cik)
  dt[dt$form %in% c("3", "4", "5"), ]
}
