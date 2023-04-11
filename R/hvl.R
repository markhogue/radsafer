#' half-value layer and tenth-value layer computations
#' @description Derive hvl and tvl from radiation values through a material thickness. 
#' @param x material thickness
#' @param y radiation measure through the material 
#' @return a data frame with the inputs, followed by the computed values for attenuation coefficient (listed as "mu"), half-value layer (hvl), tenth-value layer (tvl), and the homogeneity coefficient (hc) which is the ratio of a half-value layer to the following half-value layer.
#' @examples
#' H50_ex <- data.frame("mm_Al" = 0:5, "mR_h" = c(7.428, 6.272, 5.325,4.535, 3.878, 3.317))
#' hvl(x = H50_ex$mm_Al, y = H50_ex$mR_h) 
#' @export
hvl <- function(x, y) {
  df <- data.frame(x, y)
  mu <- log(dplyr::lag(df$y) / 
              df$y) / c(NA, diff(x))
  hvl <- log(2) / mu
  tvl <- log(10) / mu
  df <- data.frame("thickness" = x, "response" = y, "mu" = mu, "hvl" = hvl, "tvl" = tvl)

  df$hc <- df$hvl / (dplyr::lead(df$hvl))
  df
  }
