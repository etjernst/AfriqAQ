* **********************************************************************
* Project: AQ-lockdowns
* Created: November 2020
* Last modified: 2020/11/15 by ET
* Stata v.16.1
* **********************************************************************
* Imports PM2.5 data and reshapes to long format

* **********************************************************************
* 1 - Import, label, and reshape data
* **********************************************************************
* Import and restructure hourly data
  import delimited $dataWork/data/4city_nan_hourly.csv, clear
  rename v1 date_str

  rename    kampala               pm1
  rename    kampala_lockdown      lockdown1
  rename    addis_central         pm2
  rename    addis_central         lockdown2
  rename    kigali                pm3
  rename    kigali_lockdown       lockdown3
  rename    nairobi               pm4
  rename    nairobi_lockdown      lockdown4

* Reshape data --> long
  reshape   long                  pm lockdown, i(date_str) j(city)

* Format date variable (and curse thrice at Stata's date format)
  gen double        date      = clock(date_str,"YMD hms#")
  format            date      %tcCCYYmonDD_HH:MM

  * Label city variable
  label def          city     1 "Kampala" 2 "Addis" 3 "Kigali" 4 "Nairobi"
  label val          city     city

* Label other variables
  label var        date_str         "Date (string)"
  label var        date             "Date"
  label var        city             "City"
  label var        pm               "PM2.5"
  label var        lockdown         "Beginning of lockdown"

* **********************************************************************
* 2 - Generate variables
* **********************************************************************

* Generate treatment variables
  gen treat       = (city == 1) + (city == 3) + (city == 4)

* Sort data
  sort city date

* Add metadata and save
  customsave,  idvar(date) filename("hourlyPM") path("$dataWork/data/inter") ///
              dofile("0-import.do") description("Hourly data for DiD") noidok

  export delimited            "$dataWork/data/inter/4cityHourly.csv", replace
