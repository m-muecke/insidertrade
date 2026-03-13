# insidertrade: SEC Insider Trading Transactions

Download and parse SEC insider trading data (Forms 3/4/5) from quarterly
bulk data sets and the EDGAR submissions API.

## Options

The following options configure package behavior:

- `insidertrade.user_agent`: **Required.** A string with your contact
  information (e.g. `"your@email.com"`). The SEC requires a valid
  User-Agent for all API requests.

- `insidertrade.cache`: If `TRUE`, cache API responses to disk. Default
  `FALSE`.

- `insidertrade.cache_max_age`: Number of days to keep cached API
  responses. Default `7`.

## See also

Useful links:

- <https://m-muecke.github.io/insidertrade/>

- <https://github.com/m-muecke/insidertrade>

- Report bugs at <https://github.com/m-muecke/insidertrade/issues>

## Author

**Maintainer**: Maximilian Muecke <muecke.maximilian@gmail.com>
([ORCID](https://orcid.org/0009-0000-9432-9795))
