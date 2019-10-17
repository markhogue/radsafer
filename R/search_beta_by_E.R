#' Search for beta
#'
#' Search for beta emission based on maximum energy and half-life.
#'
#' @family radionuclides
#'
#' @seealso [RN_plt()]
#'
#' @param E_max maximum energy in MeV, default = 10
#' @param min_half_life_seconds minimum half-life in seconds.
#'  Use multiplier as needed, e.g. 3 * 3600 for 3 hours. Default = NULL,
#' @param max_half_life_seconds maximum half-life. See min_half_life_seconds.
#'
#' @importFrom rlang .data
#'
#' @examples
#' # Max beta at least 2 MeV
#' search_results <- search_beta_by_E(2)
#' # Max beta at least 2 MeV and half-life between 1 s and 1 h
#' search_results <- search_beta_by_E(2, 1, 3600)
#'
#' # Max beta at least 1 MeV and half-life between 1 d and 2 d
#' search_results <- search_beta_by_E(1, 3600 * 24, 2 * 3600 * 24)
#' @return search results in order of half-life. Recommend assigning
#' results to a viewable object, such as 'search_results'
#'
#' @export
search_beta_by_E <- function(E_max,
                             min_half_life_seconds = NULL,
                             max_half_life_seconds = NULL) {
  # beta search
  b_sum <- RadData::ICRP_07.BET %>%
    dplyr::group_by(.data$RN) %>%
    dplyr::summarise(E_max = max(.data$E_MeV))

  # half-life search
  j <- dplyr::left_join(b_sum, RadData::ICRP_07.NDX[, c(1:3, 32)], by = "RN")
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
