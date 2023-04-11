#' @title File Description:

#' @description This data file was generated in MCNP from a model of Gamma Well Irradiator
#' with no attenuator in place. MCNP will include in the output a histogram of
#' tally results when there is an E Tally Energy card. Results in the output up
#' to MCNP version 6 have no headers, but the columns are:
#'
#' @format A `data.frame`
#' \describe{
#' \item{E_max}{Maximum Energy in MeV}
#' \item{bin_tally}{Tally result for this bin}
#' \item{R}{Monte Carlo uncertainty for this bin}
#' }
"photons_cs137_hist"
