#' Count Room Scaler Simulation
#' @description Returns a plotted distribution of results for a scaler model
#'   based on the Poisson distribution. Inputs and outputs in counts per minute.
#' @param true_bkg  True background count rate in counts per minute.
#' @param true_samp True sample count rate in counts per minute.
#' @param ct_time How many iterations of counting are performed.
#' @param trials How many times to run the model.
#' @return A histogram of all trial results including limits for +/- 1 standard
#'   deviation.
#' @examples
#' scaler_sim(true_bkg = 50, true_samp = 10, ct_time = 1, trials = 1e5)
#' scaler_sim(true_bkg = 50, true_samp = 30, ct_time = 1, trials = 1e5)
#' @export


scaler_sim <- function(true_bkg, true_samp, ct_time, trials) {
  bkg <- stats::rpois(1000, true_bkg)
  samp <- stats::rpois(1000, true_samp)
  gross <- bkg + samp
  net <- format(true_samp, digits = 4)
  tcol <- "darkblue" #color of text
  for(counts in ct_time) {
    result <- rep(1, 5) #set up blank vector
    for(i in 1 : trials) result[i] <-
        mean(sample(gross, counts, replace = T))
    range_param <- 0.2 #how much under and over true gross
    graphics::par(bg = "ivory")
    graphics::hist(result, main = paste("distribution with ", 
        counts,
        " minute counts"),
         col = "skyblue",
         col.main = tcol, col.axis = tcol, col.lab = tcol,
         xlab = "net counts", freq = F, breaks = 50,
         sub = paste0("result of ",
         format(trials,  big.mark=",", digits = 0,
                scientific = F),
                " trials"),
         xlim = c((1 - range_param) * (true_samp + true_bkg),
                  (1 + range_param) * (true_samp + true_bkg)))
    graphics::abline(v = c(mean(result) + stats::sd(result), mean(result) -
                   stats::sd(result)), col = "blue",lty = 2)
    graphics::abline(v= c(mean(result) + 2 * 
        stats::sd(result), mean(result) -
        2 * stats::sd(result)), col = "firebrick1", lty = 3)
    graphics::mtext(paste("true net = ", net,
        "cpm, true bkg = ", true_bkg, " cpm"),
          col = tcol)
    graphics::abline(v = 0, lty = 1, col = tcol)
  }
}
