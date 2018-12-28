#' Time to decay.
#' @description Calculate time for a radionuclide to decay to a target activity.
#' @param A0 The original activity, or related parameter.
#' @param t_h, Half-life. Units are arbitrary, but must match time past.
#' @param t The time past since origional activity.
#' @return Time, in same units as half-life, to decay to target activity.
#' @examples
#' dk_activity(10, 8, 60)
#' @export
dk_activity <- function(A0, t_h, t) {
  A0 * 2^-(t / t_h)
}

