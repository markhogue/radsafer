#' Search for photon
#'
#' Search for photon emission based on energy, half-life and minimum probability.
#'
#' @family radionuclides
#'
#' @seealso [RN_plt()]
#'
#' @param E_min minimum energy in MeV, default = 0
#' @param E_max maximum energy in MeV, default = 10
#' @param min_half_life_seconds minimum half-life in seconds.
#'  Use multiplier as needed, e.g. 3 * 3600 for 3 hours. Default = NULL,
#' @param max_half_life_seconds maximum half-life. See min_half_life_seconds.
#' @param min_prob minimum probability with default = 0.
#'
#' @importFrom rlang .data
#'
#' @examples
#' # between 1 and 1.2 MeV, between 6 and 6.2 hours half-life,
#' # ... probability at least 1e-4
#' search_results <- RN_search_phot_by_E(1, 1.2, 6 * 3600, 6.2 * 3600, 1e-4)
#'
#' # between 0.1 and 0.15 MeV, between 1 and 3 million years half-life
#' search_results <- RN_search_phot_by_E(0.1, 0.15, 1e6 * 3.153e7, 3e6 * 3.153e7)
#' @return search results in order of half-life. Recommend assigning
#' results to a viewable object, such as 'search_results'
#'
#' @export
RN_search_phot_by_E <- function(E_min = 0, E_max = 10,
                             min_half_life_seconds = NULL,
                             max_half_life_seconds = NULL,
                             min_prob = 0) {
  # photon search
  p <- RadData::ICRP_07.RAD %>%
    dplyr::filter(.data$is_photon == TRUE) %>%
    dplyr::filter(.data$E_MeV > E_min) %>%
    dplyr::filter(.data$E_MeV < E_max) %>%
    dplyr::filter(.data$prob > min_prob)
  # half-life search
  j <- dplyr::left_join(p[, 1:4], RadData::ICRP_07.NDX[, c(1:3, 32)], by = "RN")
  dk_const <- function(half_life_seconds) log(2) / half_life_seconds
  if (!is.null(min_half_life_seconds)) {
    lambda_max <- dk_const(min_half_life_seconds)
    j <- j %>% dplyr::filter(.data$decay_constant < lambda_max)
    j
  }
  if (!is.null(max_half_life_seconds)) {
    lambda_min <- dk_const(max_half_life_seconds)
    j <- j %>% dplyr::filter(.data$decay_constant > lambda_min)
    j
  }
  j[order(j$decay_constant, decreasing = TRUE), ]
}
