% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mcnp_si_sp_hist_scan.R
\name{mcnp_si_sp_hist_scan}
\alias{mcnp_si_sp_hist_scan}
\title{energy distribution histogram from pasted data}
\usage{
mcnp_si_sp_hist_scan(ebin_mode = "emax", my_dir = NULL)
}
\arguments{
\item{ebin_mode}{Either "emin", lower bounding energy values are entered or "emax", upper bounding energy values are entered. If the length of the energy values scanned in are equal to the bin probabilities, a final bounding value (lowest in emax mode and highest in emin mode) will be scanned in.}

\item{my_dir}{Optional directory. The function will write to the working directory by default.}
}
\value{
A vector of energy bins and probabilities for an energy distribution, formatted as needed for MCNP input. It is designed for copying and pasting into an MCNP input. (The # should be changed to the appropriate distribution number. The data is saved in the global environment and appended to a file in the user's working directory, si_sp.txt. Two plots of the data are provided to the plot window,  one with two linear axes and one with two log axes.
}
\description{
Make MCNP histogram probabilities for energy bins from data copied and pasted to screen.
}
\details{
Data may be identified by named vector, e.g. my_emin_data, or by column of a data frame, e.g. photons_cs137_hist[1] (which is in emax format) and photons_cs137_hist[2] (bin_prob).
}
\examples{
\dontrun{
mcnp_si_sp_hist_scan()
}
}
\seealso{
[mcnp_si_sp_hist()] for data already loaded in R

[mcnp_si_sp_RD()] for data from `RadData`

Other mcnp tools: 
\code{\link{mcnp_cone_angle}()},
\code{\link{mcnp_est_nps}()},
\code{\link{mcnp_matrix_rotations}()},
\code{\link{mcnp_plot_out_spec}()},
\code{\link{mcnp_scan2plot}()},
\code{\link{mcnp_scan_save}()},
\code{\link{mcnp_si_sp_RD}()},
\code{\link{mcnp_si_sp_hist}()}
}
\concept{mcnp tools}
