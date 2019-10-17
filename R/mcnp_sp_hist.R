#' energy distribution histogram entries
#' @family mcnp tools
#' @seealso  [mcnp_si_hist()]
#' @description Make MCNP histogram probabilities for energy bins.
#' @param bin_prob A vector of the bin probabilities.
#' @return A matrix of values for source probabilities to copy and paste into an MCNP input. (The # should be changed to the appropriate distribution number. The NA's in the last row should be discarded.)
#' @examples
#' mcnp_sp_hist(rep(1 / 11, 11))
#' @export
#  ------------------------

mcnp_sp_hist <- function(bin_prob) {
  X <- c(0, bin_prob) / sum(bin_prob) # What's below the first bin - si's are max for bin
  if (length(X) %% 5 != 0) X <- c(X, rep(NA, 5 - length(X) %% 5))
  prmatrix(matrix(X, byrow = T, ncol = 5),
    rowlab = c("sp#  ", rep("     ", length(X) / 5 - 1)),
    collab = rep("     ", 5)
  )
}
