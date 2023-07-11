#' Make mesh tally size settings for MCNP
#' @family mcnp tools
#' @description
#' #' `r lifecycle::badge("experimental")`:
#' Find the parameters needed for a rectilinear "superimposed mesh
#' tally b" in MCNP. It can be a challenge to center mesh tally
#' bins at a desired value of x, y, or z. This function looks at a
#' single dimension, -- in units of cm -- at a time. This is a new
#' function and hasn't been tested thoroughly. The idea is to 
#' identify a single setting in the MCNP mesh tally for 
#' imesh and iints (or jmesh and jintsm or kmesh and kints). It
#' is designed only for uniform mesh bin sizes. 
#' 
#' @param target the desired center a single mesh
#' @param width the individual mesh 
#' @param lowest_less in the direction of a decreasing dimension,
#' what is the lowest that it can go and still be acceptable?
#' @param highest_less in the direction of a decreasing dimension,
#' what is the highest that it can go and still be acceptable?
#' @param highest_high in the direction of an increasing dimension,
#' what is the highest that it can go and still be acceptable?
#' @param lowest_high in the direction of an increasing dimension,
#' what is the lowest that it can go and still be acceptable?
#'
#' @return a data frame providing:
#' 
#'  low_set, the minimum dimension. This is probably best used in
#'  the origin parameter in the MCNP mesh tally.
#'  high_set, the maximum dimension for the bin. This can be
#'  identified in the MCNP mesh tally setting of imesh, jmesh, or
#'  kmesh.
#'  width, this is just a return of the parameter supplied to the
#'  function.
#'  numblocks, the number of fine meshes. This can be used in the
#'  MCNP mesh tally setting of iints, jints, or kints.
#'
#' @examples
#' mcnp_mesh_bins(target = 30, width = 10, lowest_less = 0,
#'  highest_less = 15, highest_high = 304.8, lowest_high = 250)
#' #'
#' @export
mcnp_mesh_bins <- function(target,
                        width,
                        lowest_less,
                        lowest_high,
                        highest_high,
                        highest_less) {
  
  # compute maximum numbers of blocks below
  middle_box_low <- target - width / 2
  max_blocks_low <- floor((middle_box_low - lowest_less)/width)
  low_set <- middle_box_low - max_blocks_low * width
  if(low_set > highest_less) cat("minimum range low not met")
  
  # compute maximum numbers of blocks above
  middle_box_high <- target + width / 2
  max_blocks_high <- floor((highest_high - middle_box_high)/width)
  high_set <- middle_box_high +  max_blocks_high * width
  if(high_set < highest_less) cat("minimum range high not met \n")
  numblocks <- max_blocks_low + max_blocks_high + 1
  
  df <- data.frame(low_set, high_set, width, numblocks)
  
  print.data.frame(df, row.names = F)
}

