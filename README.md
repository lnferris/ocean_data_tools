![84697805-c6f34c00-af1c-11ea-8492-717a562113af](https://user-images.githubusercontent.com/24570061/85356569-4664ba80-b4dd-11ea-9ec7-8ec26df76dcf.png)

# ocean_data_tools 

[![GitHub license](https://img.shields.io/github/license/lnferris/ocean_data_tools)](https://github.com/lnferris/ocean_data_tools/blob/master/LICENSE) [![GitHub stars](https://img.shields.io/github/stars/lnferris/ocean_data_tools)](https://github.com/lnferris/ocean_data_tools/stargazers) [![GitHub forks](https://img.shields.io/github/forks/lnferris/ocean_data_tools)](https://github.com/lnferris/ocean_data_tools/network) [![GitHub issues](https://img.shields.io/github/issues/lnferris/ocean_data_tools)](https://github.com/lnferris/ocean_data_tools/issues)

**Copyright (c) 2020 lnferris** 

ocean_data_tools Version 1.0 is a toolbox for interacting with freely-available ocean data. The script-based version of ocean_data_tools is archived as a previous release. The ethos of ocean_data_tools is to build data objects (e.g. argo, cruise, hycom, mercator, woa, wod) and call general functions on these objects. Email lnferris@alum.mit.edu (or open an issue) if you find a bug :)

## Demos

See **demos/demos.m** for examples.

## Dependencies

nctoolbox (https://github.com/nctoolbox/nctoolbox)

## Getting Data

### argo_

Download argo (www.argo.ucsd.edu) data directly from GDAC FTP servers using either the Coriolis selection tool (http://www.argodatamgt.org/Access-to-data/Argo-data-selection), or the US GDAC (http://www.usgodae.org/cgi-bin/argo_select.pl).

Alternatively run **shell_scripts/download_argo** to download data via File Transfer Protocol.

### bathymetry_

To get bathymetry data (for bathymetry_dir), download Smith & Sandwell under "Global Topography V19.1" (https://topex.ucsd.edu/marine_topo/) in netcdf form (topo_19.1.nc or topo_20.1.nc).

### mocha_

The url for MOCHA Mid-Atlantic Bight climatology is embedded. See Rutgers Marine catalog (http://tds.marine.rutgers.edu/thredds/catalog.html).

### model_

For HYCOM, download subsetted data directly using NCSS. Get the data url by visiting https://www.hycom.org/dataserver/gofs-3pt1/analysis. For example, click Access Data Here -> GLBv0.08/expt_57.7 (Jun-01-2017 to Sep-30-2017)/ -> Hindcast Data: Jun-01-2017 to Sep-30-2017. Click on the NetcdfSubset link. Set constraints and copy the NCSS Request URL at the bottom of the page. Run **shell_scripts/download_hycom_lite**. To download multiple months or years, run **shell_scripts/download_hycom_bulk_daily** (partition files by day) or **shell_scripts/download_hycom_bulk_monthly** (partition files by month). Please use responsibly.

For Mercator, download Copernicus Marine data directly from FTP servers. Go to (http://marine.copernicus.eu/services-portfolio/access-to-products/) and make a Copernicus account. Use the selection tool to download GLOBAL_ANALYSIS_FORECAST_PHY_001_024. Alternatively run **shell_scripts/download_mercator**. Before running the script, follow the instructions for modifying your ~/.netrc file in the comments of the script.

### whp_cruise_

For GO-SHIP (https://usgoship.ucsd.edu/hydromap/) data, get CTD data (for ctdo_dir) by choosing a GO-SHIP cruise (https://cchdo.ucsd.edu/search?q=GO-SHIP) and downloading the CTD data in whp_netcdf format. 
Visit (https://exchange-format.readthedocs.io/en/latest/index.html#) for information about whp_netcdf parameters, specific to GO-SHIP. Get LADCP data (for uv_dir, wke_dir) at https://currents.soest.hawaii.edu/go-ship/ladcp/.

### woa_

Functions build the World Ocean Atlas url based on arguments, but coarser resolutions and seasonal climatologies are available at (https://www.nodc.noaa.gov/OC5/woa18/woa18data.html). Note NCEI is scheduled to update data urls in the near future. Functions will be updated as such.

### wod_

Search and select World Ocean Database data at (https://www.nodc.noaa.gov/OC5/SELECT/dbsearch/dbsearch.html).
