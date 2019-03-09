#' MCNP histograms source energies
#' @description Make MCNP histogram energy bins cards for source definition.

#' @param emin A vector of energies forming the lower bound of the bin. (emin values other than the first value also provide a bin emax.)
#' @param emax A single energy with the upper bound of the highest bin. 
#' @return A matrix of values for source input to copy and paste into an MCNP input. (The # should be changed to the appropriate distribution number. The NA's in the last row should be discarded.)
#' @examples 
#' si_hist(1:10 / 10, 1.2)
#' @export
#  ------------------------
si_hist <-  function(emin, emax) {
  X <- c(emin, emax[length(emax)])
  if(length(X) %% 5 !=0) X <- c(X, rep(NA, 5 -length(X) %% 5))
  prmatrix(matrix(X, byrow = T, ncol = 5), 
           rowlab = c("si#  ", rep("     ", length(X)/5 - 1)),
           collab = rep("     ", 5))
}

#' MCNP histograms source bin probabilities
#' @description Make MCNP histogram probabilities for energy bins.
#' @param bin_prob A vector of the bin probabilities.
#' @return A matrix of values for source probabilities to copy and paste into an MCNP input. (The # should be changed to the appropriate distribution number. The NA's in the last row should be discarded.)
#' @examples 
#' sp_hist(rep(1 / 11, 11))
#' @export
#  ------------------------

sp_hist <- function(bin_prob) {
  X <- c(0, bin_prob) / sum(bin_prob) # What's below the first bin - si's are max for bin
  if(length(X) %% 5 != 0) X <- c(X, rep(NA, 5 -length(X) %% 5))
  prmatrix(matrix(X, byrow = T, ncol = 5), 
           rowlab = c("sp#  ",rep("     ", length(X)/5 - 1)),
           collab = rep("     ", 5))
}
