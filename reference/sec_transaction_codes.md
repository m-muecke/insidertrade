# SEC transaction codes

Returns a lookup table mapping SEC transaction codes to human-readable
descriptions.

## Usage

``` r
sec_transaction_codes()
```

## Source

<https://www.sec.gov/edgar/searchedgar/ownershipformcodes.html>

## Value

A
[`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html)
with columns `code` and `description`.

## See also

Other bulk data:
[`sec_form345()`](https://m-muecke.github.io/insidertrade/reference/sec_form345.md),
[`sec_transactions()`](https://m-muecke.github.io/insidertrade/reference/sec_transactions.md)

## Examples

``` r
sec_transaction_codes()
#> Error in rowwiseDT(code, description, "A", "Grant, award, or other acquisition pursuant to Rule 16b-3(d)",     "C", "Conversion of derivative security", "D", "Disposition to the issuer of issuer equity securities pursuant to Rule 16b-3(e)",     "E", "Expiration of short derivative position", "F", "Expiration (or cancellation) of long derivative position with value received",     "G", "Payment of exercise price or tax liability by delivering or withholding securities",     "H", "Bona fide gift", "I", "Discretionary transaction in accordance with Rule 16b-3(f)",     "J", "Other acquisition or disposition", "K", "Transaction in equity swap or instrument with similar characteristics",     "L", "Small acquisition under Rule 16a-6", "M", "Exercise or conversion of derivative security exempted pursuant to Rule 16b-3",     "O", "Exercise of out-of-the-money derivative security",     "P", "Open market or private purchase", "S", "Open market or private sale",     "U", "Disposition pursuant to a tender of shares in a change of control transaction",     "V", "Transaction voluntarily reported earlier than required",     "W", "Acquisition or disposition by will or the laws of descent and distribution",     "X", "Exercise of in-the-money or at-the-money derivative security",     "Z", "Deposit into or withdrawal from voting trust"): Must provide at least one column (use `name=`). See ?rowwiseDT for details
```
