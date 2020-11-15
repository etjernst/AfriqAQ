* **********************************************************************
* Project: AQ-lockdowns
* Created: November 2020
* Last modified: 2020/11/15 by ET
* Stata v.16.1
* **********************************************************************
* does

* **********************************************************************
* Import and restructure hourly data
	import delimited $dataWork/data/4city_nan_hourly.csv, clear
	rename v1 date_str

* Format date variable (and curse thrice at Stata's date format)
	gen double date = clock(date_str,"YMD hms#")
	format date %tcCCYYmonDD_HH:MM
