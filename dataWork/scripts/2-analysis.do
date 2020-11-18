* **********************************************************************
* Project: AQ-lockdowns
* Created: November 2020
* Last modified: 2020/11/15 by ET
* Stata v.16.1
* **********************************************************************
* Run basic diff-in-diff


* **********************************************************************
* 0 - Open data
* **********************************************************************
  use "$dataWork/data/inter/hourlyPM", clear

* Run DiD regression
eststo clear
eststo nofe: reghdfe logpm i.treat##i.lockdown, noabsorb vce(cluster month)
eststo week: reghdfe logpm i.treat##i.lockdown, absorb(week) vce(cluster month)
eststo month: reghdfe logpm i.treat##i.lockdown, absorb(month) vce(cluster month)

esttab using "$dataWork/output/tables/did.tex", replace starlevels(* .1 ** .05 *** .01) se ar2 b(a2)     ///
  nonumber nobaselevels noomitted nonote interaction(" x ") label

* Copy outputs to Overleaf
  * Grab filenames in output/tables
  local tables : dir "$dataWork/output/tables" files *

* Loop over all files in outputs/tables
  foreach filename of local tables {
    copy        "$dataWork/output/tables/`filename'"             ///
                "$dropbox/Apps/Overleaf/CovidAirQuality/tables/`filename'"  ///
                , replace
  }
