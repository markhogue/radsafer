#' Number of half-lives past
#' @family decay corrections
#' @description Given a percentage reduction in activity, calculate how many
#'   half-lives have passed.
#' @param pct_lost Percentage of activity lost since reference time.
#' @return Number of half-lives passed.
#' @examples
#' dk_pct_to_num_half_life(pct_lost = 93.75)
#' @export
dk_pct_to_num_half_life <- function(pct_lost){
  if(!is.numeric(pct_lost)) 
    stop("pct_lost must be a number.")
    -log(1 - pct_lost / 100) / log(2)
}
