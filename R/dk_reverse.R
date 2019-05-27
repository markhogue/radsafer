#' Calculate amount of radioactivity given interval. 
#' @family decay corrections
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
#' # A Sr-90 Radioisotope thermoelectric generator is discovered and measured. 
#' # The activity is estimated to be around 400 TBq. Original RTG's of this 
#' # type contained 1480 TBq when built 50 years earlier. We're wondering if 
#' # much has leaked. So, we compute the original from what we have. 
#' dk_reverse(A1 = 400, half_life = 28.79, t = 50)
#' @export
dk_reverse <- function(A1, half_life, t) {
  if(!is.numeric(c(t, half_life, A1)))
    stop("All arguments must be a numbers.")
    A1 * 2^(t / half_life)
}
