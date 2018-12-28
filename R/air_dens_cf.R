#' Correct for air density - useful for vented ion chambers
#' @description Obtain a correction factor for ion chamber temperature and
#'   pressure vs reference calibration values.
#' @param T.actual The actual air temperature, in Celsius
#' @param P.actual The actual air pressure, in mm Hg
#' @param T.ref The reference air temperature - default is 20C
#' @param P.ref The reference air pressure - default is 760 mm Hg
#' @return The ratio of actual to reference air density.
#' @examples
#' air_dens_cf(20, 760)
#' air_dens_cf(30, 750)
#' @export
air_dens_cf <- function(T.actual,
                        P.actual,
                        T.ref = 20,
                        P.ref = 760) {
  T.ref.K <- 273.15 + T.ref
  T.actual.K <- 273.15 + T.actual
  T.actual.K / T.ref.K * 760 / P.actual
}
