## Revision purpose
Adding new function and correcting documentation.

## Test environments
* local Windows 11 home version 22H2
* passed all checks with devtools::rhub::check(
  platform="windows-x86_64-devel",
  env_vars=c(R_COMPILE_AND_INSTALL_PACKAGES = "always")
) and devtools::check_win_devel()

## R CMD check results
There were no ERRORs, WARNINGS or NOTEs when running devtools::check() with default parameters. 
