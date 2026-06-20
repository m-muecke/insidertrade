test_that("sec_cache_dir() returns a path", {
  expect_type(sec_cache_dir(), "character")
  expect_length(sec_cache_dir(), 1L)
})
