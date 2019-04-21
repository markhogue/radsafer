#' Calculate fractional solid angle for disk to disk
#' @description Returns fractional solid angle for a geometry frequently
#'   encountered in health physics analysis of air samples or disk smears. This
#'   is useful in correcting configurations that do not exactly match
#'   calibration (by ratioing the respective fractional solid angles). While
#'   units of steridian are used for solid angle, this function only uses a
#'   fraction of the total field of view.
#' @family rad measurements
#' @param r.source  source radius (all units must be consistent)
#' @param gap distance between source and detector
#' @param r.detector detector radius
#' @param plot.opt plot options - "2d", "3d" or "n".
#' @param runs Number of particles to simulate. Running more particles improves
#'   accuracy. Default = 1e4.
#' @return Fractional solid angle and plot of simulation.
#' @examples
#' disk_to_disk_solid_angle(r.source = 50, gap = 20, r.detector = 60, plot.opt = "2d")
#' disk_to_disk_solid_angle(r.source = 50, gap = 20, r.detector = 60,
#' runs = 1e3, plot.opt = "3d")
#' disk_to_disk_solid_angle(r.source = 15, gap = 20,
#' r.detector = 10, plot.opt = "n")
#' @export
disk_to_disk_solid_angle  <-  function(r.source,
                                       gap,
                                       r.detector,
                                       plot.opt,
                                       runs = 1e4) {
  # Make source df
  #adjust runs for losses due to start position = random point on square
  # (2 * radius)^2 vs (pi * radius^2)
  num <- floor(runs * 4 / pi) 
  source.df <- data.frame("x" = stats::runif(num, min = -r.source, max = r.source),
                          "y" = stats::runif(num, min = -r.source, max = r.source),
                          "z" = -gap / 2)
  on_disk <- function(a) sqrt(sum(a^2)) < r.source
  source.df$on <- apply(source.df[1:2], 1, on_disk)
  source.df <- source.df[which(source.df$on == TRUE), ]
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
  on_det <- function(a) sqrt(sum(a^2)) < r.detector
  det.df <- data.frame("x" = x.d, "y" = y.d, "z" = gap / 2)
  det.df$on <- apply(det.df[1:2], 1, on_det)
  det.df <- det.df[which(det.df$on == TRUE), ]
  # Relative solid angle is divided by two to account for only positive
  # z-directions modeled.
  rel_solid_angle <- length(det.df$x) / length(source.df$x) / 2
  print(paste0("The relative solid angle estimate: ",
               signif(rel_solid_angle, 4)))
  det.df$color <- "cornflowerblue"
  # combine source and detector data for plotting together
  sim_set <- rbind(source.df, det.df)
  
  
if(plot.opt == "3d")  {
  scatterplot3d::scatterplot3d(sim_set$x, sim_set$y,
                               sim_set$z, main = "radiation disk source to detector surface",
                               axis = FALSE,
                               color = sim_set$color,
                               cex.symbols = 1000 / runs, pch = 8,
                               grid = FALSE, angle = 90) #, asp = 0.5 * gap / r.source)
  graphics::mtext(paste0("The relative solid angle is: ", 
                         signif(rel_solid_angle, 3)), adj = 0.5, 
                  col = "darkblue",
                  line = 1, side = 1)
}

  if(plot.opt == "2d") {
  graphics::plot(x = source.df$x, 
                 y = source.df$y,
                 col = "firebrick1",
                 cex = 1000 / runs,
                 pch = 1, 
                 xlim = range(source.df$x, det.df$x),
                 ylim = range(source.df$y, det.df$y),
       xaxt = "n", yaxt = "n",
       xlab = NA, ylab = NA,
       main = paste("disk - disk fractional solid angle: r source = ",
                    r.source, " r detector  =",
                    r.detector, " gap =", gap),
       bty = "n",
       font.main = 3, bg = "beige",
       pty = "s",
       mar = c(2, 2, 4, 2) + 0.1)
    graphics::points(det.df$x, det.df$y, 
      col = "steelblue2", pch = 8, cex = 1000 / runs)
    
  graphics::lines(x = (-100:100) * r.detector / 100,
        y = sqrt(r.detector^2 - ((-100:100) * r.detector / 100)^2),
        col = "steelblue2")
  graphics::lines(x = (-100:100) * r.detector / 100,
        y = -sqrt(r.detector^2 - ((-100:100) * r.detector/100)^2),
        col = "steelblue2")
  graphics::lines(x = (-100:100) * r.source / 100,
        y = sqrt(r.source^2 - ((-100:100) * r.source / 100)^2),
        col = "firebrick1", lty = 2)
  graphics::lines(x = (-100:100) * r.source / 100,
        y = -sqrt(r.source^2 - ((-100:100) * r.source / 100)^2),
        col = "firebrick1", lty = 2)
  graphics::mtext(paste0("The relative solid angle is: ",      signif(rel_solid_angle, 3)), adj = 0.5, 
     col = "darkblue",
     line = 1, side = 1)
  graphics::legend("topleft",
         "detector",
         col = "steelblue2",
         pch = 8, pt.cex = 0.5,
         text.col = "blue",
         horiz = FALSE, bty = "n")
  graphics::legend("bottomleft",
         "source",
          col = "firebrick1",
          text.col = "firebrick1",
          pch = 1, pt.cex = 0.5,
          horiz = FALSE, bty = "n")
  }
  rel_solid_angle
}
