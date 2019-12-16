#' Quick plot to radionuclide emission data screens.
#'
#' Plots with ggplot2 with geom_point and log y-scale.
#' Useful for a small set of radionuclides.
#' The point of this is to make it easy to get the plot
#' by entering only the data frame name.
#'
#' @family radionuclides
#'
#' @param df data frame of results including RN (radionuclide),
#'  energy in E_MeV and probability (prob) of photon.
#'
#' @examples
#' RN_plt(spec_0.1_0.3)
#' @return plot of spectrum
#'
#' @export
RN_plt <- function(df) {
  E_MeV <- prob <- RN <- NULL
  # (avoids note on no visible binding of ggplot arg)
  ggplot2::ggplot(
    data = df,
    ggplot2::aes(E_MeV, prob, color = RN, shape = RN)
  ) +
    ggplot2::geom_point(alpha = 0.7) +
    ggplot2::scale_y_log10()
}
