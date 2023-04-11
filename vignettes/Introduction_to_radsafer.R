## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(radsafer)

## ----warning=FALSE------------------------------------------------------------
dk_correct(half_life = 10,
           time_unit = "y",
           date1 = "2010-01-01")

## ----warning=FALSE------------------------------------------------------------
dk_correct(RN_select = "Sr-90",
           date1 = "2005-01-01",
           date2 = c("2009-01-01","2009-10-01"),
           A1 = 10000)

## ----warning=FALSE------------------------------------------------------------
dk_correct(RN_select = "Cs-137", 
  date1 = "2019-01-01", 
  date2 = c("2009-01-01","1999-01-01"), 
  A1 = 3000)

## ----echo = TRUE--------------------------------------------------------------
search_results <- RN_search_phot_by_E(0.99, 1.01, 13 * 60, 15 * 60, 1e-3)

## ----echo = FALSE-------------------------------------------------------------
knitr::kable(search_results)

## ----out.width = '75%', fig.align='center', warning=FALSE, message=FALSE------
RN_plot_spectrum(search_results)

## ----echo = TRUE--------------------------------------------------------------
 RN_plot_spectrum(
   desired_RN = c("Pu-238", "Pu-239", "Am-241"), rad_type = "A",
   photon = FALSE, prob_cut = 0.01, log_plot = 0)

## ----echo = TRUE--------------------------------------------------------------
RNs_selected <- RN_index_screen(dk_mode = "SF", min_half_life_seconds = 0.5 * 3.153e7, max_half_life_seconds = 2 * 3.153e7)

## ----echo = FALSE-------------------------------------------------------------
knitr::kable(RNs_selected[, c(1:3)])

## ----echo = TRUE--------------------------------------------------------------

RN_find_parent("Th-230")


## -----------------------------------------------------------------------------
air_dens_cf(T.actual = 30, P.actual = 760, T.ref = 20, P.ref = 760)

## -----------------------------------------------------------------------------
rdg <- 100
(rdg_corrected <- rdg * air_dens_cf(T.actual = 30, P.actual = 760, T.ref = 20, P.ref = 760))

## -----------------------------------------------------------------------------
neutron_geom_cf(11.1, 11)

## -----------------------------------------------------------------------------
(as_rel_solid_angle <- as.numeric(disk_to_disk_solid_angle(r.source = 45/2, gap = 20, r.detector = 12.5, runs = 1e4, plot.opt = "n")))

## ----out.width = '50%', fig.align='center'------------------------------------
  library(ggplot2)
theme_update(# axis labels
             axis.title = element_text(size = 7),
             # tick labels
             axis.text = element_text(size = 5),
             # title 
             title = element_text(size = 5))
(as_rel_solid_angle <- as.numeric(disk_to_disk_solid_angle(r.source = 45/2, gap = 20, r.detector = 12.5, runs = 1e4, plot.opt = "3d")))

## -----------------------------------------------------------------------------
(cal_rel_solid_angle <- disk_to_disk_solid_angle(r.source = 20, gap = 20, r.detector = 12.5, runs = 1e4, plot.opt = "n"))

## -----------------------------------------------------------------------------
(cf <- cal_rel_solid_angle / as_rel_solid_angle)

## ----out.width = '50%', fig.align='center'------------------------------------
scaler_sim(true_bkg = 50, true_samp = 10, ct_time = 20, trials = 1e5)

## ----out.width = '50%', fig.align='center'------------------------------------
rate_meter_sim(cpm_equilibrium = 270, meter_scale_increments = seq(100, 1000, 20))

## -----------------------------------------------------------------------------
stay_time(dose_rate = 120, dose_allowed = 100, margin =  20)

## ----echo = FALSE-------------------------------------------------------------
mm_Al <- 0:5
mR_h <- c(7.428, 6.272, 5.325,4.535, 3.878, 3.317)

## ----echo = TRUE--------------------------------------------------------------
hvl(x = mm_Al, y = mR_h) 

## -----------------------------------------------------------------------------
mcnp_matrix_rotations("z", 90)

## -----------------------------------------------------------------------------
mcnp_cone_angle(30)

## ----echo = FALSE-------------------------------------------------------------
plot_data <- photons_cs137_hist

## ----out.width = '75%', fig.align='center', warning=FALSE, message=FALSE------
mcnp_plot_out_spec(photons_cs137_hist, 'example Cs-137 well irradiator')

