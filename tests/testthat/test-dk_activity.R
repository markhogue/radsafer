context("tests for dk_activity")

test_that("I-131 case",  {
  expect_equal(signif(dk_activity(10000, 5, 2500),
                      7),  10)
  })


