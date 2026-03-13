
<!-- README.md is generated from README.Rmd. Please edit that file -->

# insidertrade

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

## Overview

insidertrade provides access to SEC insider trading data (Forms 3/4/5)
from two sources:

- [Insider transactions bulk data
  sets](https://www.sec.gov/data-research/sec-markets-data/insider-transactions-data-sets)
  (quarterly TSV downloads)
- [EDGAR submissions
  API](https://www.sec.gov/search-filings/edgar-application-programming-interfaces)
  (company filing metadata)

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("m-muecke/insidertrade")
```

## Usage

``` r
library(data.table)
library(insidertrade)

# download and parse all Form 3/4/5 tables for Q2 2024
data <- sec_form345(2024, 2)
str(lapply(data, dim))
#> List of 8
#>  $ deriv_holding   : int [1:2] 9416 26
#>  $ deriv_trans     : int [1:2] 28048 42
#>  $ footnotes       : int [1:2] 116519 3
#>  $ nonderiv_holding: int [1:2] 21166 14
#>  $ nonderiv_trans  : int [1:2] 69412 28
#>  $ owner_signature : int [1:2] 56261 3
#>  $ reportingowner  : int [1:2] 56838 13
#>  $ submission      : int [1:2] 52802 14

# get transactions joined with submission and owner details
trans <- sec_transactions(2024, 2)

# filter to open-market purchases by officers and directors
buys <- trans[
  trans_code == "P" &
    grepl("Officer|Director", rptowner_relationship) &
    trans_date >= "2024-04-01" &
    trans_date <= "2024-06-30"
]

# top 10 companies by number of distinct insider buyers
top <- buys[, .(
  n_insiders = uniqueN(rptownercik),
  total_shares = sum(trans_shares, na.rm = TRUE)
), by = .(ticker = issuertradingsymbol, company = issuername)][order(-n_insiders, -total_shares)]
head(top, 10)
#>     ticker                       company n_insiders total_shares
#>     <char>                        <char>      <int>        <num>
#>  1:    ULS             UL Solutions Inc.         22    590669.00
#>  2:   UUUU              ENERGY FUELS INC         15     74135.00
#>  3:    SPG SIMON PROPERTY GROUP INC /DE/         11      2198.00
#>  4:   BCRX  BIOCRYST PHARMACEUTICALS INC         10    183601.00
#>  5:    LAB        STANDARD BIOTOOLS INC.          9  18468648.00
#>  6:    CRM              Salesforce, Inc.          9   3426051.00
#>  7:   None      Kayne Anderson BDC, Inc.          9    522124.55
#>  8:   GNLX                  GENELUX Corp          9    268000.00
#>  9:   NFBK      Northfield Bancorp, Inc.          9     75851.00
#> 10:   GHLD             Guild Holdings Co          9     19903.79

# plot insider purchases over the quarter
library(ggplot2)

daily <- buys[, .(n_purchases = .N, total_shares = sum(trans_shares, na.rm = TRUE)),
  by = trans_date
]

ggplot(daily, aes(x = trans_date, y = n_purchases)) +
  geom_col() +
  scale_x_date(date_labels = "%b %d") +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold"),
    panel.grid.major.y = element_line(color = "black", linewidth = 0.2),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text = element_text(color = "black"),
    axis.title = element_blank()
  ) +
  labs(title = "Daily Insider Purchases (Q2 2024)")
```

<img src="man/figures/README-demo-1.png" alt="" width="100%" />

## Related work

- [insiderTrades](https://github.com/US-Department-of-the-Treasury/insiderTrades)
- [finreportr](https://github.com/sewardlee337/finreportr)
- [edgarWebR](https://github.com/mwaldstein/edgarWebR)
- [finstr](https://github.com/bergant/finstr)
- [tidyedgar](https://cran.r-project.org/package=tidyedgar)
- [XBRL](https://cran.r-project.org/package=XBRL)
