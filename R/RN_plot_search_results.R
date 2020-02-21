#' Plot results of RN_search functions
#' 
#' @family radionuclides
#' 
#' @seealso  Use \code{\link{RN_search_alpha_by_E}}, \code{\link{RN_search_beta_by_E}}, 
#' or \code{\link{RN_search_phot_by_E}} and save the results, 
#' e.g. save_results <- RN_search_phot_by_E(0.99, 1.01, 13 * 60, 15 * 60, 1e-4)
#' 
#' @description Plots results by radionuclide with E_MeV on x-axis and prob on y-axis. 
#'   
#' @param discrete_df A data frame results from a `radsafer` search function. Columns must
#' include RN, E_MeV, and prob, and code_AN.
#'   
#' @param title Title for chart (default = name of search_results)
#' @param log_plot 0 = no log axes (default), 1  = log y-axis, 2 = log both axes.
#' @examples
#' search_results <- RN_search_phot_by_E(0.99, 1.01, 13 * 60, 15 * 60, 1e-4)
#' RN_plot_search_results(search_results, title = "example1", log_plot = 0)
#' @export
RN_plot_search_results <- function(discrete_df, 
                                   title = deparse(substitute(discrete_df)), 
                                   log_plot = 0) {

    E_MeV <- prob <- RN <- code_AN <- A <-  NULL
    
    # check for empty dataframe
    if(is.na(discrete_df$code_AN[1])) stop("Search results are empty")
  
    rad_text <- dplyr::case_when(code_AN %in% c("B-", "B+", "DB") ~ "beta",
                               code_AN %in% c("X", "G", "AQ","PG", "DG") ~ "photon",
                               code_AN == "A" ~ "alpha",
                               TRUE ~ "NA")
  
  # plot all but beta -------------------------------------------------------
if(!discrete_df$code_AN[1]  %in% c("B-", "B+", "DB"))  {
  p <- ggplot2::ggplot(
    data = discrete_df,
    ggplot2::aes(E_MeV, prob, color = RN, shape = RN) 
  ) +
    ggplot2::geom_segment(ggplot2::aes(xend = E_MeV, yend = 0)) +
    ggplot2::geom_point(size = 3) +
    ggplot2::scale_colour_hue(l = 80, c = 150) +
    ggplot2::ggtitle(title, subtitle = rad_text) +
    ggthemes::theme_calc() +
    ggplot2::xlab("Energy, MeV") + 
    ggplot2::ylab("probability density") 
  

  if (log_plot == 1) p <- p + ggplot2::scale_y_log10()
  if (log_plot == 2) p <- p + ggplot2::scale_x_log10() + ggplot2::scale_y_log10()
  p
}

# beta plot ---------------------------------------------------------------


  if(discrete_df$code_AN[1]  %in% c("B-", "B+", "DB"))  {
    
  p <- ggplot2::ggplot(
    data = discrete_df,
    ggplot2::aes(E_MeV, A, color = RN, shape = RN)
  ) +
    ggthemes::theme_calc() +
    ggplot2::xlab("Energy, MeV") +
    ggplot2::ylab("probability density") +
    ggplot2::geom_line(size = 1.5) +
    ggplot2::scale_colour_hue(l = 80, c = 150) +
    ggplot2::ggtitle(title, subtitle = rad_text)
  
  if (log_plot == 1) p <- p + ggplot2::scale_y_log10()
  if (log_plot == 2) p <- p + ggplot2::scale_x_log10() + ggplot2::scale_y_log10()
}
p
}
