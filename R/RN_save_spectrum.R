#' Save radionuclide emission spectra.
#'
#' Save emission spectra based on radionuclide and desired radiation type.
#' Select cutoff value for probability optional, included at 1% by default.
#'
#' @family radionuclides
#'
#' @inheritParams RN_plot_spectrum
#'
#' @examples
#' Sr_Y_90_df <- RN_save_spectrum(desired_RN = c("Sr-90", "Y-90"), rad_type = "B-", 
#' photon = FALSE, prob_cut = 0.01)
#' Co_60_Ba_137m_p_df <- RN_save_spectrum(desired_RN = c("Co-60", "Ba-137m"), rad_type = NULL, 
#' photon = TRUE, prob_cut = 0.015)
#' Co_60_Ba_137m_g_df <- RN_save_spectrum(desired_RN = c("Co-60", "Ba-137m"), rad_type = "G")
#' actinide_a_df <- RN_save_spectrum(desired_RN = c("Pu-238", "Pu-239", "Am-241"), rad_type = "A",
#' photon = FALSE, prob_cut = 0.01)
#' @return Dataframe with energy spectra - including probability of emission quantum, or, for 
#' beta, the probability density.
#'
#' @export
RN_save_spectrum <- function(desired_RN,
                             rad_type = NULL,
                             photon = FALSE,
                             prob_cut = 0) {
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
      spec_df <- spec_df[which(spec_df$code_AN == rad_type), c(1, 3, 4)]
    }
  }
  
  
  if (photon == TRUE) {
    spec_df <- RadData::ICRP_07.RAD[which(RadData::ICRP_07.RAD$RN %in% desired_RN), ]
    
    spec_df <- spec_df[which(spec_df$is_photon == TRUE), c(1, 3, 4)]
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
  
  spec_df 
}
