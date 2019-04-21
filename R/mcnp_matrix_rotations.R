#' Rotation matrices for transformations in MCNP
#' @family mcnp tools
#' @description 
#' Create 3 x 3 rotation matrix in cosines of the angles
#' between the main and auxiliary coordinate systems in the form:
#'      xx' yx' zx'
#'      xy' yy' zy'
#'      xz' yz' zz'
#' @param rot.axis axis of rotation
#' @param angle_degrees degree of rotation
#' 
#' @return rotational matrix for copy and paste to MCNP input
#' 
#' @examples 
#' mcnp_matrix_rotations('x', 30) 
#' mcnp_matrix_rotations('y', 7)
#' mcnp_matrix_rotations('z', 15)
#' # For combined rotations, use matrix multiplication (%*%)
#' # rotate 45 degrees on x-axis and 45 degrees on y-axis
#' mcnp_matrix_rotations('x', 45) %*% mcnp_matrix_rotations('y', 45)

#' 
#' @export
mcnp_matrix_rotations <- function(rot.axis, angle_degrees) {
  
  if (!rot.axis %in% c("x", "y", "z")) {
    cat("axis of rotation must be either 'x', 'y' or 'z'")
    return
  }
  # x, y, z base ('Identity') matrix
  x1 <- matrix(c(1, 0, 0))
  x2 <- matrix(c(0, 1, 0))
  x3 <- matrix(c(0, 0, 1))
  A <- matrix(c(x1, x2, x3), nrow = 3)
  
  ind_fun <- function(n) ((n%%3) + c(0, 1))%%3 + 1
  
  rot.angle <- pi/180 * angle_degrees
  if (rot.axis == "x") 
    ax.num <- 1
  if (rot.axis == "y") 
    ax.num <- 2
  if (rot.axis == "z") 
    ax.num <- 3
  
  R <- A  # to set up
  ind <- ind_fun(ax.num)
  R[ind[1], ind[1]] <- round(cos(rot.angle), 8)
  R[ind[1], ind[2]] <- round(-sin(rot.angle), 8)
  R[ind[2], ind[1]] <- round(sin(rot.angle), 8)
  R[ind[2], ind[2]] <- round(cos(rot.angle), 8)
  R
}