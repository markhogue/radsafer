#' Reverse decay
#' @description Calculate the activity at an earlier time, given the time past,
#'   the half-life, and the activity at time, t. The result will provide
#'   activity in the same units as provided for present activity. Time past and
#'   half-life must be in consistent units.
#' @param t Time past since activity of interest. Units are arbitrary, but must
#'   match half-life.
#' @param half_life Half-life. Units are arbitrary, but must match time past.
#' @param A1 The target activity or related parameter, such as dose rate.
#' @return The original activity or related parameter.
#' @examples
#' dk_reverse(80, 8, 1)
#' @export
dk_reverse <- function(t, half_life, A1) {
    A1 * 2^(t / half_life)
}

