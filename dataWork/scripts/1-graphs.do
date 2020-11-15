* **********************************************************************
* Project: AQ-lockdowns
* Created: November 2020
* Last modified: 2020/11/15 by ET
* Stata v.16.1
* **********************************************************************
* Make pretty figures

* **********************************************************************
* 1 - Set panel structure
* **********************************************************************

* Set panel
  xtset city date


* **********************************************************************
* 2 - Transform data
* **********************************************************************

* Looks log-linear to me
  gen             logpm = log(pm)
  label var       logpm   "log(PM2.5)"

* **********************************************************************
* 2 - Make pretty graphs
* **********************************************************************
* Line graph
  twoway      (line logpm date if city == 1) /// 
              (line logpm date if city == 2) ///
              (line logpm date if city == 3) ///
              (line logpm date if city == 4)
