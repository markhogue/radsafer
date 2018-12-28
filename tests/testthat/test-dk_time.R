context("tests for dk_time")

test_that("I-131 case",  {
  expect_equal(signif(dk_time(5770, 200, 1),
                      7),  44105.05)
  })

test_that("intentional error check",  {
  expect_equal(signif(dk_time(5770, 200, 1),
                      7),  1e6)
})

