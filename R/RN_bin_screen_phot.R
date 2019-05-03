#' Search for radioisotopes that dominate a specified energy bin
#' 
#' Search for photon emission spectra from representative radionuclides. 
#' Identify the bin of interest using E_min and E_max with optional min_prob.
#' If minimum probability for photons in the minimized ranges is not
#' identified, no screening will occur in the minimized ranges because
#' the default is 100 (greater than the maximum probability of any photon).
#' 
#' @family radionuclides
#' @seealso [RN_bin_screen_plot()]
#' 
#' @param E_min minimum energy in MeV, default = 0
#' @param E_max maximum energy in MeV, default = 10
#' @param min_prob minimum probability of selected bin with default = 0.
#' @param min_half_life_seconds minimum half-life in seconds. 
#'  Use multiplier as needed, e.g. 3 * 3600 for 3 hours. Default = NULL,
#' @param max_half_life_seconds maximum half-life. See min_half_life_seconds.
#' @param no_E_min,no_E_min2  minimum energy  in bins to minimize in MeV, default = 0
#' @param no_E_max,no_E_max2  maximum energy in bins to minimize in MeV, default = 10
#' @param no_min_prob,no_min_prob2 minimum probability to minimize with default = 100.
#'  
#' @importFrom rlang .data
#' 
#' @examples 
#' spec_0.1_0.3 <- RN_bin_screen_phot(E_min = 0.1, E_max = 0.3, 
#' min_prob = 0.4, min_half_life_seconds = 30 * 24 * 3600,
#' max_half_life_seconds = 3.153e7, no_E_min = 0.015, 
#' no_E_max = 0.0999, no_min_prob = 0.05, no_E_min2 = 0.301, no_E_max2 = 10, no_min_prob2 = 0.01)
#' 
#' @return search results in order of half-life. Recommend assigning
#' results to a viewable object, such as 'search_results'
#' 
#' @export
RN_bin_screen_phot <- function(E_min = 0, 
                               E_max = 10, 
                             min_prob = 0,
                           min_half_life_seconds = NULL,
                           max_half_life_seconds = NULL,
                           #screen out
                           no_E_min = 0, no_E_max = 10, 
                           no_min_prob = 100, 
                           no_E_min2 = 0, no_E_max2 = 10, 
                           no_min_prob2 = 100) {
  #screen in - photon in this range
  p <- RadData::ICRP_07.RAD %>% 
    dplyr::filter(.data$is_photon == TRUE) %>% 
    dplyr::filter(.data$E_MeV > E_min) %>% 
    dplyr::filter(.data$E_MeV < E_max) %>% 
    dplyr::filter(.data$prob > min_prob)
  #half-life search
  j <- dplyr::left_join(p[ , 1:4], RadData::ICRP_07.NDX[, c(1:4, 32)], 
                        by = "RN")
  dk_const <- function(half_life_seconds) log(2) / half_life_seconds
  if(!is.null(min_half_life_seconds)) {
    lambda_max <- dk_const(min_half_life_seconds)
    j <- j %>% dplyr::filter(.data$decay_constant < lambda_max)
    j
  }
  if(!is.null(max_half_life_seconds)) {
    lambda_min <- dk_const(max_half_life_seconds)
    j <- j %>% dplyr::filter(.data$decay_constant > lambda_min) 
    j
  }
  # screen out #1 - photons in this range
  no_list1 <- RadData::ICRP_07.RAD %>% 
    dplyr::filter(.data$RN %in% j$RN) %>% 
    dplyr::filter(.data$E_MeV > no_E_min) %>% 
    dplyr::filter(.data$E_MeV < no_E_max) %>% 
    dplyr::filter(.data$prob > no_min_prob) 
  # screen out #2 - photons in this range
  no_list2 <- RadData::ICRP_07.RAD %>% 
    dplyr::filter(.data$RN %in% j$RN) %>% 
    dplyr::filter(.data$E_MeV > no_E_min2) %>% 
    dplyr::filter(.data$E_MeV < no_E_max2) %>% 
    dplyr::filter(.data$prob > no_min_prob2) 
  # all photons in screened RN
  final <- RadData::ICRP_07.RAD %>% 
    dplyr::filter(.data$RN %in% j$RN) %>% 
    dplyr::filter(!.data$RN %in% no_list1$RN) %>% 
    dplyr::filter(!.data$RN %in% no_list2$RN) 
    final
}