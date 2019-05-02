#' Stay time for radiation work.
#' @description Calculate stay time for radiation work.
#' @param dose_rate Dose rate per hour for the work - units consistent with dose allowance, e.g. mRem/h, microSv/h.
#' @param dose_allowed Dose that can not be exceeded for this job.
#' @param margin Percent margin to protect limit, default = 20 percent.
#' @return Time in minutes allowed for the work. 
#' @examples 
#' stay_time(100, 50, 20)
#' @export
stay_time <- function(dose_rate, dose_allowed, margin = 20) {
  mins <- (100 - margin)/100 * (dose_allowed / dose_rate) * 60
  print(paste0("Time allowed is ", mins, " minutes"))
  mins
}
