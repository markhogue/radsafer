## Revision purpose
This is to match up with RadData with revised index column name. Attempts to depend on RadData (>= 1.0.1) caused error, suspect due to that version not yet issued. Work-around: added if statement to the only function that uses the new column name to work with either the old or new column name.

## Test environments
* local Windows 10 home version R 4.0.5
* passed all checks with devtools::rhub::check(
  platform="windows-x86_64-devel",
  env_vars=c(R_COMPILE_AND_INSTALL_PACKAGES = "always")
) and devtools::check_win_devel()

## R CMD check results
There were no ERRORs or NOTES. There was one warning, about qpdf, which has been discussed in R-package-devel Digest, Vol 60, Issue 17 as not available. There is no change to the pdf in the vignette in this package and no issue with pdf size is anticipated.
