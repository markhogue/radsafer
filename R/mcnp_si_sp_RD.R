#' Produce MCNP source terms from ICRP 107 data except beta
#' @family mcnp tools
#' @seealso  [si_hist()] and [sp_hist()]  if radioactive emission data is available in histogram form and needs formatting for MCNP input.
#' @description Obtain emission data from the RadData package and write to a file for use with the radiation transport code, MCNP.
#' @param desired_RN Radionuclide in form Ba-137m
#' @param rad_type Radiation type, leave NULL if selecting photons or 
#' select from:  
#' 'X' for X-Ray 
#' 'G' for Gamma
#' 'AE' for Auger Electron
#' 'IE' for Internal Conversion Electron
#' 'A' for Alpha
#' 'AR' for Alpha Recoil
#' 'B-' for Beta Negative
#' 'AQ' for Annihilation Quanta
#' 'B+' for Beta Positive
#' 'PG' for Prompt Gamma
#' 'DG' for Delayed Gamma
#' 'DB' for Delayed Beta
#' 'FF' for Fission Fragment
#' 'N' for Neutron
#' @param photon 'Y' to select all rad_types that are photons
#' @param cut minimum energy defaults to 0
#' @param erg.dist energy distribution number for MCNP input
#' 
#' @return a text file, 'si.sp.dat' is written to working directory. 
#' If file already exists, it is appended. The file contains all 
#' emission energies in the si 'card' and the Line indicator, L is included,
#' e.g. si1  L  0.01 (showing a first energy of 0.01 MeV). 
#' This is followed by the emission probability of each si entry.
#' An additional text entry is made summing up the probabilities.
#' NA's may be included and require user deletion. They facilitate
#' writing the output in a convenient format.
#' 
#' @examples 
#' mcnp_si_sp_RD('Co-60', photon = TRUE, cut = 0.01, erg.dist = 13)
#' mcnp_si_sp_RD('Sr-90', rad_type = 'B-', cut = 0.01, erg.dist = 15)
#' mcnp_si_sp_RD('Am-241', rad_type = 'A', cut = 0.01, erg.dist = 23)
#' 
#' @export
mcnp_si_sp_RD <- function(desired_RN, rad_type = NULL, photon = FALSE, 
                           cut = 0, erg.dist = 1) {
  rt_allowed <- c("X", "G", "AE", "IE", "A", "AR", "B-", "AQ", "B+", "PG", "DG", "DB", "FF", "N")
  stop <- FALSE
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
    return
  }

  # end of argument checks~~~~~~~~~~~~~~~~
  
  # all betas use ICRP_07.BET others ICRP_07.RAD
  dat_set <- "R"
  if (!is.null(rad_type)) 
    if (rad_type %in% c("B-", "B+", "DB")) 
      dat_set <- "B"
  
  if (dat_set == "B") {
    si.sp <- RadData::ICRP_07.BET[which(RadData::ICRP_07.BET$RN == 
                                          desired_RN), ]
  }
  if (dat_set == "R") {
    si.sp <- RadData::ICRP_07.RAD[which(RadData::ICRP_07.RAD$RN == 
                                          desired_RN), ]
    if (photon == TRUE) 
      si.sp <- si.sp[which(si.sp$is_photon == TRUE), ]
    if (photon == FALSE) 
      si.sp <- si.sp[which(si.sp$code_AN == rad_type), ]
  }
  
  
  if (photon == TRUE) {
    si.sp <- RadData::ICRP_07.RAD[which(RadData::ICRP_07.RAD$RN == desired_RN), ]
    si.sp <- si.sp[which(si.sp$is_photon == TRUE), ]
  }
  # check for no matches
  if (is.na(si.sp[1, 1])) {
    oops <- "No matches"
    stop <- TRUE
  }
  if (stop) 
    return(oops)
  
  # apply cutoff
  si.sp <- si.sp[which(si.sp$E_MeV > cut), ]
  
  # Create matrix for formatting.
  add.NA <- function(n) (6 - (n%%6)) * ((n%%6) != 0)
  na.num <- add.NA(length(si.sp$E_MeV))
  
  # na.num <- 6 - (length(si.sp$E_MeV) %% 6)
  prob.sum <- ifelse(dat_set == "B", "see branching ratio", signif(sum(si.sp$prob, 
                                                                       5)))
  si <- as.data.frame(matrix(c(si.sp$E_MeV, rep(NA, na.num)), ncol = 6, byrow = TRUE))
  si$V7 <- c(rep("&", nrow(si) - 1), NA)
  si <- data.frame(si$V1, si$V2, si$V3, si$V4, si$V5, si$V6, si$V7)
  if (dat_set == "B") {
    sp <- as.data.frame(matrix(c(si.sp$A, rep(NA, na.num)), ncol = 6, 
                               byrow = TRUE))
  }
  if (dat_set == "R") {
    sp <- as.data.frame(matrix(c(si.sp$prob, rep(NA, na.num)), ncol = 6, byrow = TRUE))
  }
  sp$V7 <- c(rep("&", nrow(sp) - 1), NA)
  sp <- data.frame(sp$V1, sp$V2, sp$V3, sp$V4, sp$V5, sp$V6, sp$V7)
  # write output si output
  utils::write.table(data.frame(text = "c"), "si.sp.dat", col.names = FALSE, row.names = FALSE, append = TRUE, quote = FALSE)
  dist_type <- "L"
  if (dat_set == "B") 
    dist_type <- "A"
  r_type_text <- as.character(rad_type)
  if (photon == TRUE) 
    r_type_text <- "photon"
  utils::write.table(data.frame(text = paste0("si", erg.dist, dist_type, " & ", "$", desired_RN, ", radiation type= ", r_type_text)), "si.sp.dat", col.names = FALSE, row.names = FALSE, append = TRUE, quote = FALSE)
  utils::write.table(data.frame(text = paste0("c  energy cut off at ", cut, " MeV ")), "si.sp.dat", col.names = FALSE, row.names = FALSE, append = TRUE, quote = FALSE)
  readr::write_delim(data.frame(si), "si.sp.dat", col_names = FALSE, append = TRUE)
  # sp output
  utils::write.table(data.frame(text = "c"), "si.sp.dat", col.names = FALSE, 
              row.names = FALSE, append = TRUE, quote = FALSE)
  utils::write.table(data.frame(text = paste0("sp", erg.dist, " & ", "$", desired_RN, ", radiation type= ", r_type_text, " sum of probs = ", prob.sum)), "si.sp.dat", col.names = FALSE, row.names = FALSE, append = TRUE, quote = FALSE)
  readr::write_delim(data.frame(sp), "si.sp.dat", col_names = FALSE, append = TRUE)
}

#' MCNP histograms source energies
#' @description Make MCNP histogram energy bins cards for source definition if inputs happen to be available in histogram format.
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
