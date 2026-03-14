#' @section Options:
#' The following options configure package behavior:
#'
#' - `insidertrade.user_agent`: **Required.** A string with your contact information
#'   (e.g. `"your@email.com"`). The SEC requires a valid User-Agent for all API requests.
#' - `insidertrade.cache`: If `TRUE`, cache API responses to disk. Default `FALSE`.
#' - `insidertrade.cache_max_age`: Number of days to keep cached API responses. Default `7`.
#'
#' @keywords internal
"_PACKAGE"

#' @import data.table
#' @importFrom httr2 req_cache request req_perform req_user_agent resp_body_json resp_body_xml
#' @importFrom xml2 xml_find_all xml_find_first xml_text
NULL
