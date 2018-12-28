#' Number of half-lives past
#' @description Given a percentage reduction in activity, calculate how many
#'   half-lives have passed.
#' @param pct_lost Percentage of activity lost since reference time.
#' @return Number of half-lives passed.
#' @examples
#' dk_pct_to_num_t_h(93.75)
#' @export
dk_pct_to_num_t_h <- function(pct_lost){
  -log(1 - pct_lost / 100) / log(2)
}




