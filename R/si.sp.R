#' source emission data - other than beta for MCNP  '
#' @description Make energy distribution for MCNP input '
#' @param desired_RN The radionuclide of interest in format element-isotope,
#'   followed by m if metastable. Must be in quotes, e.g. "Ba-137m"
#' @param rad_code Enter "P" for all photons. Other options are: "G" = Gamma
#'   "PG" = Prompt Gamma "DG" = Delayed Gamma "X" = X-Ray "B+" = Beta Positive
#'   "AQ" = Annihilation Quanta "B-" = Beta Negative (Only includes average
#'   energy use beta.si.sp for beta distribution) "DB" = Delayed Beta "IE" =
#'   Internal Conversion Electron "AE" = Auger Electron "A" = Alpha "AR" = Alpha
#'   Recoil "FF" = Fission Fragment "N" = Neutron
#' @param erg_dist Energy distribution number. Defaults to 1. Helpful if several
#'   isotopes are used in a single MCNP input.
#' @param E_min Energy cutoff, default = 0. Provided because running very low
#'   energy photons may be costly in run time without any addition to dose rate
#'   in a shielding calculation, for example.
#' @return A text file, si.sp.dat, is written to the user's working file. It
#'   contains an energy distribution in a format compliant with MCNP. New data
#'   is appended to any exising data in the file if it already exists.
#' @examples
#' si.sp("Pu-238", rad_code = "P", E_min = 0, erg_dist = 11)
#' si.sp("Am-241", rad_code = "A", E_min = 0, erg_dist = 23)
#' @export
si.sp <- function(desired_RN, rad_code, 
                  E_min = 0, erg_dist = 1) {
  if (rad_code == "P") {
    si.sp <- RN.df[which(RN.df$RN == desired_RN
                         & RN.df$short_code == "P"
                         & RN.df$E_MeV > E_min), ]
  } else { si.sp <- RN.df[which(RN.df$RN == desired_RN
                      & RN.df$code_AN == rad_code
                      & RN.df$E_MeV > E_min), ]
  }
  
  # How many blanks are there if we put this in a matrix?
  # Assume 6 columns of data plus the si with &
  add.NA <- function(n) (6 - (n %% 6)) * 
    ((n %% 6) != 0)
  na.num <- add.NA(length(si.sp$E_MeV))
  prob.sum <- sum(si.sp$prob)
  si <- as.data.frame(matrix(c(si.sp$E_MeV, rep(NA, na.num)),
                             ncol = 6, byrow = TRUE))
  si$V7 <- c(rep("&", nrow(si)-1), NA)
  si <- data.frame(si$V1, si$V2, si$V3, si$V4, si$V5, si$V6, si$V7)
  si
  sp <- as.data.frame(matrix(c(si.sp$prob, rep(NA, na.num)),
                             ncol = 6, byrow = TRUE))
  sp$V7 <- c(rep("&", nrow(sp)-1), NA)
  sp <- data.frame(sp$V1, sp$V2, sp$V3, sp$V4, sp$V5, sp$V6, sp$V7)
  sp
  # print output
  # si output
  write.table(data.frame("text" = "c"),
              "si.sp.dat",
              col.names = FALSE, row.names = FALSE,
              append = TRUE, quote = FALSE)
  write.table(data.frame("text" = paste0("si", erg_dist, 
              " L & ","$", desired_RN, 
              ", radiation type= ", rad_code)),
              "si.sp.dat",
              col.names = FALSE, row.names = FALSE,
              append = TRUE, quote = FALSE)
  write.table(data.frame("text" = paste0("c  energy E_min = ",
              E_min, " MeV ")),
              "si.sp.dat",
              col.names = FALSE, row.names = FALSE,
              append = TRUE, quote = FALSE)
  write.table(data.frame(si), "si.sp.dat",
              col.names = FALSE, row.names = FALSE, append = TRUE)
  # sp output
  write.table(data.frame("text" = "c"),
              "si.sp.dat",
              col.names = FALSE, row.names = FALSE,
              append = TRUE, quote = FALSE)
  write.table(data.frame("text" = paste0("sp", erg_dist, " & ","$", desired_RN, 
              ", radiation type= ", rad_code," sum of probs = ",
              signif(prob.sum,5))),
              "si.sp.dat",
              col.names = FALSE, row.names = FALSE,
              append = TRUE, quote = FALSE)
  write.table(data.frame(sp), "si.sp.dat",
              col.names = FALSE, row.names = FALSE, append = TRUE)
  # separate file for probability sums
  write.table(data.frame("text" = 
              paste0("c   ", "Prob sum for dist#: ", erg_dist, ": ")),
              "dist.sum.dat",
              col.names = FALSE, row.names = FALSE,
              append = TRUE, quote = FALSE)
  write.table(data.frame("text" = paste0("     ", signif(prob.sum,5))),
              "dist.sum.dat",
              col.names = FALSE, row.names = FALSE,
              append = TRUE, quote = FALSE)
}


