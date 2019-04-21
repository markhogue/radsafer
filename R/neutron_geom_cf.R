#' Solid Angle Correction for Neutron Detectors with Point Source
#' @description Correction factors are needed when an Neutron Rem Detector (NRD)
#'   aka "Remball" is used in close proximity to a points source. This formula
#'   is per ISO ISO 8529-2-2000 section 6.2. Note, however, that the ISO formula
#'   predicts the response. The formula used here takes the inverse to correct
#'   for the over-response.
#' @family rad measurements
#' @param l The distance from the center of the detector to the center of the
#'   source. Units of l and r.d must be consistent.
#' @param r.d The detector radius. Value for typical NRD is 11 cm. An example is
#'   also provided with a Rem 500 detector with a radius of 4.5 cm.
#' @param del The neutron effectiveness factor, default per ISO.
#' @return The correction factor for solid angle.
#' @examples
#' neutron_geom_cf(11.1, 11)
#' neutron_geom_cf(30, 11)
#' neutron_geom_cf(5, 4.5)
#' @export
neutron_geom_cf <- function(l, r.d, del=0.5) {
  if(l < r.d) stop("l must be > r.d")
  (1 + del * (2 * l^2 / r.d^2 * (1 - sqrt(1 - r.d^2 / l^2)) - 1))^-1
}
