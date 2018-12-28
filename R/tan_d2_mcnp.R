#' MCNP Cone Opening Parameter
#' @description MCNP cone surface requires a term, t^2, which is the tangent of
#'   the cone angle, in radians, squared. This function takes an input in
#'   degrees and provides the parameter needed by MCNP.
#' @param d The cone angle in degrees.
#' @return The ratio of actual to reference air density.
#' @examples
#' tan_d2(45)
#' @export
tan_d2 <- function(d) tan(d * pi / 180)^2
