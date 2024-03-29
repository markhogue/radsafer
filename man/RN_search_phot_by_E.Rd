% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RN_search_phot_by_E.R
\name{RN_search_phot_by_E}
\alias{RN_search_phot_by_E}
\title{Search for photon}
\usage{
RN_search_phot_by_E(
  E_min = 0,
  E_max = 10,
  min_half_life_seconds = NULL,
  max_half_life_seconds = NULL,
  min_prob = 0
)
}
\arguments{
\item{E_min}{minimum energy in MeV, default = 0}

\item{E_max}{maximum energy in MeV, default = 10}

\item{min_half_life_seconds}{minimum half-life in seconds.
Use multiplier as needed, e.g. 3 * 3600 for 3 hours. Default = NULL,}

\item{max_half_life_seconds}{maximum half-life. See min_half_life_seconds.}

\item{min_prob}{minimum probability with default = 0.}
}
\value{
search results in order of half-life. Recommend assigning
results to a viewable object, such as 'search_results'
}
\description{
Search for photon emission based on energy, half-life and minimum probability.
}
\examples{
# between 1 and 1.2 MeV, between 6 and 6.2 hours half-life,
# ... probability at least 1e-4
search_results <- RN_search_phot_by_E(1, 1.2, 6 * 3600, 6.2 * 3600, 1e-4)

# between 0.1 and 0.15 MeV, between 1 and 3 million years half-life
search_results <- RN_search_phot_by_E(0.1, 0.15, 1e6 * 3.153e7, 3e6 * 3.153e7)
}
\seealso{
\code{\link[=RN_plot_spectrum]{RN_plot_spectrum()}}

Other radionuclides: 
\code{\link{RN_Spec_Act}()},
\code{\link{RN_bin_screen_phot}()},
\code{\link{RN_index_screen}()},
\code{\link{RN_info}()},
\code{\link{RN_plot_search_results}()},
\code{\link{RN_plot_spectrum}()},
\code{\link{RN_save_spectrum}()},
\code{\link{RN_search_alpha_by_E}()},
\code{\link{RN_search_beta_by_E}()}
}
\concept{radionuclides}
