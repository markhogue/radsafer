#' Estimate tau parameter for [ratemeter_sim]
#' @description If the time constant is not known, but the vendor specifies that
#'   the ratemeter will reach some percentage of equilibrium in some number of
#'   seconds, use this function to estimate tau.
#' @family rad measurements
#' @param pct_eq Percent equilibrium
#' @param t_eq Time, in seconds, to the given percent equilibrium is achieved.
#' @return tau, the time constant, in seconds.
#' @examples
#' tau_estimate(90, 22)
#' @export
tau_estimate <- function(pct_eq, t_eq)
        (-log(1 - pct_eq / 100) / t_eq)^-1
