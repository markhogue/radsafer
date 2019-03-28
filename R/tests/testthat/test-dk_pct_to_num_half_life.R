context("tests for dk_pct_to_num_half_life")

test_that("93.75% gone",  {
  expect_equal(signif(dk_pct_to_num_half_life(93.75),
                      4),  4.000)
  })

test_that("Intentional error check case",  {
  expect_equal(signif(dk_pct_to_num_half_life(93.75),
                      4),  5)
})

