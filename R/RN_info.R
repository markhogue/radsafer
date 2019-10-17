#' Quick table of Radionuclide Data from the RadData package
#'
#' @family radionuclides
#'
#' @description Access a quick summary of radionuclide data. This is for convenience only and does not replace a more comprehensive view as is available in the Radiological Toolbox <doi:10.2172/1201298>
#'
#' @param RN_select identify the radionuclide of interest in the format "Es-254m"
#' @return a table including half-life, decay modes, decay progeny, and branch fractions
#' @examples
#' RN_info("Es-254m")
#' RN_info("Cf-252")
#' RN_info("Cs-137")
#' RN_info("Am-241")
#' @export
RN_info <- function(RN_select) {
  i <- which(RadData::ICRP_07.NDX$RN == RN_select)
  data <- RadData::ICRP_07.NDX[i, ]
  df <- data.frame(data[, 1:4], row.names = "")
  print(df)
  df <- data.frame(
    "Decays_to" = data$progeny_1,
    "branch_fraction" = data$branch_1,
    row.names = ""
  )
  print(df)
  if (!is.na(data$progeny_2)) {
    df <- data.frame(
      "Decays_to" = data$progeny_2,
      "branch_fraction" = data$branch_2,
      row.names = ""
    )
    print(df)
  }
  if (!is.na(data$progeny_3)) {
    df <- data.frame(
      "Decays_to" = data$progeny_3,
      "branch_fraction" = data$branch_3,
      row.names = ""
    )
    print(df)
  }
  if (!is.na(data$progeny_4)) {
    df <- data.frame(
      "Decays_to" = data$progeny_4,
      "branch_fraction" = data$branch_,
      row.names = ""
    )
    print(df)
  }
}
