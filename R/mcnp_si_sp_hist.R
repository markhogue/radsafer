#' energy distribution histogram entries
#' @family mcnp tools
#' @description Make MCNP histogram probabilities for energy bins.
#' @param emin A vector of lower bounding energy. (The highest energy is the higher bound.) If higher bounding energy data is available, convert it to lower bound by concatenating e.g. `emin = c(my_low-E, emax_data)`. This vector length must exceed the probability vector by 1.
#' @param bin_prob A vector of the bin probabilities. There are n-1 probability values for n values of emin.
#' @param my_dir Optional directory. The function will write an output text file, si_sp.txt to the working directory by default.
#' @return A vector of energy bins and probabilities for an energy distribution, formatted as needed for MCNP input. It is designed for copying and pasting into an MCNP input. (The # should be changed to the appropriate distribution number.) The data is saved in the global environment and appended to a file in the user's working directory, si_sp.txt. Two plots of the data are provided to the plot window,  one with two linear axes and one with two log axes.
#' @details Data may be identified by named vector, e.g. my_emin_data, or by column of a data frame, e.g. photons_cs137_hist[1] (which is in emax format) and photons_cs137_hist[2] (bin_prob).
#' @seealso [mcnp_si_sp_hist_scan()] for copy and paste in data
#' @seealso [mcnp_si_sp_RD()] for data from `RadData`
#' @examples
#' mcnp_si_sp_hist(
#'   emin = c(0, photons_cs137_hist[1:64, 1]),
#'   bin_prob = photons_cs137_hist[1:64, 2]
#'  )
#' @export

mcnp_si_sp_hist <- function(emin, bin_prob, my_dir = NULL) {
  if (is.null(my_dir)) my_dir <- getwd()
  # construct table of energy bins with 5 columns
  emin_raw <- emin
  if (length(emin) %% 5 != 0) {
    emin <- c(emin_raw, rep("$", 5 - length(emin_raw) %% 5))
    emin
  }
  
  emin.m <- matrix(emin, byrow = T, ncol = 5)
  emin.out <- as.data.frame(emin.m)
  col1 <- c("si#", rep("     ", length(emin.out[, 1]) - 1))
  
  emin.out <- cbind(col1, emin.out)
  
  names(emin.out) <- c(
    "c", "radsafer", "mcnp_si_sp_hist",
    "output ", "from ", as.character(Sys.Date())
  )
  
  utils::write.table(emin.out,
                     file = paste0(my_dir, "/si_sp.txt"),
                     append = TRUE,
                     row.names = FALSE,
                     quote = FALSE
  )
  # print to screen
  prmatrix(emin.m,
           rowlab = c("si#  ", rep(
             "     ",
             # Space over for every row after first
             # (full rows + partially filled row)
             as.numeric(length(emin) %/% 5) + ((54 %% 5) > 0)
           )),
           collab = rep("     ", 5),
           quote = FALSE
  )
  #
  # construct table of energy bins with 5 columns
  #
  bin_prob_raw <- bin_prob
  bin_prob <- c(0, bin_prob)
  if (length(bin_prob) %% 5 != 0) {
    bin_prob <- c(bin_prob, rep("$", 5 - length(bin_prob) %% 5))
  }
  bin_prob.m <- matrix(bin_prob, byrow = T, ncol = 5)
  bin_prob.out <- as.data.frame(bin_prob.m)
  col1 <- c("sp#", rep("     ", length(bin_prob.out[, 1]) - 1))
  bin_prob.out <- cbind(col1, bin_prob.out)
  
  names(bin_prob.out) <- c(
    "c", "radsafer", "mcnp_si_sp_hist",
    "output, ", as.character(Sys.Date())
  )
  
  # write output table
  utils::write.table(bin_prob.out,
                     file = paste0(my_dir, "/si_sp.txt"),
                     append = TRUE,
                     row.names = FALSE,
                     quote = FALSE
  )
  prob_sum <- paste0("c The sum of the bins is: ", sum(bin_prob_raw))
  utils::write.table(prob_sum,
                     file = paste0(my_dir, "/si_sp.txt"),
                     append = TRUE,
                     row.names = FALSE, col.names = FALSE,
                     quote = FALSE
  )
  # print to screen
  prmatrix(bin_prob.m,
           rowlab = c("sp#  ", rep(
             "     ",
             # Space over for every row after first
             # (full rows + partially filled row)
             as.numeric(length(bin_prob) %/% 5) + ((54 %% 5) > 0)
           )),
           collab = rep("     ", 5),
           quote = FALSE
  )
  cat("\n")
  cat(prob_sum)
  cat("\n")
  cat(paste0(
    "The output file, si.sp.hist.txt, is going to your working directory, ",
    my_dir, " but you can copy from the screen above instead."
  ))
  cat("\n")
  E.avg <- fraction <- NULL # avoid no visible binding note
  # Make data frame for plotting
  spec.df <- data.frame("E.avg" = emin_raw[1:(length(emin_raw) - 1)] + c(diff(emin_raw)), "fraction" = bin_prob_raw)
  
  # Plot spectrum - linear axes
  ggplot2::ggplot(data = spec.df, ggplot2::aes(E.avg, fraction)) + ggplot2::geom_line()
  
  # Plot spectrum - log axes
  ggplot2::ggplot(data = spec.df, ggplot2::aes(E.avg, fraction)) + ggplot2::geom_line() +
    ggplot2::scale_x_log10() +
    ggplot2::scale_y_log10()
}

