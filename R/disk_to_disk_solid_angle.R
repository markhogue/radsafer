#' Calculate fractional solid angle for disk to disk
#' @description Returns fractional solid angle for a geometry frequently
#'   encountered in health physics analysis of air samples or disk smears. This
#'   is useful in correcting configurations that do not exactly match
#'   calibration (by ratioing the respective fractional solid angles). While
#'   units of steridian are used for solid angle, this function only uses a
#'   fraction of the total field of view.
#' @param r.source  source radius (all units must be consistent)
#' @param gap distance between source and detector
#' @param r.detector detector radius
#' @param show_plot A plot of the results will be displayed by default. Set to
#'   FALSE if this is not desired.
#' @param runs Number of particles to simulate. Running more particles improves
#'   accuracy. Default = 1e4.
#' @return Fractional solid angle and plot of simulation.
#' @examples
#' disk_to_disk_solid_angle(r.source = 50, gap = 20, r.detector = 60)
#' disk_to_disk_solid_angle(r.source = 50, gap = 20, r.detector = 60,
#'                          runs = 1e3)
#' disk_to_disk_solid_angle(r.source = 15, gap = 20,
#'                          r.detector = 10)
#' @export
disk_to_disk_solid_angle  <-  function(r.source,
                                     gap,
                                     r.detector,
                                     show_plot = TRUE,
                                     runs = 1e4) {
  r.s <- 0; x.s <- 0; y.s <- 0; radius <- 100; u <- 0;
  v <- 0; w <- 0
  x.d <- 0; y.d <- 0; counts <- rep(0, length(r.source))
  rand.xy <- function(a) runif(1, min = -1, max = 1) * a
  rand.z <- function() runif(1, min = -1, max = 1)
  rand.t <- function() runif(1, min = 0, max = 2 * pi)
  r <- function(z) sqrt(1 - z^2)
  rand.x <- function(r) r * cos(t)
  rand.y <- function(r) r * sin(t)
  lims  <-  floor(1.1 * max(r.source, r.detector, gap))
  plot(x = -lims:lims, y = -lims:lims,
       xlab = "", ylab = "",
       xlim = c(-lims, lims),
       ylim = c(-lims, lims),
       xaxt = "n", yaxt = "n",
       main = paste("concentric disk fractional solid angle: r source = ",
                    r.source, " r detector  =",
                    r.detector, " gap =", gap),
       type = "n", bty = "n",
       font.main = 3, bg = "beige",
       pty = "s",
       mar = c(2, 2, 4, 2) + 0.1)
  lines(x = (-100:100) * r.detector / 100,
        y = sqrt(r.detector^2 - ((-100:100) * r.detector / 100)^2),
        col = "firebrick1")
  lines(x = (-100:100) * r.detector / 100,
        y = -sqrt(r.detector^2 - ((-100:100) * r.detector/100)^2),
        col = "firebrick1")
  lines(x = (-100:100) * r.source / 100,
        y = sqrt(r.source^2 - ((-100:100) * r.source / 100)^2),
        col = "blue", lty = 2)
  lines(x = (-100:100) * r.source / 100,
        y = -sqrt(r.source^2 - ((-100:100) * r.source / 100)^2),
        col = "blue", lty = 2)
  count <- 0
  for(j in 1:runs) {
    radius <- r.source + 1
    while(radius>r.source) {x.s <- rand.xy(r.source)
    y.s <- rand.xy(r.source)
    radius <- sqrt(x.s^2 + y.s^2)}
    w <- rand.z()
    t <- rand.t()
    r1 <- r(w)
    u <- rand.x(r1)
    v <- rand.y(r1)
    x.d <- x.s + u * gap / w
    y.d <- y.s + v * gap / w
    # add up hits
    max_pts <- floor(500 * r.detector^2 / 3600)
    count <- count + (w > 0) * (sqrt(x.d^2 + y.d^2) <= r.detector)
    if(show_plot == TRUE &
       count < max_pts) {
      points(x.s, y.s, col = "cornflowerblue", cex = 0.5, pch = 10)
    }
    if(show_plot == TRUE &
       count < max_pts &
       sqrt(x.d^2 + y.d^2) <= r.detector) {
      points(x.d, y.d,
             col = "darkviolet", cex = 0.8, pch = 23,
             bg = "orange")
    }
  }
  legend("bottom", c("detector hits", "source"),
         pch = c(23, 10, NA),
         col = c("darkviolet", "cornflowerblue", NA),
         pt.bg = c("orange", NA, NA),
         bty = "n",
         horiz = TRUE)
  mtext(paste0("fract. solid angle = ",
         format(count / runs, digits = 3)), side = 1)
  count / runs
}


