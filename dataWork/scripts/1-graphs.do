* **********************************************************************
* Project: AQ-lockdowns
* Created: November 2020
* Last modified: 2020/11/15 by ET
* Stata v.16.1
* **********************************************************************
* Make pretty figures & summary stats


* **********************************************************************
* 0 - Open data
* **********************************************************************
  use "$dataWork/data/inter/hourlyPM", clear

* **********************************************************************
* 1 - Summarize the data
* **********************************************************************
* Let's summarize the data
  eststo sumStats: estpost tabstat pm logpm, by(city)          ///
         statistics(mean sd min max) columns(statistics)

  esttab sumStats using $dataWork/output/tables/summaryStats.tex,  ///
         cell("mean sd min max")                                   ///
         wide noobs label nonote nomtitle nonumber                 ///
         title(Summary statistics\label{tab:sumStats}) replace

* **********************************************************************
* 2 - Make pretty graphs
* **********************************************************************
* Make a week-city id
  egen        city_year = group(city year), label

* Scatter all together
  // twoway      (scatter logpm week, by(city_year))   // not very informative

* Set some graph options
	local line1       = "lcolor(gs5%80) msymb(none) lpattern(solid) lwidth(medthick)"
	local scatter1    = "msymb(o) mcolor(gs10%05) jitter(2)"

	local line2       = "lcolor(ebblue%80) msymb(none) lpattern(solid) lwidth(medthick)"
	local scatter2    = "msymb(o) mcolor(gs10%05) jitter(2)"

	local line3       = "lcolor(dkorange%80) msymb(none) lpattern(solid) lwidth(medthick)"
	local scatter3    = "msymb(o) mcolor(gs10%05) jitter(2)"

	local line4       = "lcolor(cranberry%80) msymb(none) lpattern(solid) lwidth(medthick)"
	local scatter4    = "msymb(oh) mcolor(cranberry%10) jitter(2)"


* Scatter Kampala, week
  sort city year week
  twoway    (scatter logpm week if city_year == 1, `scatter1')       ///
            (scatter logpm week if city_year == 2, `scatter2')       ///
            (scatter logpm week if city_year == 3, `scatter3')       ///
            (scatter logpm week if city_year == 4, `scatter4')       ///
            (connected logpm_week week if city_year == 1, `line1')   ///
            (connected logpm_week week if city_year == 2, `line2')   ///
            (connected logpm_week week if city_year == 3, `line3')   ///
            (connected logpm_week week if city_year == 4, `line4')   ///
            , legend(cols(4)                                         ///
            order(5 "Kampala, 2017" 6 "Kampala, 2018" 7             ///
            "Kampala, 2019" 8 "Kampala, 2020") pos(6))               ///
            ytitle("Log(PM 2.5)")

graph export "$dataWork/output/figs/Kampala_week.pdf", replace

* Scatter Addis, week
  sort city year week
  twoway    (scatter logpm week if city_year == 5, `scatter1')       ///
            (scatter logpm week if city_year == 6, `scatter2')       ///
            (scatter logpm week if city_year == 7, `scatter3')       ///
            (scatter logpm week if city_year == 8, `scatter4')       ///
            (connected logpm_week week if city_year == 5, `line1')   ///
            (connected logpm_week week if city_year == 6, `line2')   ///
            (connected logpm_week week if city_year == 7, `line3')   ///
            (connected logpm_week week if city_year == 8, `line4')   ///
            , legend(cols(4)                                         ///
            order(5 "Addis, 2017" 6 "Addis, 2018" 7             ///
            "Addis, 2019" 8 "Addis, 2020") pos(6))               ///
            ytitle("Log(PM 2.5)")

graph export "$dataWork/output/figs/Addis_week.pdf", replace

* Scatter Kigali, week
  sort city year week
  twoway    (scatter logpm week if city_year == 11, `scatter3')       ///
            (scatter logpm week if city_year == 12, `scatter4')       ///
            (connected logpm_week week if city_year == 11, `line3')   ///
            (connected logpm_week week if city_year == 12, `line4')   ///
            , legend(cols(4)                                          ///
            order(3 "Kigali, 2019" 4 "Kigali, 2020") pos(6))         ///
            ytitle("Log(PM 2.5)")

graph export "$dataWork/output/figs/Kigali_week.pdf", replace


* Scatter Nairobi, week
  sort city year week
  twoway    (scatter logpm week if city_year == 16, `scatter4')       ///
            (connected logpm_week week if city_year == 16, `line4')   ///
            , legend(cols(4)                                          ///
            order(2 "Nairobi, 2020") pos(6))                          ///
            ytitle("Log(PM 2.5)")

graph export "$dataWork/output/figs/Nairobi_week.pdf", replace


// * Scatter Kampala, day
//   sort city year day
//   twoway    (scatter logpm day if city_year == 1, `scatter1')       ///
//             (scatter logpm day if city_year == 2, `scatter2')       ///
//             (scatter logpm day if city_year == 3, `scatter3')       ///
//             (scatter logpm day if city_year == 4, `scatter4')       ///
//             (connected logpm_day day if city_year == 1, `line1')   ///
//             (connected logpm_day day if city_year == 2, `line2')   ///
//             (connected logpm_day day if city_year == 3, `line3')    ///
//             (connected logpm_day day if city_year == 4, `line4')


  // twoway      (scatter logpm week if city_year == 1, `density1')    ///
  //             (scatter logpm week if city_year == 2, `density2')    ///
  //             (scatter logpm week if city_year == 3, `density3')    ///
  //             (scatter logpm week if city_year == 4, `density4')


* Copy outputs to Overleaf
  * Grab filenames in output/tables
  local tables : dir "$dataWork/output/tables" files *

* Loop over all files in outputs/tables
  foreach filename of local tables {
    copy        "$dataWork/output/tables/`filename'"             ///
                "$dropbox/Apps/Overleaf/CovidAirQuality/tables/`filename'"  ///
                , replace
  }
