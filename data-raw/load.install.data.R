# load data for radsafer hist_to_spec.plot
photons_cs137_hist <- read.table("T:/mark/R_radsafer/data-raw/well.irradiator.cs137.dat")
usethis::use_data(photons_cs137_hist, overwrite = T, compress = "xz")
