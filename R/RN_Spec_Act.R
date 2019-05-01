#' Specific Activity
#' 
#' @family radionuclides
#' 
#' @description Provides specific activity of a radionucide in Bq/g.
#' 
#' @param RN_select identify the radionuclide of interest in the format "Es-254m"
#' @return specific activity in Bq / g
#' @examples 
#' RN_Spec_Act("Ac-230")
#' RN_Spec_Act("At-219")
#' RN_Spec_Act("Es-251")
#' RN_Spec_Act("Pd-96")
#' RN_Spec_Act("Te-117")
#' RN_Spec_Act("Ba-137m")
#' @export

RN_Spec_Act <- function(RN_select) {
  i <- which(RadData::ICRP_07.NDX$RN == RN_select)
  SA <- RadData::ICRP_07.NDX$decay_constant[i] * 6.0221409e+23 / RadData::ICRP_07.NDX$AMU[i]
  data.frame("SA" = signif(SA, 6), "Units" = "Bq / g", row.names = "")
}
