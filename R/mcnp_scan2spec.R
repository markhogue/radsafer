#' Copy and paste MCNP output spectral data for use with \code{mcnp_plot_out_spec()}
#' @family mcnp tools
#' @description Provides quick copy-and-paste conversion to data frame.
#' Paste either a source histogram distribution or tally spectrum from MCNP outputs.
#' Three-column output tally spectra have columns of maximum energy, bin tally, and 
#' relative Monte Carlo uncertainty for the bin tally value. 
#' Four-column  source histogram distributions have columns of entry number, maximum 
#' energy, cumulative probability, and bin probability.
#' In either case, only the maximum energy and bin probability or result values are used.
#' 
#' @return spectrum file with maximum energy and MCNP bin value
#' @examples
#' # Since this function requires the user
#' # to copy and paste input, this example
#' # is set up to provide data for this purpose.
#' # To run the example, copy and paste the following
#' # into an input file and delete the hash tags to run.
#' # my_hist_data <- mcnp_scan2spec()
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
#' @export
mcnp_scan2spec <- function() {
  cat("Use this function to copy, paste and save'\n'")
  cat("four column source histogram distribution '\n'")
  cat("or three column binned-by-energy tally results'\n'")
  cols <- readline("Enter number of columns to enter (3 or 4). ")
  if (!cols %in% c(3, 4)) {
    stop("This only works for three or four column energy dists.")
  }
  if (cols == 3) {
    cat("Copy and paste MCNP three column'\n'")
    cat("binned-by-energy tally results (no header)'\n'")
    cat("then hit [enter].'\n'")
    raw_scan <- scan()
    mtrx <- matrix(raw_scan, ncol = 3, byrow = TRUE)
    spec.df <- data.frame(
      E.avg = mtrx[, 1] - c(diff(c(0, mtrx[, 1]))) / 2, #average from Emax
      fraction = mtrx[, 2],
      unc = mtrx[, 3]
    )
}
  if (cols == 4) {
    cat("copy and paste MCNP source histogram distribution,'\n'")
    cat("with no header'\n'")
    cat("then hit [enter]'\n'")
    raw_scan <- scan()
    mtrx <- matrix(raw_scan, ncol = 4, byrow = TRUE)
    spec.df <- data.frame(E.avg = mtrx[, 2] - c(diff(c(0, mtrx[, 2]))) / 2, #average from Emax
                          prob = mtrx[, 4])
  }
  spec.df
}

