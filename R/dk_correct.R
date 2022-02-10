#' Correct activity-dependent value based on radioactive decay.
#'
#' @family decay corrections
#'
#' @description Decay-corrected values are provided. Either a single or multiple
#'   values are computed. The computation is made either based on a single
#'   radionuclide, or based on user-provided half-life, with time unit. The
#'   differential time is either computed based on dates entered or time lapsed
#'   based on the time unit. Time units must be consistent. Decay-correct a
#'   source to today's date by assigning a reference `date1` and allowing
#'   default `date2`, the system date.
#'
#' @param RN_select identify the radionuclide of interest in the format,
#'   \emph{"Es-254m"} Required unless `half_life` is entered.
#' @param half_life Required if `RN_select` is not provided.
#' @param time_unit, acceptable values are \emph{"years"}, \emph{"days"},
#'   \emph{"hours"}, \emph{"minutes"}, and \emph{"seconds"}. May be shortened to
#'   \emph{"y"}, \emph{"d"}, \emph{"h"}, \emph{"m"}, and \emph{"s"}. Required if
#'   `half_life` or `time_lapse` are to be entered.
#' @param time_lapse a single value or vector of values representing time lapsed
#'   since `date1`, with units identified in `time_unit`. Positive values
#'   represent time past `date1`. Negative values represent time before `date1`.
#'   Required unless `date1` is entered.
#' @param date1 Reference date - Required unless using `time_lapse`. Format is
#'   required to be date-only: \emph{"YYYY-MM-DD"} (e.g. \emph{"1999-12-31"}).
#'   If `half_life` is short relative to calendar dates, use `time_lapse`
#'   instead.
#' @param date2 Date or dates of interest. Default is today's date, obtained
#'   from the computer operating system.
#' @param A1 The reference activity or related parameter, such as count rate or
#'   dose rate. Default value is 1, resulting in a returned value that may be
#'   used as a correction factor.
#' @param num Set for TRUE to facilitate as.numeric results. Default = FALSE.
#' @return Decay adjusted activity or related parameter. See `A1`.
#' @examples
#'
#' # RN_select and date1 (saving numerical data)
#' my_dks <- dk_correct(
#'   RN_select = "Sr-90",
#'   date1 = "2009-01-01",
#'   date2 = "2019-01-01",
#'   num = TRUE
#' )
#'
#' #   RN_select and time_lapse (random sample)
#' dk_correct(
#'   RN_select = base::sample(RadData::ICRP_07.NDX$RN, 1),
#'   time_lapse = 1:10,
#'   time_unit = base::sample(c("y", "d", "h", "m", "s"), 1)
#' )
#'
#' #   half_life and date1
#' dk_correct(
#'   half_life = 10,
#'   time_unit = "y",
#'   date1 = "2009-01-01",
#'   date2 = c(
#'     "2015-01-01",
#'     "2016-01-01",
#'     "2017-01-01"
#'   )
#' )
#'
#' #   half_life and time_lapse
#' dk_correct(
#'   half_life = 10,
#'   time_lapse = 10,
#'   time_unit = "y"
#' )
#'
#' # decay to today
#' dk_correct(RN_select = "Sr-90", date1 = "2009-01-01")
#'
#' # reverse decay - find out what readings should have been in the past given today's reading of 3000
#' dk_correct(
#'   RN_select = "Sr-90",
#'   date1 = "2019-01-01",
#'   date2 = c("2009-01-01", "1999-01-01"),
#'   A1 = 3000
#' )
#' @export
dk_correct <- function(RN_select = NULL,
                       half_life = NULL,
                       time_unit = NULL,
                       time_lapse = NULL,
                       date1 = NULL,
                       date2 = Sys.Date(),
                       A1 = 1,
                       num = FALSE) {
  #
  # convert dates to date format, if needed
  if (!is.null(date1)) date1 <- as.Date(date1)
  if (!is.null(date2)) date2 <- as.Date(date2)

  # if time_lapse is entered as integer, convert
  if (is.integer(time_lapse)) time_lapse <- as.numeric(time_lapse)
  # arg checks~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #
  #  Check for compatible argument set

  if (!is.null(RN_select) & !is.character(RN_select)) {
    stop("RN_select must be entered in quotes")
  }
  # Should have either RN_select or half_life

  if ((is.null(RN_select) + is.null(half_life)) != 1) {
    stop("Enter either RN_select or half_life, not both.")
  }

  # Should have either time_lapse or date1
  if ((is.null(time_lapse) + is.null(date1)) != 1) {
    stop("Enter either time_lapse or date1, not both.")
  }

  #  half_life check

  if (!is.null(half_life)) {
    if (!is.numeric(half_life)) {
      stop("half_life must be a number.")
    }
  }

  # time_unit check - time_unit needed for either time_lapse or half_life
  if (!is.null(c(time_lapse, half_life))) {
    if (is.null(time_unit)) stop("time_unit is needed to work with time_lapse and half_life.")
  }

  if (!is.null(time_unit)) {
    if (!time_unit %in% c(
      "years", "days", "hours", "minutes", "seconds",
      "y", "d", "h", "m", "s"
    )) {
      stop("time_unit is not one of the acceptable options:
       'years', 'days', 'hours','minutes', 'seconds',
        'y', 'd', 'h', 'm', 's' ")
    }
  }

  # check date formats
  if (!is.null(date1)) {
    warning("Date mode only provides precision to the day. Use time_lapse mode if more precision is needed.")
    if (anyNA(as.Date(c(date1, date2)))) {
      stop("Error: Dates must be in '%Y-%m-%d' format")
    }
  }

  # end of general arg checks~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # convert time units to seconds (half_life and time_lapse)~~~~~

  # if time_lapse is given, convert to seconds
  if (!is.null(time_lapse)) {
    time_lapse_sec <- dplyr::case_when(
      time_unit == "year" |
        time_unit == "years" |
        time_unit == "y" ~
      time_lapse * 3.15576e7,

      time_unit == "days" |
        time_unit == "d" |
        time_unit == "day" ~
      time_lapse * 86400,

      time_unit == "hours" |
        time_unit == "h" |
        time_unit == "hour" ~
      time_lapse * 3600,

      time_unit == "minutes" |
        time_unit == "m" |
        time_unit == "mins" ~
      time_lapse * 60,

      time_unit == "seconds" |
        time_unit == "secs" |
        time_unit == "s" ~
      time_lapse
    )
  }

  # end of time_lapse unit conversion


  # get decay constant (in decays / s), RN_select option
  if (!is.null(RN_select)) {
    i <- which(RadData::ICRP_07.NDX$RN == RN_select)
    if (i == 0) stop(paste0("data entered for radionuclide: ", RN_select, " not found."))
    decay_constant <- as.numeric(RadData::ICRP_07.NDX[i, 32])
  }

  if (!is.null(RN_select)) {
    print.data.frame(RadData::ICRP_07.NDX[i, 1:4], row.names = "")
    cat("\n")
  }

  # convert decay_constant (when needed)
  if (!is.null(half_life)) {
    decay_constant <- dplyr::case_when(
      time_unit == "year" |
        time_unit == "years" |
        time_unit == "y" ~
      log(2) / (half_life * 3.15576e7),

      time_unit == "days" |
        time_unit == "d" |
        time_unit == "day" ~
      log(2) / (half_life * 86400),

      time_unit == "hours" |
        time_unit == "h" |
        time_unit == "hour" ~
      log(2) / (half_life * 3600),

      time_unit == "minutes" |
        time_unit == "m" |
        time_unit == "mins" ~
      log(2) / (half_life * 60),

      time_unit == "seconds" |
        time_unit == "secs" |
        time_unit == "s" ~
      log(2) / (half_life)
    )
  }


  # compute time_lapse in seconds from dates (when needed)
  if (!is.null(date1)) {
    time_lapse_sec <- as.numeric(difftime(strptime(date2, "%Y-%m-%d"),
      strptime(date1, "%Y-%m-%d"),
      units = "secs"
    ))
  }

  # Time-decayed response, A2

  A2 <- A1 * exp(-decay_constant * time_lapse_sec)

  # Four cases:
  #   RN_select and date1
  #   RN_select and time_lapse
  #   half_life and date1
  #   half_life and time_lapse
  # Each of these will use the decay formula:

  if (!is.null(RN_select) & !is.null(date1)) {
    n <- length(date2)
    df <- data.frame(
      "RN" = rep(RN_select, n),
      "RefValue" = rep(A1, n),
      "RefDate" = rep(date1, n),
      "TargDate" = date2,
      "dk_value" = A2
    )
  }

  if (!is.null(RN_select) & !is.null(time_lapse)) {
    n <- length(time_lapse)
    df <- data.frame(
      "RN" = rep(RN_select, n),
      "RefValue" = rep(A1, n),
      "DecayTime" = time_lapse,
      "TimeUnit" = rep(time_unit, n),
      "dk_value" = A2
    )
  }

  if ((!is.null(half_life) & !is.null(date1))) {
    n <- length(date2)
    df <- data.frame(
      "half_life" = rep(half_life, n),
      "RefValue" = rep(A1, n),
      "RefDate" = rep(date1, n),
      "TargDate" = date2,
      "dk_value" = A2
    )
  }

  if (!is.null(half_life) & !is.null(time_lapse)) {
    n <- length(time_lapse)
    df <- data.frame(
      "half_life" = rep(half_life, n),
      "RefValue" = rep(A1, n),
      "DecayTime" = time_lapse,
      "TimeUnit" = rep(time_unit, n),
      "dk_value" = A2
    )
  }

  if (num != TRUE)  {
    print.data.frame(df, row.names = FALSE)
    }
  if (num == TRUE) {
    return(A2)
  }
}
