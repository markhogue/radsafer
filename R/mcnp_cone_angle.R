#' MCNP Cone Opening Parameter
#' @family mcnp tools
#' @description MCNP cone surface requires a term, t^2, which is the tangent of
#'   the cone angle, in radians, squared. This function takes an input in
#'   degrees and provides the parameter needed by MCNP.
#' @param d The cone angle in degrees.
#' @return tangent of cone angle squared
#' @examples
#' mcnp_cone_angle(45)
#' @export
mcnp_cone_angle <- function(d) tan(d * pi / 180)^2
