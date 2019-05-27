context("tests for dk_cf")

test_that("year check",  {
  expect_equal(signif(dk_cf(5.27, "y", "2010-12-01", "2018-12-01"),
                      7),  0.3491632)
  })
test_that("day check",  {
  expect_equal(signif(dk_cf(165, "d", "2018-10-01", "2018-12-01"),
               7),  0.7738096)
})
test_that("hour check",  {
  expect_equal(signif(dk_cf(0.5, "h", "2018-10-01-08:15", "2018-10-01-09:15"),
             2),  0.25)
})
test_that("minute check",  {
  expect_equal(signif(dk_cf(24, "m", "2018-10-01-08:15", "2018-10-01-09:15"),
                      7),  0.1767767)
})

