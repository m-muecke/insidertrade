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
#>       code
#>     <char>
#>  1:      A
#>  2:      C
#>  3:      D
#>  4:      E
#>  5:      F
#>  6:      G
#>  7:      H
#>  8:      I
#>  9:      J
#> 10:      K
#> 11:      L
#> 12:      M
#> 13:      O
#> 14:      P
#> 15:      S
#> 16:      U
#> 17:      V
#> 18:      W
#> 19:      X
#> 20:      Z
#>       code
#>     <char>
#>                                                                            description
#>                                                                                 <char>
#>  1:                       Grant, award, or other acquisition pursuant to Rule 16b-3(d)
#>  2:                                                  Conversion of derivative security
#>  3:    Disposition to the issuer of issuer equity securities pursuant to Rule 16b-3(e)
#>  4:                                            Expiration of short derivative position
#>  5:       Expiration (or cancellation) of long derivative position with value received
#>  6: Payment of exercise price or tax liability by delivering or withholding securities
#>  7:                                                                     Bona fide gift
#>  8:                         Discretionary transaction in accordance with Rule 16b-3(f)
#>  9:                                                   Other acquisition or disposition
#> 10:              Transaction in equity swap or instrument with similar characteristics
#> 11:                                                 Small acquisition under Rule 16a-6
#> 12:      Exercise or conversion of derivative security exempted pursuant to Rule 16b-3
#> 13:                                   Exercise of out-of-the-money derivative security
#> 14:                                                    Open market or private purchase
#> 15:                                                        Open market or private sale
#> 16:      Disposition pursuant to a tender of shares in a change of control transaction
#> 17:                             Transaction voluntarily reported earlier than required
#> 18:         Acquisition or disposition by will or the laws of descent and distribution
#> 19:                       Exercise of in-the-money or at-the-money derivative security
#> 20:                                       Deposit into or withdrawal from voting trust
#>                                                                            description
#>                                                                                 <char>
```
