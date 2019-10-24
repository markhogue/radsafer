#' Correction factor for source decay.
#' @family decay corrections
#' @description Compute correction value for decay of a single-isotope source.
#' @param half_life The half-life numeric value
#' @param time_unit, acceptable values are years, days, hours, and minutes.
#'   These may be shortened to y, d, h and m. Must be entered in quotes.
#' @param date1 Source reference date. If units are hours or shorter, include time. Format is "YYYY-mm-dd" for longer half-lives, or "YYYY-mm-dd-HH:MM".
#' @param date2 Date of interest. Format is same as date1. Default is today's date, obtained from system.

#' @return The decay correction factor from the reference date to the date of interest.
#' @examples
#' dk_cf(half_life = 5.27, time_unit = "y", date1 = "2010-12-01", date2 = "2018-12-01")
#' #
#' # example defaulting to today's date:
#' dk_cf(half_life = 28.79, time_unit = "y", date1 = "2001-01-01")
#' @export
dk_cf <- function(half_life, time_unit, date1, date2 = Sys.Date()) {
  .Deprecated("dk_correct")
  # arg checks
  if (!is.numeric(half_life)) {
    stop("half_life must be a number.")
  }
  if (!is.character(date1)) {
    stop("dates must be in format 'YYYY-MM-DD'")
  }
  if (!is.character(date1)) {
    stop("dates must be in format 'YYYY-MM-DD'")
  }
  if (!time_unit %in% c(
    "years", "days", "hours", "minutes",
    "y", "d", "h", "m"
  )) {
    stop("time unit must be one of these: 
       'years', 'days', 'hours','minutes', 
        'y', 'd', 'h', 'm'")
  }
  # end of arg checks
  if (time_unit == "year" | time_unit == "y") {
    2^(-as.numeric(difftime(strptime(date2, "%Y-%m-%d"),
      strptime(date1, "%Y-%m-%d"),
      units = "days"
    ) / 365.25 / half_life))
  }
  else if (time_unit == "days" |
    time_unit == "d" |
    time_unit == "day") {
    2^(-as.numeric(difftime(strptime(date2, "%Y-%m-%d"),
      strptime(date1, "%Y-%m-%d"),
      units = "days"
    ) / half_life))
  }
  else if (time_unit == "hours" |
    time_unit == "h" |
    time_unit == "hour") {
    2^(-as.numeric(difftime(strptime(date2, "%Y-%m-%d-%H:%M"),
      strptime(date1, "%Y-%m-%d-%H:%M"),
      units = "hours"
    ) / half_life))
  }
  else if (time_unit == "minutes" |
    time_unit == "m" |
    time_unit == "mins") {
    2^(-as.numeric(difftime(strptime(date2, "%Y-%m-%d-%H:%M"),
      strptime(date1, "%Y-%m-%d-%H:%M"),
      units = "mins"
    ) / half_life))
  }
}
