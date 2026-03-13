# EDGAR company submissions

Fetch the submissions (filing history) for a given CIK number from the
SEC EDGAR API.

## Usage

``` r
edgar_submissions(cik)
```

## Source

<https://www.sec.gov/search-filings/edgar-application-programming-interfaces>

## Arguments

- cik:

  (`integer(1)` \| `character(1)`)  
  The SEC Central Index Key for the entity.

## Value

A
[`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html)
with one row per filing, containing columns such as `accession_number`,
`filing_date`, `form`, `primary_document`, and others.

## See also

Other EDGAR:
[`edgar_insider_filings()`](https://m-muecke.github.io/insidertrade/reference/edgar_insider_filings.md)

## Examples

``` r
# \donttest{
# Apple Inc.
filings <- edgar_submissions(320193)
# }
```
