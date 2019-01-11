#' beta input for MCNP  '
#' @description Make beta energy distribution for MCNP input '
#' @param desired_RN The radionuclide of interest in format element-isotope, 
#' followed by m if metastable. 
#' Must be in quotes, e.g. "Pa-234m"
#' @param erg_dist Energy distribution number. Defaults to 1. Helpful if several
#'   isotopes are used in a single MCNP input.
#' @return A text file, si.sp.dat, is written to the user's working file. It
#'   contains an energy distribution in a format compliant with MCNP. New data
#'   is appended to any exising data in the file if it already exists.
#' @examples
#' beta.si.sp("Sr-90", erg_dist = 11)
#' beta.si.sp("Y-90",  erg_dist = 13)
#' beta.si.sp("C-14",  erg_dist = 15)
#' @export 
beta.si.sp <- function(desired_RN, 
                  erg_dist = 1) {
  si.sp <- bet.df[bet.df$RN == desired_RN,]
  # How many blanks are there if we put this in a matrix?
  # Assume 6 columns of data plus the si with &
  add.NA <- function(n) (6 - (n %% 6)) * 
    ((n %% 6) != 0)
  na.num <- add.NA(length(si.sp$E_MeV))
  
  si <- as.data.frame(matrix(c(si.sp$E_MeV, rep(NA, na.num)),
                             ncol = 6, byrow = TRUE))
  si$V7 <- c(rep("&", nrow(si)-1), NA)
  si <- data.frame(si$V1, si$V2, si$V3, si$V4, si$V5, si$V6, si$V7)
  si
  sp <- as.data.frame(matrix(c(si.sp$A, rep(NA, na.num)),
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
              " A & ","$ ", desired_RN,
              ", radiation type = beta")),
              "si.sp.dat",
              col.names = FALSE, row.names = FALSE,
              append = TRUE, quote = FALSE)
  write.table(data.frame(si), "si.sp.dat",
              col.names = FALSE, row.names = FALSE,
              append = TRUE)
  # sp output
  write.table(data.frame("text" = "c"),
              "si.sp.dat",
              col.names = FALSE, row.names = FALSE,
              append = TRUE, quote = FALSE)
  write.table(data.frame("text" = paste0("sp", erg_dist, " D & ","$ ", desired_RN,
              ", radiation type = beta")),
              "si.sp.dat",
              col.names = FALSE, row.names = FALSE,
              append = TRUE, quote = FALSE)
  write.table(data.frame(sp), "si.sp.dat",
              col.names = FALSE, row.names = FALSE,
              append = TRUE)
}


