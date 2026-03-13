is_integerish <- function(x, null_ok = FALSE) {
  if (null_ok && is.null(x)) {
    return(TRUE)
  }
  is.numeric(x) && length(x) > 0L && !anyNA(x) && all(as.integer(x) == x)
}

is_count <- function(x, null_ok = FALSE) {
  if (null_ok && is.null(x)) {
    return(TRUE)
  }
  is.numeric(x) && length(x) == 1L && !is.na(x) && as.integer(x) == x && x > 0L
}

is_string <- function(x, ..., pattern = NULL, null_ok = FALSE) {
  if (null_ok && is.null(x)) {
    return(TRUE)
  }
  ok <- is.character(x) && length(x) == 1L && !is.na(x)
  if (ok && !is.null(pattern)) {
    ok <- grepl(pattern, x, ...)
  }
  ok
}

is_character <- function(x, null_ok = FALSE) {
  if (null_ok && is.null(x)) {
    return(TRUE)
  }
  is.character(x) && !anyNA(x) && length(x) > 0L
}
