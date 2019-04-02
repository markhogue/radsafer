#' Convert histogram data to average points and plot as spectrum.
#' @description Model results from MCNP in energy bins with   maximum energy in MeV in the first column and the mean result for the bin in the second column.
#' @param spec.df A data frame with no header. Maximum energy in MeV should be in the first column, binned results in the second column, uncertainty (optionally) in the third column.
#' @param rad_units Result units   
#' @param title Title for chart
#' @examples
#' library(ggplot2)
#' plot_spec_from_hist(photons_cs137_hist[1:16, ], "mR_h", "Example: Cs-137 with scatter")
#' @export
plot_spec_from_hist <- function(spec.df, rad_units, title) {
    if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package \"ggplot2\" needed for this function to work. Please install it.",
           call. = FALSE)
    }
  names(spec.df) <- c("E.avg", "fraction", "unc")
  spec.df$E.avg <- spec.df$E.avg - c(spec.df$E.avg[1], diff(spec.df$E.avg)) / 2
  spec.df$fraction <- spec.df$fraction / sum(spec.df$fraction)

  ggplot2::ggplot(data = spec.df, ggplot2::aes(spec.df$E.avg, spec.df$fraction)) +  
    ggplot2::geom_point(shape = 8) +
    ggplot2::geom_line(color = 'gray') +
    ggplot2::xlab("Energy, MeV") +
    ggplot2::ylab(paste0("relative ", rad_units)) + 
    ggplot2::ggtitle(paste0(title))
}


