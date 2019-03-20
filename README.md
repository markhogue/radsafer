
<!-- README.md is generated from README.Rmd. Please edit that file -->
radsafer <img src='man/figures/radsafer.png' align="right" height="139" />
==========================================================================

The goal of radsafer is to provide functions that are useful for radiation safety professionals.

Installation
------------

You can install the released version of radsafer from [CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("radsafer")
```

Or install the development version from GitHub:

``` r
# install.packages("devtools")
devtools::install_github("markhogue/radsafer")
```

Oveview
-------

To start using the installed package:

``` r
library(radsafer)
```

### Decay Correction Functions

Radsafer includes several functions to manage radioactive decay corrections:

**dk\_cf** provides a correction factor. Revise a calibration or source check value to today's date (the default) or a date and time of your choosing.

``` r
dk_cf(half_life = 5.27, date1 = "2010-12-01", date2 = "2018-12-01", time_unit = "y")
#> [1] 0.3491632
```

Use this function to correct for the value needed today. Say, a disk source originally had a target count rate of 3000 cpm:

``` r
3000 * dk_cf(half_life = 5.27, date1 = "2010-12-01", date2 = "2018-12-01", time_unit = "y")
#> [1] 1047.49
```

Other decay functions answer the following questions: \* What is the decayed activity? **dk\_activity**, Given a percentage reduction in activity, how many half-lives have passed.**dk\_pct\_to\_num\_half\_life**

-   How long will it take to reach the target radioactivity? **dk\_time**

-   Given the radioactivity at one time, what was the radioactivity at an earlier time? **dk\_reverse**

-   Given two data points, estimate the half-life: **half\_life\_2pt**

### Instrumentation functions

**air\_dens\_cf** Correct *vented ion chamber readings* based on difference in air pressure (readings in degrees Celsius and mm Hg):

``` r
air_dens_cf(T.actual = 30, P.actual = 760, T.ref = 20, P.ref = 760)
#> [1] 1.034112
```

Let's try it out combined with the instrument reading:

``` r
rdg <- 100
(rdg_corrected <- rdg * air_dens_cf(T.actual = 30, P.actual = 760, T.ref = 20, P.ref = 760))
#> [1] 103.4112
```

**neutron\_geom\_cf**

Correct for *geometry* when reading a close *neutron* source. Example: neutron rem detector with a radius of 11 cm and source near surface:

``` r
neutron_geom_cf(11.1, 11)
#> [1] 0.7236467
```

**disk\_to\_disk\_solid\_angle**

Correct for a mismatch between the *source calibration* of a *counting system* and the item being measured. A significant factor in the counting efficiency is the solid angle from the source to the detector.

Example: You are counting an air sample with an active collection diameter of 45 mm, your detector has a radius of 25 mm and there is a gap between the two of 5 mm. (The function is based on radius, not diameter so be sure to divide the diameter by two.) The relative solid angle is:

``` r
(as_rel_solid_angle <- as.numeric(disk_to_disk_solid_angle(r.source = 45/2, gap = 20, r.detector = 12.5, runs = 1e4, plot.opt = "n")))
#> [1] "The relative solid angle estimate: 0.04652"
#> [1] 0.04652444
```

An optional plot is available in 2D or 3D:

``` r
(as_rel_solid_angle <- as.numeric(disk_to_disk_solid_angle(r.source = 45/2, gap = 20, r.detector = 12.5, runs = 1e4, plot.opt = "3d")))
#> [1] "The relative solid angle estimate: 0.04832"
```

<img src="man/figures/README-unnamed-chunk-9-1.png" width="50%" />

    #> [1] 0.04832121

Continuing the example: the only calibration source you had available with the appropriate isotope has an active diameter of 20 mm. Is this a big deal? Let's estimate the relative solid angle of the calibration, then take a ratio of the two.

``` r
(cal_rel_solid_angle <- disk_to_disk_solid_angle(r.source = 20, gap = 20, r.detector = 12.5, runs = 1e4, plot.opt = "n"))
#> [1] "The relative solid angle estimate: 0.05304"
#> [1] 0.0530447
```

Correct for the mismatch:

``` r
(cf <- cal_rel_solid_angle / as_rel_solid_angle)
#> [1] 1.097752
```

This makes sense - the air sample has particles originating outside the source radius, so more of them will be lost, thus an adjustment is needed for the activity measurement.

**scaler\_sim**

*Scaler counts*: obtain quick distributions for parameters of interest:

``` r
scaler_sim(true_bkg = 50, true_samp = 10, ct_time = 20, trials = 1e5)
```

<img src="man/figures/README-unnamed-chunk-12-1.png" width="50%" />

**rate\_meter\_sim**

*Rate meters*: In the ratemeter simulation, readings are plotted once per second for a default time of 600 seconds. The meter starts with a reading of zero and builds up based on the time constant. Resolution uncertainty is established to express the uncertainty from reading an analog scale, including the instability of its readings. Many standard references identify the precision or resolution uncertainty of analog readings as half of the smallest increment. This should be considered the single coverage uncertainty for a very stable reading. When a reading is not very stable, evaluation of the reading fluctuation is evaluated in terms of numbers of scale increments covered by meter indication over a reasonable evaluation period. Example with default time constant:

``` r
rate_meter_sim(cpm_equilibrium = 270, meter_scale_increments = seq(100, 1000, 20))
```

<img src="man/figures/README-unnamed-chunk-13-1.png" width="50%" />

To estimate *time constant*, use `tau.estimate`

### Stay-time computation

Given a dose rate, dose allowed, and a safety margin (default = 20%), calculate stay time with: `stay_time`

``` r
stay_time(dose_rate = 120, dose_allowed = 100, margin =  20)
#> [1] "Time allowed is 40 minutes"
```

### MCNP utility functions

If you create MCNP inputs, these functions may be helpful:

**si\_hist** and **sp\_hist**

-   Create an *energy distribution* from histogram data with: `si_hist` and `sp_hist` (Load the data into R first using copy and paste with `scan` or reading from an external table with, for example, `read.table`.)

**rot\_fun**

-   Determine the entries needed for MCNP *coordinate transformation rotation* with `rot_fun`

**tan\_d2**

-   Quickly obtain the *cone angle* entry with `tan_d2`

**plot\_spec\_from\_hist**

For *MCNP outputs*, plot the results of a tally with *energy bins*. Either first save your data to a text file, or copy and paste it using `scan2spec.df`. Then plot it using your favorite method, or do a quick plot with `plot_spec_from_hist`:

``` r
plot_spec_from_hist(plot_data, "mR_h", "Example: Cs-137 with scatter")
```

<img src="man/figures/README-unnamed-chunk-16-1.png" width="50%" />
