context("tests for air_dens_cf")

test_that("temperature only", {
  expect_equal(air_dens_cf(20, 760), 1)
  })
test_that("pressure only", {
  expect_equal(signif(air_dens_cf(30, 760), 7), 1.034112)
  })
test_that("temperature and pressure change", {
  expect_equal(signif(air_dens_cf(20, 780), 6), 0.974359)
  })
test_that("intentional air_dens_cf error check", {
    expect_equal(signif(air_dens_cf(20, 780), 6), 2)
  })
