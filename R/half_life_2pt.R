#' Calculate half-life based on two data points
#' @description Estimate half-life from two data points. Half-life units are
#'   consistent with time units of input.
#' @param time1 First time: Must be numeric with no formatting.
#' @param time2 Second time: Must be numeric with no formatting.
#' @param N1 First measurement - can be count rate, dose rate, etc.
#' @param N2 Second measurement in units consistent with first measurement.
#' @return The calculated half-life in units of time input.
#' @examples
#' half_life_2pt(2015, 2016, 45, 30)
#' half_life_2pt(0, 60, 60, 15)
#' @export
half_life_2pt <- function(time1, time2, N1, N2) {
  as.numeric(time2 - time1) /
    (-log(N2 / N1)/log(2))
}
