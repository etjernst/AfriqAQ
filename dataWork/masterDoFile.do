* **********************************************************************
* Project: AQ-lockdowns
* Created: November 2020
* Last modified: 2020/11/15 by ET
* Stata v.16.1

* Note: file directory is set in section 0
* users only need to change the location of their path there
* or their initials
* **********************************************************************
* does
    /* This code runs all do-files needed for data work.

    Further, this master .do file maps all files within the data folder
    and serves as the starting point to find any do-file, dataset or output. */

* dependencies
	* for packages/commands, make a local containing any required packages
        local userpack "blindschemes.sthlp estout reghdfe ftools"

* TO DO:
    * Update code with customsave
    * Write separate .ado file with some of the boilerplate stuff?
    * move directory creation out of here too
    * combine code in section 0 (b)

* **********************************************************************
* 0 - General setup:
*       - users
*       - users' home directories
*       - create folder structures (can be switched off)
* **********************************************************************
* Set $dirCreate to 0 to skip directory creation
        global dirCreate    0

* Set $adoUpdate to 0 to skip updating ado files
        global adoUpdate     0

*   Users can add/change their initials and directories below
*   All subsequent files are referred to using dynamic, absolute filepaths

* User initials:
    * Emilia	            et

* Set this value to the user currently using this file
    global user "et"

* Specify Stata version in use
    global stataVersion 16.1    // set Stata version
    version $stataVersion

* **********************************************************************
* Define root folder globals
    if "$user" == "et" {
        global myDocs "C:/Users/`c(username)'/Desktop/git"
			if "`c(username)'"=="btje4229" {
				global dropbox ///
				"C:/Users/`c(username)'/Dropbox (Personal)"
			}
			else{
				global dropbox "C:/Users/Emilia/Dropbox"
			}
    }

* **********************************************************************
* Create some sub-folder globals
    global projectFolder          "$myDocs/AfriqAQ"
    global dataWork               "$projectFolder/dataWork"
		global config                 "$dataWork/config"

* **********************************************************************
* 0 (b) - Check if any required packages are installed:
* **********************************************************************

foreach package in `userpack' {
	capture : which `package', all
	if (_rc) {
        capture window stopbox rusure "You are missing some packages." "Do you want to install `package'?"
        if _rc == 0 {
            capture ssc install `package', replace
            if (_rc) {
                window stopbox rusure `"This package is not on SSC. Do you want to proceed without it?"'
            }
        }
        else {
            exit 199
        }
	}
}

* Update all ado files
    if $adoUpdate == 1 {
        ado update, update
    }

* **********************************************************************
* Install my metadata .do file
    net install StataConfig, ///
    from(https://raw.githubusercontent.com/etjernst/Materials/master/stata/) replace

* **********************************************************************
* Set graph and Stata preferences
    set scheme plotplain
    set more off
    set logtype text    // so logs can be opened without Stata

* **********************************************************************
* 1 - Clean data
* **********************************************************************

* **********************************************************************
* 2 - Run stuff
* **********************************************************************
