# ocean_data_tools
Tools for searching, subsetting, and analyzing ocean data.

** ArgoTools.py ** 
Download Argo data (www.argo.ucsd.edu) using either the Coriolis selection tool (http://www.argodatamgt.org/Access-to-data/Argo-data-selection) or the US GDAC (http://www.usgodae.org/cgi-bin/argo_select.pl). Run this Python script to search your data for profiles in a specific region and date range. Make a map of profile locations. Plot vertical profiles.

** ArgoTools.m **
Same as above, but for MATLAB users.

** GOSHIPTools.py **
Choose a GO-SHIP cruise (https://cchdo.ucsd.edu/search?q=GO-SHIP) and download the **CTD** data in **whp_netcdf** format. Run this Python script to load the data into a dataframe, subset the data by date/region, map the station locations, or plot vertical profiles.

** inspect_GOSHIP.py **
Run this script on one of your downloaded GO-SHIP data files to learn which variables are in the file. Visit (https://exchange-format.readthedocs.io/en/latest/index.html#) for information about whp_netcdf parameters.

** HYCOMTools2D.m **
This script requires an internet connection. Get the data url by visiting https://www.hycom.org/dataserver/gofs-3pt1/analysis. For example, click Access Data Here -> GLBv0.08/expt_57.7 (Jun-01-2017 to Sep-30-2017)/ -> Hindcast Data: Jun-01-2017 to Sep-30-2017. Copy the OPENDAP url.
