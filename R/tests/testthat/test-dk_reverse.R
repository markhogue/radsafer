context("tests for dk_reverse")

test_that("I-131 case",  {
  expect_equal(signif(dk_reverse(80, 8, 1),
                      4),  1024)
  })

test_that("Intentional error test",  {
  expect_equal(signif(dk_reverse(80, 8, 1),
                      4),  1025)
})

