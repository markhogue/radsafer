#' Plot radionuclide emission spectra.
#'
#' Plot emission spectra based on radionuclide and desired radiation type.
#' Plot on log axes if desired.
#' Select cutoff value for probability optional, included at 1% by default.
#' Plot includes energy times probability for dosimetric importance comparisons.
#'
#' @family radionuclides
#'
#' @param desired_RN Radionuclide in form "Ba-137m"
#' @param rad_type Radiation type, leave NULL if selecting photons or
#' select from:
#' 
#' 'X' for X-Ray
#' 
#' 'G' for Gamma
#' 
#' 'AE' for Auger Electron
#' 
#' 'IE' for Internal Conversion Electron
#' 
#' 'A' for Alpha
#' 
#' 'AR' for Alpha Recoil
#' 
#' 'B-' for Beta Negative
#' 
#' 'AQ' for Annihilation Quanta
#' 
#' 'B+' for Beta Positive
#' 
#' 'PG' for Prompt Gamma
#' 
#' 'DG' for Delayed Gamma
#' 
#' 'DB' for Delayed Beta
#' 
#' 'FF' for Fission Fragment
#' 
#' 'N' for Neutron
#' 
#' @param photon Use only if you do not specify `rad_type`. 
#' TRUE will select all rad_types that are photons. 
#' Note that if you select `rad_type = "G"`, for example, you 
#' will not get X-rays or Annihilation Quanta (the 0.511 MeV
#' photon from pair annihilation).
#' @param prob_cut minimum probability defaults to 0.01
#' @param log_plot 0 = no log axes, 
#' 
#' 1 (default) = log y-axis, 
#' 
#' 2 = log both axes. 
#' 
#' This argument is ignored for B- plots.
#'
#' @examples
#' RN_plot_spectrum(
#'   desired_RN = c("Sr-90", "Y-90"), rad_type = "B-",
#'   photon = FALSE, prob_cut = 0.01
#' )
#' RN_plot_spectrum(
#'   desired_RN = c("Co-60", "Ba-137m"), rad_type = NULL,
#'   photon = TRUE, prob_cut = 0.015
#' )
#' RN_plot_spectrum(
#'   desired_RN = c("Co-60", "Ba-137m"), rad_type = NULL,
#'   photon = TRUE, log_plot = 0
#' )
#' RN_plot_spectrum(desired_RN = c("Co-60", "Ba-137m"), rad_type = "G")
#' RN_plot_spectrum(
#'   desired_RN = c("Pu-238", "Pu-239", "Am-241"), rad_type = "A",
#'   photon = FALSE, prob_cut = 0.01, log_plot = 0
#' )
#' @return plot of spectrum
#'
#' @export
RN_plot_spectrum <- function(desired_RN,
                             rad_type = NULL,
                             photon = FALSE,
                             log_plot = 0,
                             prob_cut = 0.01) {
  rt_allowed <- c("X", "G", "AE", "IE", "A", "AR", "B-", "AQ", "B+", "PG", "DG", "DB", "FF", "N")
  stop_flag <- FALSE
  # Checks for valid arguments~~~~~~~~~~~~~~ Is rad_type valid?
  if (!is.null(rad_type)) {
    if (!rad_type %in% rt_allowed) {
      cat("Invalid specification for rad_type.\n")
      cat("Please enter one of these: \n")
      cat(rt_allowed)
      cat(" (in quotes) or NULL and select photon = TRUE")
    }
  }
  # Are both rad_type and photon selected?
  if (!is.null(rad_type) & photon == TRUE) {
    cat("Enter either rad_type = 'a rad_type', or photon = TRUE, but not both.")
    return()
  }
 if(!is.logical(photon)){
   cat("photon must be TRUE or FALSE. (T or F also work)")
   return()
 }
  # end of argument checks~~~~~~~~~~~~~~~~

  # all betas use ICRP_07.BET others ICRP_07.RAD
  dat_set <- "R"
  if (!is.null(rad_type)) {
    if (rad_type %in% c("B-", "B+", "DB")) {
      dat_set <- "B"
    }
  }

  if (dat_set == "B") {
    spec_df <- RadData::ICRP_07.BET[which(RadData::ICRP_07.BET$RN %in% desired_RN), ]
  }

  if (dat_set == "R") {
    spec_df <- RadData::ICRP_07.RAD[which(RadData::ICRP_07.RAD$RN %in%
      desired_RN), ]

    if (photon == TRUE) {
      spec_df <- spec_df[which(spec_df$is_photon == TRUE), ]
    }


    if (photon == FALSE) {
      spec_df <- spec_df[which(spec_df$code_AN == rad_type), ]
    }
  }


  if (photon == TRUE) {
    spec_df <- RadData::ICRP_07.RAD[which(RadData::ICRP_07.RAD$RN %in% desired_RN), ]

    spec_df <- spec_df[which(spec_df$is_photon == TRUE), ]
  }

  # check for no matches
  if (is.na(spec_df[1, 1])) {
    oops <- "No matches"
    stop_flag <- TRUE
  }
  if (stop_flag) {
    return(oops)
  }


  E_MeV <- prob <- RN <- MeV_per_dk <- A <- NULL

  # apply cutoff
  if (dat_set != "B") spec_df <- spec_df[which(spec_df$prob > prob_cut), ]

  # size guide
  if (dat_set != "B") spec_df$MeV_per_dk <- spec_df$prob * spec_df$E_MeV


  spec_text <- ifelse(length(desired_RN) > 1, "spectra", "spectrum")
  # (avoids note on no visible binding of ggplot arg)
  if (dat_set != "B") {
    if (photon == TRUE) rad_text <- "photon"
    if (photon != TRUE) rad_text <- RadData::rad_codes$description[which(RadData::rad_codes$code_AN == rad_type)]

    # plot all but beta -------------------------------------------------------

    p <- ggplot2::ggplot(
      data = spec_df,
      ggplot2::aes(E_MeV, prob, color = RN, shape = RN) # linetype = RN, fill = RN,
    ) +
      ggplot2::geom_segment(ggplot2::aes(xend = E_MeV, yend = 0)) +
      ggplot2::geom_point(size = 3) +
      ggplot2::scale_colour_hue(l = 80, c = 150) +
      ggplot2::ggtitle(paste0("Emission ", spec_text, ": ", rad_text),
        subtitle = paste0("particle probability > ", prob_cut)
      ) +
      ggthemes::theme_calc() +
      ggplot2::xlab("Energy, MeV") + 
      ggplot2::ylab("probability density") 
    
      # ggplot2::guides( # fill = ggplot2::guide_legend(title = "radionuclide", size = 2),
      #   color = ggplot2::guide_legend(title = "radionuclide", size = 2),
      #   shape = ggplot2::guide_legend(title = "radionuclide", size = 2)
     

    if (log_plot == 1) p <- p + ggplot2::scale_y_log10()
    if (log_plot == 2) p <- p + ggplot2::scale_x_log10() + ggplot2::scale_y_log10()
    p
  }

  # beta plot ---------------------------------------------------------------


  if (dat_set == "B") {
    p <- ggplot2::ggplot(
      data = spec_df,
      ggplot2::aes(E_MeV, A, color = RN, shape = RN)
    ) +
      ggthemes::theme_calc() +
      ggplot2::xlab("Energy, MeV") +
      ggplot2::ylab("probability density") +
      ggplot2::geom_line(size = 1.5) +
      ggplot2::scale_colour_hue(l = 80, c = 150) +
      ggplot2::ggtitle(RadData::rad_codes$description[which(RadData::rad_codes$code_AN == rad_type)])
    if (log_plot == 1) p <- p + ggplot2::scale_y_log10()
    if (log_plot == 2) p <- p + ggplot2::scale_x_log10() + ggplot2::scale_y_log10()
  }
  p
}
