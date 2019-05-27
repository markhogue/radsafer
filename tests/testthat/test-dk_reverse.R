context("tests for dk_reverse")

test_that("I-131 case",  {
  expect_equal(signif(dk_reverse(1, 8, 80),
                      4),  1024)
  })


