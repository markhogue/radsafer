context("tests for half_life_2pt")

test_that("years entered",  {
  expect_equal(signif(half_life_2pt(2015, 2016, 45, 30), 7), 1.709511)
})
test_that("minutes entered", {
  expect_equal(signif(half_life_2pt(0, 60, 60, 15), 2), 30)
  })
