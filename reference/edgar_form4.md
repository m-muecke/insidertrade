# Parse a Form 4 filing

Fetch and parse the XML for a single SEC Form 4 filing from EDGAR,
returning the non-derivative transactions as a
[`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html).

## Usage

``` r
edgar_form4(cik, accession_number, primary_document)
```

## Source

<https://www.sec.gov/search-filings/edgar-application-programming-interfaces>

## Arguments

- cik:

  (`integer(1)` \| `character(1)`)  
  The SEC Central Index Key for the filing entity.

- accession_number:

  (`character(1)`)  
  The accession number of the filing (e.g. `"0001234567-24-012345"`).

- primary_document:

  (`character(1)`)  
  The primary document filename from the filing (e.g.
  `"xslF345X05/wf-form4.xml"`).

## Value

A
[`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html)
with one row per non-derivative transaction, containing columns:

- `issuer_cik`:

  CIK of the issuing company.

- `issuer_name`:

  Name of the issuing company.

- `issuer_ticker`:

  Trading symbol of the issuing company.

- `owner_cik`:

  CIK of the reporting owner.

- `owner_name`:

  Name of the reporting owner.

- `is_director`:

  Whether the owner is a director.

- `is_officer`:

  Whether the owner is an officer.

- `is_ten_percent_owner`:

  Whether the owner is a 10% owner.

- `is_other`:

  Whether the owner has another relationship.

- `officer_title`:

  Title of the officer, if applicable.

- `security_title`:

  Title of the security transacted.

- `transaction_date`:

  Date of the transaction.

- `transaction_code`:

  Transaction code (e.g. `"P"` for purchase, `"S"` for sale).

- `shares`:

  Number of shares transacted.

- `price_per_share`:

  Price per share.

- `acquired_disposed`:

  `"A"` for acquired, `"D"` for disposed.

- `shares_owned_following`:

  Shares owned after the transaction.

- `direct_or_indirect`:

  `"D"` for direct, `"I"` for indirect ownership.

## See also

Other EDGAR:
[`edgar_insider_filings()`](https://m-muecke.github.io/insidertrade/reference/edgar_insider_filings.md),
[`edgar_submissions()`](https://m-muecke.github.io/insidertrade/reference/edgar_submissions.md),
[`sec_tickers()`](https://m-muecke.github.io/insidertrade/reference/sec_tickers.md)

## Examples

``` r
# \donttest{
# first get insider filings for Apple Inc.
filings <- edgar_insider_filings(320193)
form4s <- filings[form == "4"]

# then parse a single Form 4 filing
txn <- edgar_form4(
  cik = 320193,
  accession_number = form4s$accessionnumber[1L],
  primary_document = form4s$primarydocument[1L]
)
# }
```
