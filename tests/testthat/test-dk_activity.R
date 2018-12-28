context("tests for dk_activity")

test_that("I-131 case",  {
  expect_equal(signif(dk_activity(10, 8, 60),
                      7),  0.05524272)
  })

test_that("intentional error check",  {
  expect_equal(signif(dk_activity(10, 8, 60),
                      7),  0.5)
})

