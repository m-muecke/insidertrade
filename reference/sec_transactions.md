# SEC insider transactions

Download the quarterly Form 3/4/5 data and join the `nonderiv_trans`
table with `submission` and `reportingowner` tables on
`accession_number`.

## Usage

``` r
sec_transactions(year, quarter)
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
