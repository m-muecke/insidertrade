test_that("sec_cache_dir() returns a path", {
  expect_type(sec_cache_dir(), "character")
  expect_length(sec_cache_dir(), 1L)
})

test_that("parse_sec_date() parses SEC date format", {
  expect_equal(parse_sec_date("15-MAR-2024"), as.Date("2024-03-15"))
  expect_equal(parse_sec_date("01-JAN-2020"), as.Date("2020-01-01"))
})
