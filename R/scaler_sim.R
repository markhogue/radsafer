#' Count Room Scaler Simulation
#' @description Returns a plotted distribution of results for a scaler model
#'   based on the Poisson distribution. Inputs and outputs in counts per minute.
#' @family rad measurements
#' @param true_bkg  True background count rate in counts per minute.
#' @param true_samp True sample count rate in counts per minute.
#' @param ct_time Count time in minutes.
#' @param trials Number of sample values, default = 1e5.
#' @return A histogram of all trial results including limits for +/- 1 standard
#'   deviation.
#' @examples
#' scaler_sim(true_bkg = 5, true_samp = 10, ct_time = 1, trials = 1e5)
#' scaler_sim(true_bkg = 50, true_samp = 30, ct_time = 1, trials = 1e5)
#' @export


scaler_sim <- function(true_bkg, true_samp, ct_time, trials = 1e5) {
  df <- data.frame(
    "bkg" = stats::rbinom(trials, trials, true_bkg / trials),
    "samp" = stats::rbinom(trials, trials, true_samp / trials)
  )
  bkg <- samp <- sd <- gross <- NULL # appeasing R CMD check -  avoid note on no visible binding of ggplot arg
  df <- df %>% dplyr::mutate(gross = bkg + samp)
  sd_gross <- sd(df$gross)
  ggplot2::ggplot(df, ggplot2::aes(gross)) +
    ggplot2::geom_histogram(
      color = "#64123B",
      fill = "#FDCB44", binwidth = 1
    ) +
    ggplot2::geom_vline(
      xintercept = true_bkg + true_samp + c(sd_gross, -sd_gross),
      linetype = 2, color = "limegreen", size = 1.1
    ) +
    ggplot2::geom_vline(
      xintercept = true_bkg + true_samp +
        c(2 * sd_gross, -2 * sd_gross),
      linetype = 3, color = "darkgreen", size = 1.1
    ) +
    ggplot2::ggtitle(paste0(
      "gross counts in ", ct_time,
      " min., true_bkg = ",
      true_bkg, " cpm, true_samp = ", true_samp, " cpm"
    )) +
    ggplot2::xlab("gross counts (shown with vertical lines for  +/- 1 and 2 sd)")
}
