![84697805-c6f34c00-af1c-11ea-8492-717a562113af](https://user-images.githubusercontent.com/24570061/85356569-4664ba80-b4dd-11ea-9ec7-8ec26df76dcf.png)

# ocean_data_tools 

[![GitHub license](https://img.shields.io/github/license/lnferris/ocean_data_tools)](https://github.com/lnferris/ocean_data_tools/blob/master/LICENSE) [![GitHub stars](https://img.shields.io/github/stars/lnferris/ocean_data_tools)](https://github.com/lnferris/ocean_data_tools/stargazers) [![GitHub forks](https://img.shields.io/github/forks/lnferris/ocean_data_tools)](https://github.com/lnferris/ocean_data_tools/network) [![GitHub issues](https://img.shields.io/github/issues/lnferris/ocean_data_tools)](https://github.com/lnferris/ocean_data_tools/issues)

**Copyright (c) 2020 lnferris** 

ocean_data_tools simplifies the process of extracting, formatting, and visualizing freely-available oceanographic data. While there is a wealth of oceanographic data accessible online, some end-users may be dissuaded from utilizing this data due to the overhead associated with batch downloading it and formatting it into usable data structures. ocean_data_tools solves this problem by allowing the user to transform common oceanographic data sources into uniform structs (e.g. argo, cruise, hycom, mercator, woa, wod), call generalized functions on these structs, easily perform custom calculations, and make graphics.

Find a bug? Open an issue or contact lnferris@alum.mit.edu.

## Dependencies

nctoolbox (https://github.com/nctoolbox/nctoolbox)

## Organization

All functions are located in **ocean_data_tools/**. Demonstrations and snapshots are located in **demos/**. Datasets to use with the demonstrations are located in **data/**. Shell scripts for batch downloading data are located in **shell_scripts/**; while shell scripts can be run directly in a macOS Terminal, running them in Windows requires Cygwin (https://www.cygwin.com/) or similar. Python syntax examples are located in **python/**, which might be expanded at a later date.

Functions are named using a two-part system. The prefix (argo_, bathymetry_, general_, etc.) indicates the appropriate data source, while the suffix (\_build, \_profiles, \_section, etc.) indicates the action performed. The **\_build** suffix is special because it loads raw data into uniform structs (e.g. argo, cruise, hycom, mercator, woa, wod). Uniform structs created by **\_build** are compatable with general_ functions.

## Getting Started

1. Download bathymetry (see below).
2. Download the nctoolbox (https://github.com/nctoolbox/nctoolbox).
3. Run each demonstration in **demos/demos.m**.

## Getting Data

### argo_

Download argo (www.argo.ucsd.edu) data directly from GDAC FTP servers using either the Coriolis selection tool (http://www.argodatamgt.org/Access-to-data/Argo-data-selection), or the US GDAC (http://www.usgodae.org/cgi-bin/argo_select.pl).

Alternatively run **shell_scripts/download_argo** to download data via File Transfer Protocol.

### bathymetry_

To get bathymetry data (for bathymetry_dir), download Smith & Sandwell under "Global Topography V19.1" (https://topex.ucsd.edu/marine_topo/) in netcdf form (topo_20.1.nc).

### mocha_

The url for MOCHA Mid-Atlantic Bight climatology is embedded. See Rutgers Marine catalog (http://tds.marine.rutgers.edu/thredds/catalog.html).

### model_

For HYCOM, download subsetted data directly using NCSS. Get the data url by visiting https://www.hycom.org/dataserver/gofs-3pt1/analysis. For example, click Access Data Here -> GLBv0.08/expt_57.7 (Jun-01-2017 to Sep-30-2017)/ -> Hindcast Data: Jun-01-2017 to Sep-30-2017. Click on the NetcdfSubset link. Set constraints and copy the NCSS Request URL at the bottom of the page. Run **shell_scripts/download_hycom_lite**. To download multiple months or years, run **shell_scripts/download_hycom_bulk_daily** (partition files by day) or **shell_scripts/download_hycom_bulk_monthly** (partition files by month). Please use responsibly.

For Mercator, download Copernicus Marine data directly from FTP servers. Go to http://marine.copernicus.eu/services-portfolio/access-to-products/ and make a Copernicus account. Use the selection tool to download GLOBAL_ANALYSIS_FORECAST_PHY_001_024. Alternatively run **shell_scripts/download_mercator**. Before running the script, follow the instructions for modifying your ~/.netrc file in the comments of the script.

### whp_cruise_

For GO-SHIP (https://usgoship.ucsd.edu/hydromap/) data, get CTD data (for ctdo_dir) by choosing a GO-SHIP cruise (https://cchdo.ucsd.edu/search?q=GO-SHIP) and downloading the CTD data in whp_netcdf format. 
Visit https://exchange-format.readthedocs.io/en/latest/index.html# for information about whp_netcdf parameters, specific to GO-SHIP. Get LADCP data (for uv_dir, wke_dir) at https://currents.soest.hawaii.edu/go-ship/ladcp/. There is information about LACDP processing at https://www.ldeo.columbia.edu/~ant/LADCP.html.

### woa_

Functions build the World Ocean Atlas url based on arguments, but coarser resolutions and seasonal climatologies are available at https://www.nodc.noaa.gov/OC5/woa18/woa18data.html. Note NCEI is scheduled to update data urls in the near future. Functions will be updated as such.

### wod_

Search and select World Ocean Database data at https://www.nodc.noaa.gov/OC5/SELECT/dbsearch/dbsearch.html.
