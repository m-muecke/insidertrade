#' SEC Form 3/4/5 bulk data
#'
#' Download and parse the quarterly bulk ZIP file from the SEC's insider transactions data sets.
#'
#' @param year (`integer(1)`)\cr
#'   The year of the filing (e.g. `2024`).
#' @param quarter (`integer(1)`)\cr
#'   The fiscal quarter. Must be between 1 and 4.
#' @param table (`NULL` | `character()`)\cr
#'   Table names to return. Valid names are `"deriv_holding"`, `"deriv_trans"`,
#'   `"footnotes"`, `"nonderiv_holding"`, `"nonderiv_trans"`, `"owner_signature"`,
#'   `"reportingowner"`, and `"submission"`. Default `NULL`. If `NULL`, all tables are returned.
#'
#' @returns A named list of [data.table::data.table()]s, one per table in the ZIP file. If `table` has
#'   length 1, a single [data.table::data.table()] is returned.
#' @source <https://www.sec.gov/data-research/sec-markets-data/insider-transactions-data-sets>
#' @family bulk data
#' @export
#' @examplesIf httr2::is_online()
#' \donttest{
#' # Get all tables for Q2 2024
#' data <- sec_form345(2024, 2)
#' names(data)
#'
#' # Get only the submission table
#' sub <- sec_form345(2024, 2, "submission")
#' }
sec_form345 <- function(year, quarter, table = NULL) {
  stopifnot(is_count(year), year >= 2003L)
  stopifnot(is_count(quarter), quarter >= 1L, quarter <= 4L)

  valid_tables <- c(
    "deriv_holding",
    "deriv_trans",
    "footnotes",
    "nonderiv_holding",
    "nonderiv_trans",
    "owner_signature",
    "reportingowner",
    "submission"
  )
  if (!is.null(table)) {
    stopifnot(is_character(table), all(table %in% valid_tables))
  }

  zip_name <- sprintf("%dq%d_form345.zip", year, quarter)
  cache_path <- file.path(sec_cache_dir(), zip_name)

  if (!file.exists(cache_path)) {
    url <- sprintf(
      "https://www.sec.gov/files/structureddata/data/insider-transactions-data-sets/%s",
      zip_name
    )
    sec_download(url, cache_path)
  }

  tmpdir <- tempfile("insidertrade_")
  on.exit(unlink(tmpdir, recursive = TRUE), add = TRUE)
  utils::unzip(cache_path, exdir = tmpdir)

  files <- list.files(tmpdir, pattern = "\\.tsv$", full.names = TRUE)
  out <- lapply(files, function(f) {
    tbl_name <- sub("\\.tsv$", "", tolower(basename(f)))
    dt <- fread(f, sep = "\t")
    setnames(dt, tolower)
    parse_form345_table(dt, tbl_name)
  })
  names(out) <- sub("\\.tsv$", "", tolower(basename(files)))

  if (!is.null(table)) {
    out <- out[table]
  }
  if (length(out) == 1L) {
    return(out[[1L]])
  }
  out
}

parse_form345_table <- function(dt, table_name) {
  date_cols <- switch(
    table_name,
    submission = c("filing_date", "period_of_report", "date_of_orig_sub"),
    nonderiv_trans = c("trans_date", "deemed_execution_date"),
    deriv_trans = c(
      "trans_date",
      "deemed_execution_date",
      "excercise_date",
      "expiration_date"
    ),
    deriv_holding = c("exercise_date", "expiration_date"),
    owner_signature = "ownersignaturedate",
    character()
  )
  date_cols <- intersect(date_cols, names(dt))
  if (length(date_cols)) {
    dt[, (date_cols) := lapply(.SD, parse_sec_date), .SDcols = date_cols]
  }
  dt
}

#' SEC insider transactions
#'
#' Download the quarterly Form 3/4/5 data and join the `nonderiv_trans` table with `submission`
#' and `reportingowner` tables on `accession_number`.
#'
#' @inheritParams sec_form345
#'
#' @returns A [data.table::data.table()] with transaction data joined with submission and reporting owner
#'   information.
#' @source <https://www.sec.gov/data-research/sec-markets-data/insider-transactions-data-sets>
#' @family bulk data
#' @export
#' @examplesIf httr2::is_online()
#' \donttest{
#' trans <- sec_transactions(2024, 2)
#' }
sec_transactions <- function(year, quarter) {
  data <- sec_form345(year, quarter, c("nonderiv_trans", "submission", "reportingowner"))
  trans <- data$nonderiv_trans
  sub <- data$submission
  owner <- data$reportingowner

  trans[sub, on = "accession_number"][owner, on = "accession_number"]
}
