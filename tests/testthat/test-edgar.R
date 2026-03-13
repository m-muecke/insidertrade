test_that("edgar_submissions() validates inputs", {
  expect_error(edgar_submissions(-1))
  expect_error(edgar_submissions("abc"))
  expect_error(edgar_submissions(NULL))
})
