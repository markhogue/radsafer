#' Convert histogram data to average points and plot as spectrum.
#' @family mcnp tools
#' @seealso  \code{\link{scan2spec.df}} to copy and paste output spectrum.
#' @description Model results from MCNP and perhaps other sources typically
#'   provide binned tally results with columns representing maximum energy in
#'   MeV, a column with the mean tally result titled 'mean' and an uncertainty
#'   column titled 'R'.
#' @param spec.df A data frame with no header. Maximum energy in MeV should be
#'   in the first column, binned results in the second column, uncertainty in
#'   the third column.
#' @param title Title for chart
#' @param log_axes TRUE for both axes logarithmic
#' @examples
#' mcnp_plot_out_spec(photons_cs137_hist, "example Cs-137 well irradiator")
#' @export
mcnp_plot_out_spec <- function(spec.df, title, log_axes = FALSE) {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package \"ggplot2\" needed for this function to work. Please install it.",
      call. = FALSE
    )
  }

  E.avg <- fraction <- NULL

  names(spec.df) <- c("E.avg", "fraction", "unc")

  spec.df$E.avg <- spec.df$E.avg - c(spec.df$E.avg[1], diff(spec.df$E.avg)) / 2

  spec.df$fraction <- spec.df$fraction / sum(spec.df$fraction)

  if (log_axes == TRUE) {
    p <- ggplot2::ggplot(data = spec.df, ggplot2::aes(E.avg, fraction)) +

      ggplot2::geom_line() + ggplot2::ggtitle(paste0(title)) +

      ggplot2::scale_x_log10() + ggplot2::scale_y_log10()

    p
  }

  if (log_axes == FALSE) {
    p <- ggplot2::ggplot(data = spec.df, ggplot2::aes(E.avg, fraction)) +

      ggplot2::geom_line() + ggplot2::ggtitle(paste0(title))

    p
  }

  p
}
