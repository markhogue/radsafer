#' energy distribution histogram from pasted data
#' @family mcnp tools
#' @param entry_mode How do you want to enter the data? Default is "scan", allowing you to copy and paste data in at prompts. The other option is "read". In read mode, you identify the data that is already loaded in R. 
#' @param E_MeV Energy bin levels in MeV. 
#' @param bin_prob Relative probability of bin energy.
#' @param my_dir Optional directory. The function will write to the working directory by default.
#' @param write_permit Set this to 'y' to allow writing output to your directory.
#' @param log_plot 0 = no log axes (default), 1  = log y-axis, 2 = log both axes.
#' @return A vector of energy bins and probabilities for an energy distribution, formatted as needed for MCNP input. It is designed for copying and pasting into an MCNP input. 
#' @details The output includes si# and sp#. The # should be changed to the appropriate distribution number. The data is saved in the global environment and appended to a file in the user's working directory, si_sp.txt. Two plots of the data are provided to the plot window,  one with two linear axes and one with two log axes.
#' @seealso [mcnp_sdef_erg_line()] for data from `RadData`
#' @examples
#' \dontrun{
#' mcnp_sdef_erg_hist()
#' }
#' @export
mcnp_sdef_erg_hist <- function(entry_mode = "scan",
                                 my_dir = NULL,
                                 E_MeV = NULL,
                                 bin_prob = NULL,
                                 write_permit = "n",
                                 log_plot = 0) {
  if (write_permit  != "y") {
    message("File will not be written because the write_permit parameter is not \"y\"")
    message("\n")
    message("But you can copy results from screen. \n \n")
  }

  if(entry_mode == "scan") {
  # scan in energy bins
  message("Identify ENERGY bins. \n")
  message("Copy and paste a single column of energy bins to screen. \n
  Then hit [enter] \n 
  Do not include column header. ")
  E_MeV <- scan()
  E_MeV
  }

  if(entry_mode == "scan") {
  # scan in bin probabilities
  message("Next, identify bin PROBABILITIES.")
  message("Copy and paste a single column of energy bin probabilities or emission rates to screen. \n \n
      Then hit [enter] \n 
      Do not include column header. ")
  bin_prob <- scan()
  bin_prob
}
  # identify order of E_MeV
  sorted <- NaN #when not monotonically increasing or decreasing
  if(all(diff(E_MeV) > 0)) sorted <- "increasing"
  if(all(diff(E_MeV) < 0)) sorted <- "decreasing"
  if(is.na(sorted)) {
    message("The data does not seem to be sorted. \n A possible cause is data was pasted from a spreadsheet with an insufficient number of digits shown. \n")    
    stop("Energy data is neither monotonically increasing or decreasing. \n")
    
  } 
  
  # get extra bounding value if needed
  if (length(E_MeV) != (length(bin_prob) + 1)) {
     stop("There is a problem with the data. There should be one more energy entries (defining the minimum and maximum of each bin) than the number of bin probabilities. If you are copying from one column with minima or maxima for a bin, be sure to add the very smallest to the beginning or the very highest to the end.")
}

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # end of copy-and-paste portion
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # If data is not increasing, reverse it:
  if(sorted == "decreasing") {
    E_MeV <- E_MeV[length(E_MeV):1]
    bin_prob <- bin_prob[length(bin_prob):1]
  }
  
  if (is.null(my_dir)) my_dir <- getwd()
  #
  # construct table of energy bins with 5 columns
  E_MeV_raw <- E_MeV
  if (length(E_MeV) %% 5 != 0) {
    E_MeV <- c(E_MeV_raw, rep("$", 5 - length(E_MeV_raw) %% 5))
    E_MeV
  }

  E_MeV.m <- matrix(E_MeV, byrow = T, ncol = 5)
  E_MeV.out <- as.data.frame(E_MeV.m)
  col1 <- c("si#", rep("     ", length(E_MeV.out[, 1]) - 1))

  E_MeV.out <- cbind(col1, E_MeV.out)

  names(E_MeV.out) <- c(
    "c", "radsafer", "mcnp_si_sp_hist",
    "output ", "from ", as.character(Sys.Date())
  )

  if(write_permit == "y"){
  utils::write.table(E_MeV.out,
    file = paste0(my_dir, "/si_sp.txt"),
    append = TRUE,
    row.names = FALSE,
    quote = FALSE
  )
    }
  # print to screen
  prmatrix(E_MeV.m,
    rowlab = c("si#  ", rep(
      "     ",
      # Space over for every row after first
      # (full rows + partially filled row)
      as.numeric(length(E_MeV) %/% 5) + ((54 %% 5) > 0)
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
  message("\n")
  message(prob_sum)
  message("\n")
  message(paste0(
    "The output file, si.sp.hist.txt, is going to your working directory, ",
    my_dir, " but you can copy from the screen above instead."
  ))
  message("\n")
  E.avg <- fraction <- NULL # avoid no visible binding note
  # Make data frame for plotting
  spec.df <- data.frame("E.avg" = E_MeV_raw[1:(length(E_MeV_raw) - 1)] + c(diff(E_MeV_raw)), "fraction" = bin_prob_raw)

  # Plot spectrum - linear axes
p <- ggplot2::ggplot(data = spec.df, ggplot2::aes(E.avg, fraction)) + ggplot2::geom_line()

if (log_plot == 1) p <- p + ggplot2::scale_y_log10()

if (log_plot == 2) p <- p + ggplot2::scale_x_log10() + ggplot2::scale_y_log10()

p
}

