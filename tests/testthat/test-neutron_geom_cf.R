context("tests for neutron_geom_cf")

test_that("NRD on contact", {
  expect_equal(signif(neutron_geom_cf(11.1, 11), 7), 0.7236467)
})

test_that("NRD at 30 cm", {
  expect_equal(signif(neutron_geom_cf(30, 11), 7), 0.9822795)
})

test_that("Rem 500 on contact", {
  expect_equal(signif(neutron_geom_cf(5, 4.5), 7), 0.8358183)
})
