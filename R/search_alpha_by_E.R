#' Search for alpha
#'
#' Search for alpha emission based on energy, half-life and minimum probability.
#'
#' @family radionuclides
#'
#' @inheritParams search_phot_by_E
#'
#' @seealso [RN_plt()]
#'
#' @importFrom rlang .data
#' @examples
#' # between 7 and 8 MeV
#' search_results <- search_alpha_by_E(7, 8)
#'
#' # 1-4 MeV; half-life between 1 and 4 hours
#' search_results <- search_alpha_by_E(1, 4, 1 * 3600, 4 * 3600)
#'
#' # between 7 and 10 MeV with at least 1e-3 probability
#' search_results <- search_alpha_by_E(7, 10, min_prob = 1e-3)
#' @return search results in order of half-life. Recommend assigning
#' results to a viewable object, such as 'search_results'
#'
#' @export
search_alpha_by_E <- function(E_min = 0,
                              E_max = 10,
                              min_half_life_seconds = NULL,
                              max_half_life_seconds = NULL,
                              min_prob = 0) {
  .Deprecated(RN_search_alpha_by_E)
  # alpha search
  p <- RadData::ICRP_07.RAD %>%
    dplyr::filter(.data$code_AN == "A") %>%
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
