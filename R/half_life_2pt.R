#' Calculate half-life based on two data points
#' @description Estimate half-life from two data points. Half-life units are
#'   consistent with time units of input.
#'   @family rad measurements
#' @param time1 First time: Must be numeric with no formatting.
#' @param time2 Second time: Must be numeric with no formatting.
#' @param N1 First measurement - can be count rate, dose rate, etc.
#' @param N2 Second measurement in units consistent with first measurement.
#' @return The calculated half-life in units of time input.
#' @examples
#' # Between the first two data points in a series of counts
#' half_life_2pt(time1 = 0, time2 = 1, N1 = 45, N2 = 30)
#' #
#' # Between the second and third in the series (same intervals)
#' half_life_2pt(time1 = 1, time2 = 2, N1 = 30, N2 = 21)
#' #
#' # Use on a series
#' count_times <- 1:5
#' acts <- 10000 * 2^(-count_times/10) #activities
#' acts <- rpois(5, acts) #activities with counting variability applied
#' half_life_2pt(time1 = count_times[1:4], time2 = count_times[2:5],
#' N1 = acts[1:4], N2 = acts[2:5])
#' @export
half_life_2pt <- function(time1, time2, N1, N2) {
  as.numeric(time2 - time1) /
    (-log(N2 / N1)/log(2))
}
