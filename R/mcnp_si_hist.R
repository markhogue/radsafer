#' energy distribution histogram entries
#' @family mcnp tools
#' @seealso  [mcnp_sp_hist()] 
#' @description Make MCNP histogram energy bins cards for source definition if inputs happen to be available in histogram format.
#' @param emin A vector of energies forming the lower bound of the bin. (emin values other than the first value also provide a bin emax.)
#' @param emax A single energy with the upper bound of the highest bin. 
#' @return A matrix of values for source input to copy and paste into an MCNP input. (The # should be changed to the appropriate distribution number. The NA's in the last row should be discarded.)
#' @examples 
#' mcnp_si_hist(1:10 / 10, 1.2)
#' @export
#  ------------------------
mcnp_si_hist <-  function(emin, emax) {
  X <- c(emin, emax[length(emax)])
  if(length(X) %% 5 !=0) X <- c(X, rep(NA, 5 -length(X) %% 5))
  prmatrix(matrix(X, byrow = T, ncol = 5), 
           rowlab = c("si#  ", rep("     ", length(X)/5 - 1)),
           collab = rep("     ", 5))
}

