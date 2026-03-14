# SEC insider transactions

Download the quarterly Form 3/4/5 data and join the `nonderiv_trans`
table with `submission` and `reportingowner` tables on
`accession_number`.

## Usage

``` r
sec_transactions(year, quarter = 1:4)
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

## Value

A
[`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html)
with transaction data joined with submission and reporting owner
information.

## See also

Other bulk data:
[`sec_form345()`](https://m-muecke.github.io/insidertrade/reference/sec_form345.md),
[`sec_transaction_codes()`](https://m-muecke.github.io/insidertrade/reference/sec_transaction_codes.md)

## Examples

``` r
# \donttest{
trans <- sec_transactions(2024, 2)
# }
```
