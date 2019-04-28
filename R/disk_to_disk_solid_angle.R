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
#' disk_to_disk_solid_angle(r.source = 50, gap = 20, r.detector = 60, plot.opt = "2d")
#' disk_to_disk_solid_angle(r.source = 24.5, gap = 20, r.detector = 60, plot.opt = "n")
#' disk_to_disk_solid_angle(r.source = 50, gap = 20, r.detector = 60,
#' runs = 1e3, plot.opt = "3d")
#' #' disk_to_disk_solid_angle(r.source = 50, gap = 20, r.detector = 60,
#' runs = 1e3, plot.opt = "3d", off_center = 10)
#' disk_to_disk_solid_angle(r.source = 15, gap = 20, r.detector = 10, plot.opt = "n")
#' disk_to_disk_solid_angle(r.source = 15, gap = 20, r.detector = 10, plot.opt = "n", beep = "on")
#'  
#' 
#' @export
disk_to_disk_solid_angle  <-  function(r.source,
                                       gap,
                                       r.detector,
                                       plot.opt = "n",
                                       runs = 1e4,
                                       off_center = 0,
                                       beep = "off") {
  # arg checks
  if(!is.numeric(c(r.source, gap, r.detector))) 
    stop("source radius, gap, and detector radius must be numbers.")
    if(!plot.opt %in% c("n", "2d", "3d"))
    stop("plot option must be either 'n', '2d', or '3d'")
  #adjust runs for losses due to start position = random point on square
  # (2 * radius)^2 vs (pi * radius^2)
  num <- floor(runs * 4 / pi)  
  # assign source and detector hits to zero
  n_source <- Sum_eff <- Sum_eff2 <-  n_det <- 0
  k <- 0.3 #shift parameter to avoid catastrophic cancellation
  on_src <- function(a) sqrt(sum(a^2)) < r.source
  on_det <- function(a) sqrt(sum(a^2)) < r.detector
  for(i in 1:num) {
    x_src <- stats::runif(n = 1, min = -r.source, max = r.source)
    y_src <- stats::runif(n = 1, min = -r.source, max = r.source)
    if(!on_src(c(x_src, y_src))) next 
    n_source <- n_source + 1
  # pick random 3d vector except only up allowed 
  theta <- stats::runif(1, min = 0, max = 2 * pi)
  # vector on x, y, z axes => {u, v, w}
  w <- stats::runif(1) #min 0, max 1 - all up
  r1 <- sqrt(1 - w^2)
  u <- r1 * cos(theta) #x coordinate vector
  v <- r1 * sin(theta) #y coordinate vector
  x_det <- x_src + u * gap / w + off_center
  y_det <- y_src + v * gap / w
  if(on_det(c(x_det, y_det)))  n_det <- n_det + 1
  
  #variance parameters
  Sum_eff <- Sum_eff + 
    as.numeric(on_src(c(x_src, y_src))) / n_source  - k
  Sum_eff2 <- Sum_eff2 + (as.numeric(on_src(c(x_src, y_src))) / n_source  - k)^2  
  
  df <- data.frame("n_det" = n_det,
                   "Sum_eff" = Sum_eff,
                   "Sum_eff2" = Sum_eff2,
                   "n_source" = n_source)
 
  }
  #if we don't have any points on the source yet...
#  if(df$n_source[1] == 0) df_res <- data.frame("mean" = 0,
#                                               "sd" = 0)
  
  # usually, we do...
#
    var <- (df$Sum_eff2 - df$Sum_eff^2 / df$n_source) /
                 (df$n_source - 1)
#  }
  df_res <- data.frame("mean" = df$n_det/ df$n_source / 2, 
                       "sd" = sqrt(var))
  
  
  

  # plot runs
  if(!plot.opt == "n"){
    num <- 1e3
    source.df <- data.frame("x" = stats::runif(num, min = -r.source, max = r.source),
          "y" = stats::runif(num, min = -r.source, max = r.source),
          "z" = -gap / 2)
    source.df$on <- apply(source.df[1:2], 1, on_src)
    source.df <- source.df[which(source.df$on == TRUE), ]
    # adjust source position if off center
    source.df$x <- source.df$x + off_center
    # color for plot
    source.df$color <- "firebrick1"
    
    # Make detector df
    n <- length(source.df$x)
    t <- stats::runif(n, min = 0, max = 2 * pi)
    # vector on x, y, z axes => {u, v, w}
    w <- stats::runif(n) #min 0, max 1 - all up
    r1 <- sqrt(1 - w^2)
    u <- r1 * cos(t)
    v <- r1 * sin(t)
    x.d <- source.df$x + u * gap / w 
    y.d <- source.df$y + v * gap / w
  det.df <- data.frame("x" = x.d, "y" = y.d, "z" = gap / 2)
  det.df$on <- apply(det.df[1:2], 1, on_det)
  det.df <- det.df[which(det.df$on == TRUE), ]
  # Relative solid angle is divided by two to account for only positive
  # z-directions modeled.
  rel_solid_angle <- length(det.df$x) / length(source.df$x) / 2
  det.df$color <- "cornflowerblue"
  # combine source and detector data for plotting together
  sim_set <- rbind(source.df, det.df)
  
  if(plot.opt == "3d")  {
    scatterplot3d::scatterplot3d(sim_set$x, sim_set$y,
        sim_set$z, main = "radiation disk source to detector surface",
        axis = FALSE,
        color = sim_set$color,
        cex.symbols = 500 / num, pch = 8,
        grid = FALSE, angle = 90) #, asp = 0.5 * gap / r.source)
      }
  
  if(plot.opt == "2d") {
    graphics::plot(x = source.df$x, 
                   y = source.df$y,
                   col = "firebrick1",
                   cex = 1000 / num,
                   pch = 1, 
                   xlim = range(min(-r.source, -r.detector),max(r.source, r.detector)),
                   ylim = range(min(-r.source, -r.detector),max(r.source, r.detector)),
                   xaxt = "n", yaxt = "n",
                   xlab = NA, ylab = NA,
                   main = paste("disk to disk fractional solid angle: r source = ",
                                r.source, " r detector  =",
                                r.detector, " gap =", gap),
                   bty = "n",
                   font.main = 3, bg = "beige",
                   cex.main = 0.8,
                   pty = "s",
                   mar = c(2, 2, 4, 2) + 0.1,
                   sub = paste0("offset = ", off_center))
    graphics::points(det.df$x, det.df$y, 
         col = "steelblue2", pch = 8, cex = 1000 / num)
    graphics::lines(x = (-100:100) * r.detector / 100,
          y = sqrt(r.detector^2 - ((-100:100) * r.detector / 100)^2),
          col = "steelblue2")
    graphics::lines(x = (-100:100) * r.detector / 100,
     y = -sqrt(r.detector^2 - ((-100:100) * r.detector/100)^2),
          col = "steelblue2") 
        graphics::legend("topleft",
                     "detector",
                     col = "steelblue2",
                     pch = 8, pt.cex = 0.5,
                     text.col = "steelblue2",
                     horiz = FALSE, bty = "n")
    graphics::legend("bottomleft",
                     "source",
                     col = "firebrick1",
                     text.col = "firebrick1",
                     pch = 1, pt.cex = 0.5,
                     horiz = FALSE, bty = "n")
  }
  
  }
    if(beep == "on") {
      if(requireNamespace("beepr")) beepr::beep(10)
  }
    print.data.frame(df_res, row.names = "")
  }
  
