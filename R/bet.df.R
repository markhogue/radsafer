#' @title Beta data from ICRP 107
#' 
#' @description Nuclear decay data for beta emission. This was obtained from the
#'   Radiological Toolbox, from Oak Ridge National Laboratory and the United
#'   States Nuclear Regulatory Commission. The data originated in ICRP
#'   Publication 107, and were prepared for that publication by 
#'   A. Endo of the Japan Atomic Energy Agency and 
#'   K. Eckerman of Oak Ridge National Laboratory (ORNL).
#' @format A tibble with three columns, which are: 
#' \describe{
#' \item{RN}{the radionuclide: atomic number - atomic mass}
#' \item{E_MeV}{energy bins in MeV}
#' \item{A}{energy distribution of given energy bin}
#' }
"bet.df"
