# SEC company tickers

Fetch the full CIK-to-ticker mapping from the SEC.

## Usage

``` r
sec_tickers()
```

## Source

<https://www.sec.gov/files/company_tickers.json>

## Value

A
[`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html)
with columns `cik`, `ticker`, and `title`.

## See also

Other EDGAR:
[`edgar_form4()`](https://m-muecke.github.io/insidertrade/reference/edgar_form4.md),
[`edgar_insider_filings()`](https://m-muecke.github.io/insidertrade/reference/edgar_insider_filings.md),
[`edgar_submissions()`](https://m-muecke.github.io/insidertrade/reference/edgar_submissions.md)

## Examples

``` r
# \donttest{
tickers <- sec_tickers()
tickers[ticker == "AAPL"]
#>       cik ticker      title
#>     <int> <char>     <char>
#> 1: 320193   AAPL Apple Inc.
# }
```
