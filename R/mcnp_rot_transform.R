#' MCNP coordinate transformation rotation
#' @description Make rotation matrix for use with MCNP transformation card. For combined rotations, use matrix multiplication (%*%)
#' @param rot.axis axis (x, y or z) with respect to which the rotation is to be made.
#' @param angle_degrees angle, in degrees, of rotation about the rotation axis
#' @return A transformation matrix to include with a transformation card.
#' @examples 
#' rot_fun("x", 30)
#' rot_fun("y", 7)
#' rot_fun("z", 15)
#' rot_fun("x", 45) %*% rot_fun("y", 45)
#' @export
#  ------------------------# 
rot_fun <- function(rot.axis, angle_degrees) {
  rot.angle <- pi / 180 * angle_degrees

  ax.num <- dplyr::case_when(rot.axis == "x" ~ 1,
                    rot.axis == "y" ~ 2,
                    rot.axis == "z" ~ 3,
                    TRUE ~ 1)

  # x, y, z base ("Identity") matrix
  x1 <- matrix(c(1, 0, 0))
  x2 <- matrix(c(0, 1, 0))
  x3 <- matrix(c(0, 0, 1))
  A <- matrix(c(x1, x2, x3), nrow = 3)
  R <- A # initial matrix - no rotation
  ind_fun <- function(n) ((n %% 3) + c(0, 1)) %% 3 + 1
  ind <- ind_fun(ax.num)  
  R[ind[1], ind[1]] <- round(cos(rot.angle),8)
  R[ind[1], ind[2]] <- round(-sin(rot.angle),8)
  R[ind[2], ind[1]] <- round(sin(rot.angle),8)
  R[ind[2], ind[2]] <- round(cos(rot.angle),8)
  prmatrix(matrix(R, byrow = T, ncol = 3), 
           rowlab = rep("     ", 3),
           collab = rep("     ", 3))
}
