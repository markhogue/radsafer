#' Calculate fractional solid angle for disk to disk
#' @description Returns fractional solid angle for a geometry frequently
#'   encountered in health physics analysis of air samples or disk smears. This
#'   is useful in correcting configurations that do not exactly match
#'   calibration (by ratioing the respective fractional solid angles). While
#'   units of steridian are used for solid angle, this function only uses a
#'   fraction of the total field of view.
#'
#' @family rad measurements
#'
#' @references
#' \url{https://karthikkaranth.me/blog/generating-random-points-in-a-sphere/}
#' \url{https://en.wikipedia.org/wiki/Algorithms_for_calculating_variance}
#'
#' @param r.source  source radius (all units must be consistent)
#' @param gap distance between source and detector
#' @param r.detector detector radius
#' @param plot.opt plot options - "2d", "3d" or "n".
#' @param runs Number of particles to simulate. Running more particles improves accuracy. Default = 1e4.
#' @param off_center measure of eccentricity between the center of the source and the center of the disk. This is applied to the x-dimension of the source.
#' @param beep Set to "on" if desired. Default is "off". Alerts to end of run if runs is set to a high number.
#'
#' @return Fractional solid angle and plot of simulation.
#'
#' @examples
#' disk_to_disk_solid_angle(r.source = 15, gap = 20, r.detector = 10, plot.opt = "n", runs = 1e3)
#' @export
disk_to_disk_solid_angle <- function(r.source,
                                     gap,
                                     r.detector,
                                     plot.opt = "n",
                                     runs = 1e4,
                                     off_center = 0,
                                     beep = "off") {
  # arg checks
  if (!is.numeric(c(r.source, gap, r.detector))) {
    stop("source radius, gap, and detector radius must be numbers.")
  }
  if (!plot.opt %in% c("n", "2d", "3d")) {
    stop("plot option must be either 'n', '2d', or '3d'")
  }

  # adjust runs for losses due to start position = random point on square
  # (2 * radius)^2 vs (pi * radius^2)
  num <- floor(runs * 4 / pi)

  # on source and on detector functions
  on_src <- function(x, y) sqrt(x^2 + y^2) < r.source
  on_det <- function(x, y) sqrt(x^2 + y^2) < r.detector

  # simulation
  # make data frame
  df <- data.frame(
    "x_src" = stats::runif(n = num, min = -r.source, max = r.source),
    "y_src" = stats::runif(n = num, min = -r.source, max = r.source),
    "theta" = stats::runif(n = num, min = 0, max = 2 * pi),
    # vector on x, y, z axes => {u, v, w}
    "w" = stats::runif(n = num, min = 0, max = 1)
  ) # all up
  df$on_src <- on_src(df$x_src, df$y_src)
  df <- df[which(df$on_src == TRUE), ]
  df <- df[, -5] # remove on_src column
  df$r1 <- sqrt(1 - df$w^2)
  df$u <- df$r1 * cos(df$theta) # x coordinate vector
  df$v <- df$r1 * sin(df$theta) # y coordinate vector

  # off_center adjustment
  df$x_src <- df$x_src + off_center

  df$x_det <- df$x_src + df$u * gap / df$w
  df$y_det <- df$y_src + df$v * gap / df$w
  df$on_det <- on_det(df$x_det, df$y_det)

  # summary statistics
  eff_est <- sum(df$on_det) / length(df$on_det) / 2

  df_res <- data.frame(
    "mean_eff" = eff_est,
    "SEM" = sqrt(eff_est * (1 - eff_est) /
      (length(df$on_det) - 1))
  )

  # plot runs
  if (!plot.opt == "n") {
    plot_df_length <- min(c(length(df$x_src), 1000))
    df <- df[1:plot_df_length, ]
    df <- df[, c(1, 2, 8, 9, 10)] # drop unneeded columns
    # make two data sets
    source.df <- df[, c(1, 2)]
    names(source.df) <- c("x", "y")
    source.df$z <- rep(-gap / 2, length(source.df$x))
    det.df <- df[which(df$on_det == TRUE), c(3, 4)]
    names(det.df) <- c("x", "y")
    det.df$z <- rep(gap / 2, length(det.df$x))
    source.df$color <- "firebrick1"
    det.df$color <- "cornflowerblue"
    # combine source and detector data for plotting together
    sim_set <- rbind(source.df, det.df)

    if (plot.opt == "3d") {
      scatterplot3d::scatterplot3d(sim_set$x, sim_set$y,
        sim_set$z,
        main = "disk source -> detector",
        axis = FALSE,
        color = sim_set$color,
        cex.symbols = 0.5, pch = 8,
        grid = FALSE, angle = 90
      ) # , asp = 0.5 * gap / r.source)
    }


    if (plot.opt == "2d") {
      graphics::plot(
        x = source.df$x,
        y = source.df$y,
        col = "firebrick1",
        cex = 0.5,
        pch = 1,
        xlim = range(min(-r.source, -r.detector), max(r.source, r.detector)),
        ylim = range(min(-r.source, -r.detector), max(r.source, r.detector)),
        xaxt = "n", yaxt = "n",
        xlab = NA, ylab = NA,
        main = paste(
          "disk to disk fractional solid angle: r source = ",
          r.source, " r detector  =",
          r.detector, " gap =", gap
        ),
        bty = "n",
        font.main = 3, bg = "beige",
        cex.main = 0.8,
        pty = "s",
        mar = c(2, 2, 4, 2) + 0.1,
        sub = paste0("offset = ", off_center)
      )
      graphics::points(det.df$x, det.df$y,
        col = "steelblue2", pch = 8, cex = 0.5
      )
      graphics::lines(
        x = (-100:100) * r.detector / 100,
        y = sqrt(r.detector^2 - ((-100:100) * r.detector / 100)^2),
        col = "steelblue2"
      )
      graphics::lines(
        x = (-100:100) * r.detector / 100,
        y = -sqrt(r.detector^2 - ((-100:100) * r.detector / 100)^2),
        col = "steelblue2"
      )
      graphics::legend("topleft",
        "detector",
        col = "steelblue2",
        pch = 8, pt.cex = 0.5,
        text.col = "steelblue2",
        horiz = FALSE, bty = "n"
      )
      graphics::legend("bottomleft",
        "source",
        col = "firebrick1",
        text.col = "firebrick1",
        pch = 1, pt.cex = 0.5,
        horiz = FALSE, bty = "n"
      )
    }
  }
  if (beep == "on") {
    if (requireNamespace("beepr")) beepr::beep(10)
  }
  rownames(df_res) <- ""
  df_res
}
