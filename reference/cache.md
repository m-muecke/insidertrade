# Manage the insidertrade cache

`sec_cache_dir()` returns the path where cached data is stored.
`sec_cache_clear()` deletes all cached files, including bulk data ZIPs
and API responses.

## Usage

``` r
sec_cache_dir()

sec_cache_clear()
```

## Details

Bulk data ZIPs from
[`sec_form345()`](https://m-muecke.github.io/insidertrade/reference/sec_form345.md)
are always cached on disk. API responses from
[`sec_tickers()`](https://m-muecke.github.io/insidertrade/reference/sec_tickers.md)
and
[`edgar_submissions()`](https://m-muecke.github.io/insidertrade/reference/edgar_submissions.md)
are only cached when enabled with `options(insidertrade.cache = TRUE)`.
Cached API responses are stored for 7 days by default, but this can be
customized with `options(insidertrade.cache_max_age = days)`.

## Examples

``` r
# view cache location
sec_cache_dir()
#> [1] "/home/runner/.cache/R/insidertrade"

if (FALSE) { # \dontrun{
# enable API caching
options(insidertrade.cache = TRUE)

# clear all cached data
sec_cache_clear()
} # }
```
