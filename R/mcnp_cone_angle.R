#' MCNP Cone Opening Parameter
#' @family mcnp tools
#' @description MCNP cone surface requires a term, t^2, which is the tangent of
#'   the cone angle, in radians, squared. This function takes an input in
#'   degrees and provides the parameter needed by MCNP.
#' @param d The cone angle in degrees.
#' @return The ratio of actual to reference air density.
#' @examples
#' mcnp_cone_angle(45)
#' @export
mcnp_cone_angle <- function(d) tan(d * pi/180)^2

#' Copy and paste MCNP output spectral data for use with `mcnp_plot_out_spec.R`
#' @description Provides quick copy-and-paste conversion to data frame.
#' Conversion is based on the three columns with 
#' results from MCNP output in energy bins with
#' maximum energy in MeV in the first column,
#' the mean result for the bin in the second column, and 
#' relative Monte Carlo uncertainty in the third column.
#' @return spectrum file with maximum energy and MCNP bin value
#' @examples 
#' # Since this function requires the user
#' # to copy and paste input, this example 
#' # is set up to provide data for this purpose.
#' # To run the example, copy and paste the following
#' # into an input file and delete the hash tags to run.
#' # my_hist_data <- my_scan_fun()
#' # 0.1000000 3.133122e-05 0.3348260
#' # 0.4222222 6.731257e-05 0.2017546
#' # 0.7444444 5.249198e-05 0.4524577
#' # 1.0666667 2.046046e-04 0.4201954
#' # 1.3888889 1.525125e-03 0.8049388
#' # 1.7111111 2.922743e-05 0.7985399
#' # 2.0333333 5.162954e-03 0.1974694
#' # 2.3555556 2.048186e-05 0.5011170
#' # 2.6777778 1.468040e-04 0.7248116
#' # 3.0000000 1.037092e-04 0.7659850
#' 
#'
#' @export 
scan2spec.df <- function() {
  print("copy and paste MCNP three column")
  print("binned-by-energy tally results (no header)")
  print("then hit [enter] twice")
  raw_scan <- scan()
  mtrx <- matrix(raw_scan, ncol = 3, byrow = TRUE)
  spec.df <- data.frame(E.avg = mtrx[, 1], 
                        fraction = mtrx[, 2], 
                        unc = mtrx[, 3])
}
