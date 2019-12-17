#' Screen radionuclide data to find matches to decay mode, half-life, and total emission energy
#'
#' @description Provides a set of radionuclides matching screening criteria. This is a limited screening based on average energy per transformation. Consider [search_phot_by_E], [search_alpha_by_E], and [search_beta_by_E] for spectroscopic measurement matching. For best results, assign results to a named object, then view the object.
#'
#' @family radionuclides
#'
#' @param dk_mode default = NULL
#' #' select from:
#' 'A' for Alpha
#' 'B-' for Beta Negative
#' 'B+' for Beta Positive
#' 'EC' for Electron Capture
#' 'IT' for Isomeric Transition
#' 'SF' for Spontaneous Fission
#' @param min_half_life_seconds default = NULL. If half-life is known in units other than seconds, enter with conversion factor, e.g. for 15 minutes, enter min_half_life_seconds = 15 * 60.
#' @param max_half_life_seconds default = NULL. If half-life is known in units other than seconds, enter with conversion factor, e.g. for 30 minutes, enter max_half_life_seconds = 30 * 60.
#' @param min_E_alpha default = NULL. This will be used to screen the index for average alpha energy per decay, including all decay branches.
#' @param min_E_electron default = NULL. This will be used to screen the index for average electron energy per decay, including all decay branches.
#' @param min_E_photon default = NULL. This will be used to screen the index for average photon energy per decay, including all decay branches.
#' @return data frame of radionuclide data from the RadData package index data (RadData::ICRP_07.NDX), matching search criteria.
#' @examples
#' RNs_selected <- RN_index_screen(dk_mode = "SF")
#' RNs_selected <- RN_index_screen(dk_mode = "IT", max_half_life_seconds = 433 * 3.15e7)
#' @export
RN_index_screen <-
  function(dk_mode = NULL,
           min_half_life_seconds = NULL,
           max_half_life_seconds = NULL,
           min_E_alpha = NULL,
           min_E_electron = NULL,
           min_E_photon = NULL) {
    RNs_selected <- RadData::ICRP_07.NDX
    # filter by decay mode
    if (!is.null(dk_mode)) {
      RNs_selected <- RNs_selected[which(stringr::str_detect(RNs_selected$decay_mode, dk_mode)), ]
    }

    # filter by half-life
    dk_const <- function(half_life_seconds) log(2) / half_life_seconds
    if (!is.null(min_half_life_seconds)) {
      lambda_max <- dk_const(min_half_life_seconds)
      RNs_selected <- RNs_selected[which(RNs_selected$decay_constant < lambda_max), ]
    }
    if (!is.null(max_half_life_seconds)) {
      lambda_min <- dk_const(max_half_life_seconds)
      RNs_selected <- RNs_selected[which(RNs_selected$decay_constant > lambda_min), ]
    }

    # filter by total alpha energy per decay
    if (!is.null(min_E_alpha)) {
      RNs_selected <- RNs_selected[which(RNs_selected$E_alpha > min_E_alpha), ]
    }

    # filter by total electron energy per decay
    if (!is.null(min_E_electron)) {
      RNs_selected <- RNs_selected[which(RNs_selected$E_electron > min_E_electron), ]
    }

    # filter by total photon energy per decay
    if (!is.null(min_E_photon)) {
      RNs_selected <- RNs_selected[which(RNs_selected$E_photon > min_E_photon), ]
    }
    RNs_selected[order(RNs_selected$decay_constant, decreasing = TRUE), ]
  }
