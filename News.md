
# radsafer (version 2.2.1)

***2020-06-07*** Removed deprecated search functions that have been
replaced by searches starting with RN.

# radsafer (version 2.2.0)

***2020-02-21*** Improved plotting functions – discrete energy spectra
with lollipop plots (`RN_plot_spectrum`) and histograms plotted with
steps between energy bins `ggplot2::geom_step(direction = 'vh')` (in
`mcnp_plot_out_spec`). Added the `ggtheme` package’s `theme_calc` for
radionuclide plots (`RN_plot_spectrum`). In case users want to just get
a plot form MCNP or, possibly other histogram data, they can now do it
with one step (`mcnp_scan2plot`). The scan-in function, now called
`mcnp_scan_save`, can now scan in 4-column source histogram data from
output files in addition to the three-column output spectra. The two
column scan went away for lack of any known application, but can be put
back in if anyone needs it - use the maintainer email listed in the
package description. Some function renaming was done to make it easier
for users to select a helpful function, for example, `search_alpha_by_E`
is now `RN_search_alpha_by_E`. Renamed functions will have a warning to
use the new function name and these functions will be removed in a later
version. Previously deprecated functions were also removed and
documentation was improved.

# radsafer (version 2.1.0)

***2019-12-17*** Many improvements in rad measurements family plots. Bug
corrections in mcnp tools family, especially mcnp\_si\_sp\_hist, plus
split off of copy and paste version as mcnp\_si\_sp\_hist\_scan. New
function in radionuclides family - RN\_find\_parents - to find out where
a radionuclide may have decayed from. A vignette for overview of the
package is added.

# radsafer (version 2.0.1)

***2019-05-27*** This version is to be submitted to CRAN. Bug removal on
dk\_activity. Updated examples in many functions to identify parameters
at least once.

# radsafer (version 2.0.0.9000)

***2019-05-23*** Repaired a bug in dk\_activity. Working on improvements
in overall ease of use. Expecting an update to CRAN in a couple of
weeks.

# radsafer (version 2.0.0)

***2019-05-05*** Hurray\! This is the grand opening of radsafer\! The
ICRP 107 data in RadData is now effectively utilized for radionuclide
screening, plots, and use with MCNP. MCNP utilities have been expanded -
see the Readme file for details.

# radsafer (version 1.0.9000)

***2019-04-21***

New functions have been added to the development version, 1.0.0.9000.
Several of the existing functions have had slight changes, including
name changes that will help make the package easier to use going
forward.

# radsafer (version 1.0.0)

***2019-04-06***

Big news\! **radsafer** is now available from CRAN\! So, we should be
announcing the grand opening, right?

But wait. **RadData** (<https://github.com/markhogue/RadData>) has also
just been issued by CRAN. So, this is the soft opening for just a few
close friends because a much more compelling version of **radsafer**
will be out soon. It is going to have some really helpful functions for
accessing, screening, plotting, and making inputs from **RadData**.

Here’s the backstory of **radsafer** and **RadData**. Here at radsafer
world headquarters, we were all excited when we figured out what we
could do with access to the ICRP 107 Nuclear Decay Data for Dosimetric
Calculations. So excited, we wanted to share it, along with a bunch of
other generally helpful health physics functions. But then, we found we
couldn’t meet CRAN’s size limit of 5 MB with all that data. Then, we had
other issues to deal with and were not sure if **RadData** would ever
get off the ground. So, we pursued, in parallel, issuing a lighter
**radsafer** and **RadData**. And now, suddenly, success has arrived at
the same time on both projects\! We’re so psyched\!

So, stay tuned, friends. **radsafer** will be out with version 1.1.0
probably around early May 2019. Then we’ll announce it to all the world.
