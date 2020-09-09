## Test environments
* local Windows 10 home version R 4.0.2
* passed all checks with devtools::check_rhub() and devtools::check_win_devel()

## R CMD check results
There were no ERRORs or NOTES. There was one warning, about qpdf, which has been discussed in R-package-devel Digest, Vol 60, Issue 17 as not available. There is no change to the pdf in the vignette in this package and no issue with pdf size is anticipated.
