#' Time to decay to target radioactivity.
#' @family decay corrections
#' @description Calculate time for a radionuclide to decay to a target activity.
#' @param half_life, Half-life. Units are arbitrary, but must match time past.
#' @param A0 The original activity, or related parameter.
#' @param A1 The target activity.
#' @return Time, in same units as half-life, to decay to target activity.
#' @examples
#' # A carbonaceous artifact has a C-14 measurement of 1 dpm per g pure carbon.
#' # The reference activity is 14 dpm per g pure carbon. How old is our sample?
#' dk_time(5730, 14, 1)
#' @export
dk_time <- function(half_life, A0, A1) {
  if(!is.numeric(c(half_life, A0, A1)))
    stop("All arguments must be a numbers.")
    -half_life * log(A1 / A0) / log(2)
}
