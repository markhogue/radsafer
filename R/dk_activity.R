#' Time for a radionuclide to decay to a target activity.
#' @family decay corrections
#' @description Calculate time for a radionuclide to decay to a target activity.
#' @param A0 The original activity, or related parameter.
#' @param half_life, Half-life. Units are arbitrary, but must match time past.
#' @param target The target activity.
#' @return time, in same units as half-life, to decay to target activity.
#' @examples
#' # How long does it take for original activity of 10 to decay to 2.5 
#' # if half-life is 5? (All time units consistent)
#' dk_activity(10, 5, 2.5)
#' @export
dk_activity <- function(A0, half_life, target) {
  if(!is.numeric(c(A0, half_life, target)))
    stop("All arguments must be a numbers.")
    -half_life * log(target/A0) / log(2)
}
