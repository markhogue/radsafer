#' Correction factor for a decayed source - to update expected readings. '
#' @description Compute correction value for decay of a single-isotope source. '
#' @param t_h The half-life numeric value
#' @param date1 Source reference date. If units are hours or shorter, include time. Format is
#  "YYYY-mm-dd" for longer half-lives, or "YYYY-mm-dd-HH:MM".
#' @param date2 Date of interest. Format is same as date1.

#' @param time_unit, acceptable values are years, days, hours, and minutes.
#'   These may be shortened to y, d, h and m. Must be entered in quotes.
#' @return The decay correction factor from the reference date to the date of interest. ' @examples ' dk_cf(5.27,"2010-12-01", "2018-12-01", "y") ' dk_cf(24, "2018-10-01-08:15","2018-10-01-09:15", "m")
#' @export
dk_cf <- function(t_h, date1, date2, time_unit) {
  if(time_unit == "year" | time_unit == "y") {
    2^(-as.numeric(difftime(strptime(date2, "%Y-%m-%d"),
                            strptime(date1, "%Y-%m-%d"),
                            units = "days") /365.25 / t_h))
  }
  else if(time_unit == "days" |
          time_unit == "d" |
          time_unit == "day") {
    2^(-as.numeric(difftime(strptime(date2, "%Y-%m-%d"),
                            strptime(date1, "%Y-%m-%d"),
                            units = "days")  / t_h))
  }
  else if(time_unit == "hours" |
          time_unit == "h" |
          time_unit == "hour") {
    2^(-as.numeric(difftime(strptime(date2, "%Y-%m-%d-%H:%M"),
                            strptime(date1, "%Y-%m-%d-%H:%M"),
                            units = "hours") / t_h))  }
  else if(time_unit == "minutes" |
          time_unit == "m" |
          time_unit == "mins") {
    2^(-as.numeric(difftime(strptime(date2, "%Y-%m-%d-%H:%M"),
                            strptime(date1, "%Y-%m-%d-%H:%M"),
                            units = "mins") / t_h))  }

}
