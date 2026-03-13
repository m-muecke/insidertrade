test_that("sec_form345() validates inputs", {
  expect_error(sec_form345("abc", 1))
  expect_error(sec_form345(2024, 5))
  expect_error(sec_form345(2024, 0))
  expect_error(sec_form345(2024, 1, table = "invalid"))
})
