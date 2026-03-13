# SEC Form 3/4/5 bulk data

Download and parse the quarterly bulk ZIP file from the SEC's insider
transactions data sets.

## Usage

``` r
sec_form345(year, quarter, table = NULL)
```

## Source

<https://www.sec.gov/data-research/sec-markets-data/insider-transactions-data-sets>

## Arguments

- year:

  (`integer(1)`)  
  The year of the filing (e.g. `2024`).

- quarter:

  (`integer(1)`)  
  The fiscal quarter. Must be between 1 and 4.

- table:

  (`NULL` \| [`character()`](https://rdrr.io/r/base/character.html))  
  Table names to return. Valid names are `"deriv_holding"`,
  `"deriv_trans"`, `"footnotes"`, `"nonderiv_holding"`,
  `"nonderiv_trans"`, `"owner_signature"`, `"reportingowner"`, and
  `"submission"`. Default `NULL`. If `NULL`, all tables are returned.

## Value

A named list of
[`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html)s,
one per table in the ZIP file. If `table` has length 1, a single
[`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html)
is returned.

## See also

Other bulk data:
[`sec_transactions()`](https://m-muecke.github.io/insidertrade/reference/sec_transactions.md)

## Examples

``` r
# \donttest{
# Get all tables for Q2 2024
data <- sec_form345(2024, 2)
names(data)
#> [1] "deriv_holding"    "deriv_trans"      "footnotes"        "nonderiv_holding"
#> [5] "nonderiv_trans"   "owner_signature"  "reportingowner"   "submission"      

# Get only the submission table
sub <- sec_form345(2024, 2, "submission")
# }
```
