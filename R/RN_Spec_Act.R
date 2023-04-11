#' Specific Activity
#'
#' @family radionuclides
#'
#' @description Provides specific activity of a radionuclide in Bq/g.
#' @param RN_select identify the radionuclide of interest in the format "Es-254m". For multiple specific activities, combine the radionuclides of interest in the form, c("At-219", "Es-251").
#' @param numeric default is "n" and a data frame is returned showing the radionuclide, its relative specific activity, and the units. If "y", or any other option is selected for the numeric parameter, specific activity results are delivered as numeric.
#' 
#' @return specific activity in Bq / g
#' @examples
#' RN_Spec_Act("Ac-230")
#' RN_Spec_Act(c("At-219", "Es-251"))
#' RN_Spec_Act("Pd-96", numeric = "y")
#' RN_Spec_Act(c("Cs-137", "Ba-137m"), numeric = "y")
#' @export

RN_Spec_Act <- function (RN_select, numeric = "n") 
{
  i <- which(RadData::ICRP_07.NDX$RN %in% RN_select)
  
  SA <- RadData::ICRP_07.NDX$decay_constant[i] * 
    6.0221409e+23 / RadData::ICRP_07.NDX$AMU[i]
  
  if(numeric !="n") {return(SA)}
  
  data.frame(RN = RN_select, SA = signif(SA, 6), Units = "Bq / g")
}
