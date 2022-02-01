## Revision purpose
Two functions for providing source energy distributions for MCNP have been updated to make them easier to use. Previously, version 2.2.2 implemented a CRAN requirement in `mcnp_si_sp_hist` and `mcnp_si_sp_RD` to ensure users gave consent to any file writing. This was implemented with a required 'y' response to a dialog in the console. This has proven to be cumbersome and prevented use of these functions in R markdown files. This version changes the permission to a function parameter that defaults to 'n', retaining the permission requirement while allowing greater ease of use.

## Test environments
* local Windows 10 home version R 4.1.2
* passed all checks with devtools::rhub::check(
  platform="windows-x86_64-devel",
  env_vars=c(R_COMPILE_AND_INSTALL_PACKAGES = "always")
) and devtools::check_win_devel()

## R CMD check results
There were no ERRORs or NOTEs when running devtools::check() with default parameters. There was a warning about qpdf, which has been discussed in R-package-devel Digest, Vol 60, Issue 17 as not available. This warning went away when devtools::check(cran = FALSE) was used. The only change in the vignette in this revision was to correct an erroneous space.
