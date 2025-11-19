## Revision purpose
Removed deprecated functions.  Changed all function messages to be identified as messages. Removed deprecated ggplot2 parameter. Updates and streamlines.

## Test environments
* local Windows 11 home version 25H2
* passed all checks with devtools::rhub::check(
  platform="windows-x86_64-devel",
  env_vars=c(R_COMPILE_AND_INSTALL_PACKAGES = "always")
) and devtools::check_win_devel()

## R CMD check results
There were no ERRORs, WARNINGS or NOTEs when running devtools::check() with default parameters. 
