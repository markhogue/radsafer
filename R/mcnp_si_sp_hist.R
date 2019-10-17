#' energy distribution histogram entries
#' @family mcnp tools
#' @description Make MCNP histogram probabilities for energy bins.
#' @param fun_mode 1 (default) or 2. Run function with copy and paste (1) or with data loaded in R (2).
#' @param bound_mode 1 for "lower" or 2 for "upper". Identify whether bin energy data is lower (minimum energy of each bin) or upper (maximum energy of each bin). If the length of the energy vector is 1 greater than the number of probabilities (bin_prob), then the highest (for case 1) or lowest (for case 2) value will be the maximum (case 1) or minimum (case 2) bounding energy. Otherwise, if the vector lengths are equal, a maximum or minimum bounding energy will be needed.
#' @param emin Lower bounding energy. (See bound_mode)
#' @param emax Upper bounding energy. (See bound_mode)
#' @param bin_prob A vector of the bin probabilities.
#' @return A vector of energy bins and probabilities for an energy distribution, formatted as needed for MCNP input. It is designed for copy and paste into an MCNP input. (The # should be changed to the appropriate distribution number. The data is saved in the global environment and appended to a file in the user's working directory, si_sp.txt. Two plots of the data are provided to the plot window,  one with two linear axes and one with two log axes.
#' @details In copy-and-paste mode (fun_mode = 1), the user will copy and paste, when prompted, a vector of minimum or maximum bin energies, a vector of probabilities for the bins, and a single bounding upper or bin energy, if needed. Paste values may be copied and pasted from spreadsheets or text files, may be tab-separated or space-separated and may not include commas. In data-loaded mode (fun_mode = 2), the data may be identified by named vector, e.g. my_emin_data, or by column of a data frame, e.g. photons_cs137_hist[1] as a emax example and photons_cs137_hist[2] as a bin_prob example.
#' @examples
#' mcnp_si_sp_hist(fun_mode = 2, 
#' bound_mode = 2, 
#' emin = 0, 
#' emax = photons_cs137_hist[1:64, 1], 
#' bin_prob = photons_cs137_hist[1:64, 2])
#' @export
#  ------------------------
mcnp_si_sp_hist <- function(fun_mode = 1, bound_mode, emin, emax, bin_prob) {
  # copy-and-paste mode
  if (fun_mode == 1) {
    bound_mode <- as.numeric(readline(prompt = "First, identify the energy bins you are pasting: \n 1. lower or \n 2. upper \n"))
    if (!bound_mode %in% c(1, 2)) stop("Error: Need to enter either 1 or 2.")

    # scan in energy bins
    cat("Identify ENERGY bins.")
    cat("Copy and paste a single column of energy bin data to screen. \n 
      Then hit [enter] \n 
      Do not include column header. ")
    ebound <- scan()
    ebound

    # scan in bin probabilities
    cat("Next, identify bin PROBABILITIES.")
    cat("Copy and paste a single column of energy bin probabilities or emission rates to screen. \n 
      Then hit [enter] \n 
      Do not include column header. ")
    bin_prob <- scan()
    bin_prob

    if (!(length(ebound) - length(bin_prob)) %in% c(0, 1)) stop("Error: The number of bin boundaries and number of probabilities are not compatible.")

    # get extra bounding value if needed
    if ((length(ebound) - length(bin_prob)) == 1) {
      if (bound_mode == 1) {
        cat("Copy and paste or type in the maximum energy in the spectrum. \n 
      Then hit [enter] \n")
        emax <- scan()
        ebound <- c(ebound, emax[length(emax)])
      }
      if (bound_mode == 2) {
        cat("Copy and paste or type in the minimum energy in the spectrum. \n 
      Then hit [enter] \n")
        emin <- scan()
        ebound <- c(emin[1], ebound)
      }
    }
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # end of copy-and-paste mode
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # data-loaded-in R mode
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if (fun_mode == 2) {
    if (bound_mode == 1) ebound <- emin
    if (bound_mode == 2) ebound <- emax


    if (!(length(ebound) - length(bin_prob)) %in% c(0, 1)) stop("Error: The number of bin boundaries and number of probabilities are not compatible.")

    # get extra bounding value if needed
    if (length(ebound) == length(bin_prob)) {
      if (bound_mode == 1) ebound <- c(ebound, emax[length(emax)])
    }
    if (bound_mode == 2) {
      ebound <- c(emin[1], ebound)
    }
  }

  ebound_raw <- ebound
  my_dir <- getwd()
  #
  # construct table of energy bins with 5 columns
  if (length(ebound) %% 5 != 0) {
    ebound <- c(ebound, rep("$", 5 - length(ebound) %% 5))
  }
  ebound.m <- matrix(ebound, byrow = T, ncol = 5)
  ebound.out <- as.data.frame(ebound.m)
  col1 <- c("si#", rep("     ", length(ebound.out[, 1]) - 1))

  ebound.out <- cbind(col1, ebound.out)

  names(ebound.out) <- c(
    "c", "radsafer", "mcnp_si_sp_hist",
    "output ", "from ", as.character(Sys.Date())
  )

  utils::write.table(ebound.out,
    file = "si_sp.txt",
    append = TRUE,
    row.names = FALSE,
    quote = FALSE
  )
  # print to screen
  prmatrix(ebound.m,
    rowlab = c("si#  ", rep(
      "     ",
      # Space over for every row after first
      # (full rows + partially filled row)
      as.numeric(length(ebound) %/% 5) + ((54 %% 5) > 0)
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
  # bin_prob.out$cont <- c(rep(" &" ,length(bin_prob.out[, 1]) - 1), " ")
  names(bin_prob.out) <- c(
    "c", "radsafer", "mcnp_si_sp_hist",
    "output, ", as.character(Sys.Date())
  )

  # write output table
  utils::write.table(bin_prob.out,
    file = "si_sp.txt",
    append = TRUE,
    row.names = FALSE,
    quote = FALSE
  )
  prob_sum <- paste0("c The sum of the bins is: ", sum(bin_prob_raw))
  utils::write.table(prob_sum,
    file = "si_sp.txt",
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
  # Plot spectrum - linear axes
  radsafer::mcnp_plot_out_spec(data.frame(
    "Emax" = ebound_raw,
    "emission" = c(0, bin_prob_raw),
    "unc" = rep(0, length(ebound_raw))
  ),
  title = ""
  )
  # Plot spectrum - log axes
  radsafer::mcnp_plot_out_spec(data.frame(
    "Emax" = ebound_raw,
    "emission" = c(0, bin_prob_raw),
    "unc" = rep(0, length(ebound_raw))
  ),
  title = "",
  log_axes = TRUE
  )
}
