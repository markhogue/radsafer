#' Convert histogram data to average points and plot as spectrum.
#' @description Model results from MCNP and perhaps other sources typically
#'   provide binned tally results with columns representing maximum energy in
#'   MeV, a column with the mean tally result titled "mean" and an uncertainty
#'   column titled "R".
#' @param spec.df A data frame with no header. Maximum energy in MeV should be
#'   in the first column, binned results in the second column, uncertainty in
#'   the third column.
#' @param title Title for chart
#' @examples
#' library(ggplot2)
#' plot_spec_from_hist(photons_cs137_hist, "example Cs-137 well irradiator")
#' @export
plot_spec_from_hist <- function(spec.df, title) {
    if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package \"ggplot2\" needed for this function to work. Please install it.",
           call. = FALSE)
    }
  names(spec.df) <- c("E.avg", "fraction", "unc")
  spec.df$E.avg <- spec.df$E.avg - c(spec.df$E.avg[1], diff(spec.df$E.avg)) / 2
  spec.df$fraction <- spec.df$fraction / sum(spec.df$fraction)

  ggplot2::ggplot(data = spec.df, ggplot2::aes(E.avg, fraction)) +  ggplot2::geom_line() +
    ggplot2::ggtitle(paste0(title))
}


