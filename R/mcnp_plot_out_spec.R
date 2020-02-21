#' Convert histogram data to average points and plot as spectrum.
#' @family mcnp tools
#' 
#' @seealso  \code{\link{mcnp_scan2spec}} to copy and paste output spectrum.
#' 
#' @description Model results or input source histograms from MCNP and perhaps 
#'   other sources typically provide binned tally results with columns representing
#'   maximum energy in MeV, a column with the mean tally result or bin probability 
#'   and an uncertainty column (not used). Once the data is scanned in, or otherwise 
#'   entered into the R global environment, they can be plotted with this function. 
#'   
#' @param spec.df A data frame with no header. Maximum energy in MeV should be
#'   in the first column, binned results in the second column.
#'   
#' @param title Title for chart (default = name of spec.df)
#' @param log_plot 0 = no log axes (default), 1  = log y-axis, 2 = log both axes.
#' @examples
#' mcnp_plot_out_spec(photons_cs137_hist, "example Cs-137 well irradiator")
#' @export
mcnp_plot_out_spec <- function(spec.df, title = deparse(substitute(spec.df)), log_plot = 0) {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package \"ggplot2\" needed for this function to work. Please install it.",
      call. = FALSE
    )
  }

  E_MeV <- prob <- NULL

    p <- ggplot2::ggplot(data = spec.df, ggplot2::aes(E_MeV, prob)) +
      ggplot2::geom_step(direction = 'vh') +
      ggplot2::ggtitle(paste0(title)) + 
      ggplot2::xlab("Energy, MeV") + 
      ggplot2::ylab("bin value") 

    if (log_plot == 1) p <- p + ggplot2::scale_y_log10()
    if (log_plot == 2) p <- p + ggplot2::scale_x_log10() + ggplot2::scale_y_log10()
    p
}
