# SEC Form 3/4/5 bulk data

Download and parse the quarterly bulk ZIP files from the SEC's insider
transactions data sets.

## Usage

``` r
sec_form345(year, quarter = 1:4, table = NULL)
```

## Source

<https://www.sec.gov/data-research/sec-markets-data/insider-transactions-data-sets>

## Arguments

- year:

  ([`integer()`](https://rdrr.io/r/base/integer.html))  
  The year(s) of the filing (e.g. `2024` or `2023:2024`).

- quarter:

  ([`integer()`](https://rdrr.io/r/base/integer.html))  
  The fiscal quarter(s). Must be between 1 and 4. Default `1:4`.

- table:

  (`NULL` \| [`character()`](https://rdrr.io/r/base/character.html))  
  Table names to return. Valid names are `"deriv_holding"`,
  `"deriv_trans"`, `"footnotes"`, `"nonderiv_holding"`,
  `"nonderiv_trans"`, `"owner_signature"`, `"reportingowner"`, and
  `"submission"`. Default `NULL`. If `NULL`, all tables are returned.

## Value

A named list of
[`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html)s,
one per table. If multiple year/quarter combinations are requested, the
tables are row-bound across quarters. If `table` has length 1, a single
[`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html)
is returned.

## See also

Other bulk data:
[`sec_transaction_codes()`](https://m-muecke.github.io/insidertrade/reference/sec_transaction_codes.md),
[`sec_transactions()`](https://m-muecke.github.io/insidertrade/reference/sec_transactions.md)

## Examples

``` r
# \donttest{
# Get all tables for Q2 2024
data <- sec_form345(2024, 2)
#> Error in sec_user_agent(): could not find function "sec_user_agent"
names(data)
#> NULL

# Get only the submission table
sub <- sec_form345(2024, 2, "submission")
#> Error in sec_user_agent(): could not find function "sec_user_agent"

# Get a full year of transactions
trans <- sec_form345(2024, table = "nonderiv_trans")
#> Error in sec_user_agent(): could not find function "sec_user_agent"
# }
```
