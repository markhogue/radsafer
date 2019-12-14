#'  Find a potential precursor of a radionuclide
#'  @description Find a potential parent radionclide by searching the progeny fields in RadData ICRP_07.NDX
#' @param RN_select identify the radionuclide of interest in the format "Es-254m"
#' @return a subset of the data frame RadData::ICRP_07.NDX
#' @examples 
#' RN_find_parent("Th-230")
#' RN_find_parent("Tl-208")
#' @export
RN_find_parent <- function(RN_select) {
  progeny_1 <- progeny_2 <- progeny_3 <- progeny_4 <- NULL
  # (avoids note on no visible binding of ggplot arg)
  RadData::ICRP_07.NDX %>% 
    dplyr::filter(progeny_1 %in% RN_select | progeny_2 %in% RN_select |
             progeny_3 %in% RN_select | progeny_4 %in% RN_select)
}
