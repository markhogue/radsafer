#' energy distribution histogram from pasted data
#' @family mcnp tools
#' @description 
#' `r lifecycle::badge("deprecated")`:
#' This function is deprecated 
#' and will be removed in a future package revision. 
#' For now, it is still usable. 
#' The replacement, `mcnp_sdef_erg_hist` makes MCNP histogram
#' probabilities for energy bins from data either copied and
#' pasted or from the global environment.
#' 
#' @param ebin_mode Either "emin", lower bounding energy values are entered or "emax", upper bounding energy values are entered. If the length of the energy values scanned in are equal to the bin probabilities, a final bounding value (lowest in emax mode and highest in emin mode) will be scanned in.
#' @param my_dir Optional directory. The function will write to the working directory by default.
#' @return A vector of energy bins and probabilities for an energy distribution, formatted as needed for MCNP input. It is designed for copying and pasting into an MCNP input. (The # should be changed to the appropriate distribution number. The data is saved in the global environment and appended to a file in the user's working directory, si_sp.txt. Two plots of the data are provided to the plot window,  one with two linear axes and one with two log axes.
#' @details Data may be identified by named vector, e.g. my_emin_data, or by column of a data frame, e.g. photons_cs137_hist$E_MeV (which is in emax format) and photons_cs137_hist$prob (bin_prob).
#' @seealso [mcnp_si_sp_hist()] for data already loaded in R
#' @seealso [mcnp_si_sp_RD()] for data from `RadData`
#' @examples
#' \dontrun{
#' mcnp_si_sp_hist_scan()
#' }
#' @export
mcnp_si_sp_hist_scan <- function(ebin_mode = "emax", my_dir = NULL) {
  # permission to write file
  cat("This function will write or append a file, si_sp.txt,")
  cat("to your specified, or by default, working directory --") 
  cat("but only with your permission.")
  write_permit <- readline("Enter 'y' to continue. ")
  if (write_permit  != "y") {
    stop("File will not be written.")
  }

  # emin input - first in scanned emin is bounding low energy
  if (!ebin_mode %in% c("emin", "emax")) stop("ebin_mode must be either 'emin' (default) or 'emax'.")

  # scan in energy bins
  cat("Identify ENERGY bins.")
  if (ebin_mode == "emin") cat("Copy and paste a single column of energy bin MINIMUMS to screen. \n
  Then hit [enter] \n 
  Do not include column header. ")
  if (ebin_mode == "emax") cat("Copy and paste a single column of energy bin MAXIMUMS to screen. \n 
      Then hit [enter] \n 
      Do not include column header. ")
  emin <- scan()
  emin

  # scan in bin probabilities
  cat("Next, identify bin PROBABILITIES.")
  cat("Copy and paste a single column of energy bin probabilities or emission rates to screen. \n 
      Then hit [enter] \n 
      Do not include column header. ")
  bin_prob <- scan()
  bin_prob

  # get extra bounding value if needed
  if (length(emin) == length(bin_prob)) {
    if (ebin_mode == "emin") {
      cat("Copy and paste or type in the MAXIMUM energy in the spectrum. \n 
      Then hit [enter] \n")
      emax <- scan()
      emin <- c(emin, emax)
      emin
    }
    if (ebin_mode == "emax") {
      cat("Copy and paste or type in the MINIMUM energy in the spectrum. \n 
      Then hit [enter] \n")
      emin_bounding <- scan()
      emin <- c(emin_bounding, emin)
      emin
    }
  }

  if (!(length(emin) - length(bin_prob)) == 1) stop("Error: The number of bin boundaries and number of probabilities are not compatible.")

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # end of copy-and-paste portion
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  if (is.null(my_dir)) my_dir <- getwd()
  #
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
