# Changelog

## insidertrade (development version)

- [`edgar_insider_filings()`](https://m-muecke.github.io/insidertrade/reference/edgar_insider_filings.md)
  filters EDGAR submissions to Forms 3, 4, and 5.
- [`edgar_submissions()`](https://m-muecke.github.io/insidertrade/reference/edgar_submissions.md)
  fetches company filing metadata from the EDGAR API.
- [`sec_tickers()`](https://m-muecke.github.io/insidertrade/reference/sec_tickers.md)
  fetches the full CIK-to-ticker mapping from the SEC.
- [`sec_cache_clear()`](https://m-muecke.github.io/insidertrade/reference/sec_cache_clear.md)
  deletes cached ZIP files.
- [`sec_cache_dir()`](https://m-muecke.github.io/insidertrade/reference/sec_cache_dir.md)
  returns the cache directory path.
- [`sec_form345()`](https://m-muecke.github.io/insidertrade/reference/sec_form345.md)
  downloads and parses quarterly SEC Form 3/4/5 bulk data.
- [`sec_transaction_codes()`](https://m-muecke.github.io/insidertrade/reference/sec_transaction_codes.md)
  returns a lookup table of SEC transaction codes and descriptions.
- [`sec_transactions()`](https://m-muecke.github.io/insidertrade/reference/sec_transactions.md)
  returns insider transactions joined with submission and owner details.
