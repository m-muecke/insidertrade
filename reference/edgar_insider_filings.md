# EDGAR insider filings

A convenience wrapper around
[`edgar_submissions()`](https://m-muecke.github.io/insidertrade/reference/edgar_submissions.md)
that filters to insider trading forms (Forms 3, 4, and 5).

## Usage

``` r
edgar_insider_filings(cik)
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
with one row per insider filing.

## See also

Other EDGAR:
[`edgar_submissions()`](https://m-muecke.github.io/insidertrade/reference/edgar_submissions.md),
[`sec_tickers()`](https://m-muecke.github.io/insidertrade/reference/sec_tickers.md)

## Examples

``` r
# \donttest{
# Apple Inc. insider filings
insider <- edgar_insider_filings(320193)
# }
```
