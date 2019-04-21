#' Copy and paste MCNP tally fluctuation charts
#' @family mcnp tools
#' @description Provides quick estimate of number of particles histories,
#' (nps) to obtain target MCNP 'error'.
#' Paste may include up to three tallies side by side in the default MCNP
#' order. For example, the headers of a three tally report includes column 
#' names: nps, mean, error, vov, slope, fom, mean, error, vov, slope, fom,
#' mean, error, vov, slope, fom.
#' The structure of the tfc has been the same for versions 4 through 6,
#' including MCNPX. 
#' 
#' @param err_target The target Monte Carlo uncertainty
#' 
#' @return estimate of number of particle histories needed
#' @examples 
#' # Since this function requires the user
#' # to copy and paste input, this example 
#' # is set up to provide data for this purpose.
#' # To run the example, copy and paste the following
#' # into an input file and delete the hash tags to run.
#' # Enter '1' for number of tallies.
#' # mcnp_est_nps(0.01)
#' #      32768000   4.5039E+00 0.2263 0.0969  0.0 5.0E-02
#' #      65536000   3.9877E+00 0.1561 0.0553  0.0 5.1E-02
#' #      98304000   3.4661E+00 0.1329 0.0413  0.0 4.7E-02
#' #     131072000   3.5087E+00 0.1132 0.0305  0.0 5.0E-02
#' #     163840000   3.5568E+00 0.0995 0.0228  0.0 5.2E-02
#' #     196608000   3.8508E+00 0.0875 0.0164  0.0 5.5E-02
#' #     229376000   3.8564E+00 0.0810 0.0135  0.0 5.5E-02
#' #     262144000   3.9299E+00 0.0760 0.0118  0.0 5.5E-02
#' #     294912000   4.0549E+00 0.0716 0.0100  0.0 5.6E-02
#' #     327680000   4.0665E+00 0.0686 0.0090  0.0 5.4E-02
#' #     360448000   4.1841E+00 0.0641 0.0079  0.0 5.7E-02
#'
#' @export 
mcnp_est_nps <- function(err_target) {
  n <- as.numeric(readline(prompt = "How many tallies (1, 2 or 3) will you be scanning? "))
  stopifnot(n %in% c(1, 2, 3))
  cat("Copy and paste MCNP tally fluctuation charts. \n 
      Then hit [enter] \n 
      Do not include column headers.")
  raw_scan <- scan()
  mtrx <- matrix(raw_scan, ncol = 1 + 5 * n, byrow = TRUE)
  tfc.df <- data.frame(mtrx)
  rm(mtrx)
  # forecast nps needed for target error using latter half of tfc
  latter_half <- tfc.df[-(1:floor(length(tfc.df[, 1])/2)), ]
  new_err <- seq(err_target, 0.5, length.out = 50)
  err_loc <- c(3, 8, 13)[1:n]  #one through three error columns
  tal_num <- c("first", "second", "third")
  counter <- 0
  nps_fn <- function(err, b, m) exp((err - b)/m)
  # loop for all 1 through 3 tallies pasted
  for (i in err_loc) {
    counter <- counter + 1
    cat("\n ")
    if (latter_half[length(latter_half[, 1]), i] <= err_target) {
      cat(paste0("Error target already achieved in ", tal_num[counter], " tally."))
      next
    }
    lm1 <- stats::lm(latter_half[, i] ~ log(latter_half[, 1]))
    if (summary(lm1)$adj.r.squared < 0.8) 
      cat(paste0("Warning: Not a reliable trend in ",  tal_num[counter], " tally. \n"))
    if (lm1$coefficients[[2]] > 0) 
      cat(paste0("Error trend is positive in ", tal_num[counter], 
                 " tally.\nResults will be erroneous.\n"))
    extrap_nps1 <- nps_fn(new_err, stats::coefficients(lm1)[[1]], stats::coefficients(lm1)[[2]])
    cat("\n ")
    print(data.frame(Tally = tal_num[counter], `Estimated nps needed` = format(extrap_nps1[1], 
                                                                               digits = 2, scientific = TRUE), `error target` = err_target, row.names = ""))
    graphics::plot(x = tfc.df[, 1], y = tfc.df[, i], xlim = c(tfc.df[1, 1],   max(c(extrap_nps1, tfc.df[, 1]))), ylim = c(err_target, 
                                                                                                                max(tfc.df[, i])), xlab = "nps", ylab = "MC run uncert", 
         log = "x", main = paste0("rough forecast nps vs error, ", 
                                  tal_num[counter], " tally"), col = "darkblue", col.main = "darkblue", col.axis = "darkblue", col.lab = "darkblue")
    graphics::lines(extrap_nps1, new_err[1:length(extrap_nps1)], col = "firebrick1", 
          lty = 2)
    graphics::abline(h = err_target, col = "darkgreen", lty = 2)
  }
}
