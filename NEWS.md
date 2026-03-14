# insidertrade (development version)

* `edgar_form4()` fetches and parses a Form 4 XML filing from EDGAR, returning non-derivative transactions as a data.table.
* `edgar_insider_filings()` filters EDGAR submissions to Forms 3, 4, and 5.
* `edgar_submissions()` fetches company filing metadata from the EDGAR API.
* `sec_tickers()` fetches the full CIK-to-ticker mapping from the SEC.
* `sec_cache_clear()` deletes cached ZIP files.
* `sec_cache_dir()` returns the cache directory path.
* `sec_form345()` downloads and parses quarterly SEC Form 3/4/5 bulk data.
* `sec_transaction_codes()` returns a lookup table of SEC transaction codes and descriptions.
* `sec_transactions()` returns insider transactions joined with submission and owner details.
