#' Copy and paste MCNP output spectral data for use with `mcnp_plot_out_spec.R`
#' @description Provides quick copy-and-paste conversion to data frame.
#' Converion is based on the three columns with 
#' results from MCNP output in energy bins with
#' maximum energy in MeV in the first column,
#' the mean result for the bin in the second column, and 
#' relative Monte Carlo uncertainty in the third column.
#' @return spectrum file with maximum energy and MCNP bin value
#' @export
scan2spec.df <- function() {
  print("copy and paste MCNP three column")
  print("binned-by-energy tally results (no header)")
  print("then hit [enter] twice")
  raw_scan <- scan()
  mtrx <- matrix(raw_scan, ncol = 3, byrow = TRUE)
spec.df <- data.frame("E.avg" = mtrx[, 1], 
                      "fraction" = mtrx[, 2], 
                      "unc" = mtrx[, 3])
}



