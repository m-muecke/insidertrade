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

  body <- resp_body_json(sec_perform(url))
  recent <- body$filings$recent
  dt <- setDT(lapply(recent, unlist))
  setnames(dt, tolower)

  setnames(dt, c("filingdate", "acceptancedatetime"), c("filing_date", "acceptance_datetime"))
  dt[, let(
    filing_date = as.Date(filing_date),
    acceptance_datetime = as.POSIXct(acceptance_datetime, format = "%Y-%m-%dT%H:%M:%S")
  )]
  dt
}

#' Parse a Form 4 filing
#'
#' Fetch and parse the XML for a single SEC Form 4 filing from EDGAR, returning the
#' non-derivative transactions as a [data.table::data.table()].
#'
#' @param cik (`integer(1)` | `character(1)`)\cr
#'   The SEC Central Index Key for the filing entity.
#' @param accession_number (`character(1)`)\cr
#'   The accession number of the filing (e.g. `"0001234567-24-012345"`).
#' @param primary_document (`character(1)`)\cr
#'   The primary document filename from the filing (e.g. `"xslF345X05/wf-form4.xml"`).
#'
#' @returns A [data.table::data.table()] with one row per non-derivative transaction, containing
#'   columns:
#'   \describe{
#'     \item{`issuer_cik`}{CIK of the issuing company.}
#'     \item{`issuer_name`}{Name of the issuing company.}
#'     \item{`issuer_ticker`}{Trading symbol of the issuing company.}
#'     \item{`owner_cik`}{CIK of the reporting owner.}
#'     \item{`owner_name`}{Name of the reporting owner.}
#'     \item{`is_director`}{Whether the owner is a director.}
#'     \item{`is_officer`}{Whether the owner is an officer.}
#'     \item{`is_ten_percent_owner`}{Whether the owner is a 10% owner.}
#'     \item{`is_other`}{Whether the owner has another relationship.}
#'     \item{`officer_title`}{Title of the officer, if applicable.}
#'     \item{`security_title`}{Title of the security transacted.}
#'     \item{`transaction_date`}{Date of the transaction.}
#'     \item{`transaction_code`}{Transaction code (e.g. `"P"` for purchase, `"S"` for sale).}
#'     \item{`shares`}{Number of shares transacted.}
#'     \item{`price_per_share`}{Price per share.}
#'     \item{`acquired_disposed`}{`"A"` for acquired, `"D"` for disposed.}
#'     \item{`shares_owned_following`}{Shares owned after the transaction.}
#'     \item{`direct_or_indirect`}{`"D"` for direct, `"I"` for indirect ownership.}
#'   }
#' @source <https://www.sec.gov/search-filings/edgar-application-programming-interfaces>
#' @family EDGAR
#' @export
#' @examplesIf httr2::is_online()
#' \donttest{
#' # first get insider filings for Apple Inc.
#' filings <- edgar_insider_filings(320193)
#' form4s <- filings[form == "4"]
#'
#' # then parse a single Form 4 filing
#' txn <- edgar_form4(
#'   cik = 320193,
#'   accession_number = form4s$accessionnumber[1L],
#'   primary_document = form4s$primarydocument[1L]
#' )
#' }
edgar_form4 <- function(cik, accession_number, primary_document) {
  stopifnot(is_count(cik) || is_string(cik, pattern = "^[0-9]+$"))
  stopifnot(is_string(accession_number))
  stopifnot(is_string(primary_document))

  cik_padded <- sprintf("%010d", as.integer(cik))
  accession_flat <- gsub("-", "", accession_number, fixed = TRUE)
  # strip XSLT prefix (e.g. "xslF345X05/") to get the raw XML filename
  xml_file <- basename(primary_document)
  url <- sprintf(
    "https://www.sec.gov/Archives/edgar/data/%s/%s/%s",
    cik_padded,
    accession_flat,
    xml_file
  )

  sec_perform(url) |>
    resp_body_xml() |>
    parse_form4_xml()
}

parse_form4_xml <- function(doc) {
  ns <- xml2::xml_ns(doc)

  xml_val <- function(node, xpath) {
    found <- xml_find_first(node, xpath, ns)
    if (is.na(found)) NA_character_ else xml_text(found)
  }

  # issuer
  issuer_cik <- xml_val(doc, ".//issuer/issuerCik")
  issuer_name <- xml_val(doc, ".//issuer/issuerName")
  issuer_ticker <- xml_val(doc, ".//issuer/issuerTradingSymbol")

  # reporting owners
  owners <- xml_find_all(doc, ".//reportingOwner", ns)
  owner_rows <- lapply(owners, function(owner) {
    data.table(
      owner_cik = xml_val(owner, ".//reportingOwnerId/rptOwnerCik"),
      owner_name = xml_val(owner, ".//reportingOwnerId/rptOwnerName"),
      is_director = xml_val(owner, ".//reportingOwnerRelationship/isDirector") == "1",
      is_officer = xml_val(owner, ".//reportingOwnerRelationship/isOfficer") == "1",
      is_ten_percent_owner = xml_val(
        owner,
        ".//reportingOwnerRelationship/isTenPercentOwner"
      ) ==
        "1",
      is_other = xml_val(owner, ".//reportingOwnerRelationship/isOther") == "1",
      officer_title = xml_val(owner, ".//reportingOwnerRelationship/officerTitle")
    )
  })
  owner_dt <- rbindlist(owner_rows)

  # non-derivative transactions

  txns <- xml_find_all(doc, ".//nonDerivativeTable/nonDerivativeTransaction", ns)
  if (length(txns) == 0L) {
    return(data.table(
      issuer_cik = character(),
      issuer_name = character(),
      issuer_ticker = character(),
      owner_cik = character(),
      owner_name = character(),
      is_director = logical(),
      is_officer = logical(),
      is_ten_percent_owner = logical(),
      is_other = logical(),
      officer_title = character(),
      security_title = character(),
      transaction_date = as.Date(character()),
      transaction_code = character(),
      shares = numeric(),
      price_per_share = numeric(),
      acquired_disposed = character(),
      shares_owned_following = numeric(),
      direct_or_indirect = character()
    ))
  }

  txn_rows <- lapply(txns, function(txn) {
    data.table(
      security_title = xml_val(txn, ".//securityTitle/value"),
      transaction_date = as.Date(xml_val(txn, ".//transactionDate/value")),
      transaction_code = xml_val(txn, ".//transactionCoding/transactionCode"),
      shares = as.numeric(xml_val(txn, ".//transactionAmounts/transactionShares/value")),
      price_per_share = as.numeric(
        xml_val(txn, ".//transactionAmounts/transactionPricePerShare/value")
      ),
      acquired_disposed = xml_val(
        txn,
        ".//transactionAmounts/transactionAcquiredDisposedCode/value"
      ),
      shares_owned_following = as.numeric(
        xml_val(txn, ".//postTransactionAmounts/sharesOwnedFollowingTransaction/value")
      ),
      direct_or_indirect = xml_val(
        txn,
        ".//ownershipNature/directOrIndirectOwnership/value"
      )
    )
  })
  txn_dt <- rbindlist(txn_rows)

  # cross join owners x transactions, prepend issuer info
  dt <- CJ(owner_idx = seq_len(nrow(owner_dt)), txn_idx = seq_len(nrow(txn_dt)))
  dt <- cbind(owner_dt[dt$owner_idx], txn_dt[dt$txn_idx])
  dt[, let(issuer_cik = issuer_cik, issuer_name = issuer_name, issuer_ticker = issuer_ticker)]
  setcolorder(dt, c("issuer_cik", "issuer_name", "issuer_ticker"))
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
  dt[form %in% c("3", "4", "5")]
}

#' SEC company tickers
#'
#' Fetch the full CIK-to-ticker mapping from the SEC.
#'
#' @returns A [data.table::data.table()] with columns `cik`, `ticker`, and `title`.
#' @source <https://www.sec.gov/files/company_tickers.json>
#' @family EDGAR
#' @export
#' @examplesIf httr2::is_online()
#' \donttest{
#' tickers <- sec_tickers()
#' tickers[ticker == "AAPL"]
#' }
sec_tickers <- function() {
  sec_perform("https://www.sec.gov/files/company_tickers.json") |>
    resp_body_json() |>
    rbindlist() |>
    setnames("cik_str", "cik")
}
