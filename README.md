![logo700 ](https://user-images.githubusercontent.com/24570061/84697805-c6f34c00-af1c-11ea-8492-717a562113af.png)

# ocean_data_tools 

[![GitHub license](https://img.shields.io/github/license/lnferris/ocean_data_tools)](https://github.com/lnferris/ocean_data_tools/blob/master/LICENSE) [![GitHub stars](https://img.shields.io/github/stars/lnferris/ocean_data_tools)](https://github.com/lnferris/ocean_data_tools/stargazers) [![GitHub forks](https://img.shields.io/github/forks/lnferris/ocean_data_tools)](https://github.com/lnferris/ocean_data_tools/network) [![GitHub issues](https://img.shields.io/github/issues/lnferris/ocean_data_tools)](https://github.com/lnferris/ocean_data_tools/issues)

**Copyright (c) 2020 lnferris** 

ocean_data_tools Version 1.0 is a toolbox for interacting with freely-available ocean data. The script-based version of ocean_data_tools is archived in ocean_data_tools/archive/. Some functions (WOA, Mercator, HYCOM 3D) have not yet been added. If you need them in the meantime, head on over to the archived version.

The ethos of ocean_data_tools is to build data objects (e.g. argo, cruise, hycom, woa, wod, woa) and call general functions on these objects.

Email lnferris@alum.mit.edu (or open an issue) if you find a bug and we'll get it fixed :)


## Demos

See **demos/demos.m** for examples.

## Dependencies

nctoolbox (https://github.com/nctoolbox/nctoolbox)

## Getting Data

#### Argo Floats

Download argo (www.argo.ucsd.edu)  data directly from GDAC FTP servers using either the Coriolis selection tool (http://www.argodatamgt.org/Access-to-data/Argo-data-selection), or the US GDAC (http://www.usgodae.org/cgi-bin/argo_select.pl).

Alternatively run **shell_scripts/download_argo** to download data via File Transfer Protocol.

#### Bathymetry (Smith & Sandwell)

To get bathymetry data (for bathymetry_dir), download Smith & Sandwell under "Global Topography V19.1" (https://topex.ucsd.edu/marine_topo/) in netcdf form (topo_19.1.nc or topo_20.1.nc).

#### HYCOM

Download subsetted HYCOM data directly using NCSS. Get the data url by visiting https://www.hycom.org/dataserver/gofs-3pt1/analysis. For example, click Access Data Here -> GLBv0.08/expt_57.7 (Jun-01-2017 to Sep-30-2017)/ -> Hindcast Data: Jun-01-2017 to Sep-30-2017. Click on the NetcdfSubset link. Set constraints and copy the NCSS Request URL at the bottom of the page. Run **shell_scripts/download_hycom_lite**.

To download multiple months or years, run **shell_scripts/download_hycom_bulk_daily** (partition files by day) or **shell_scripts/download_hycom_bulk_monthly** (partition files by month). Please use responsibly.

#### Mercator

Download Copernicus Marine data directly from FTP servers. Go to (http://marine.copernicus.eu/services-portfolio/access-to-products/) and make a Copernicus account. Use the selection tool to download GLOBAL_ANALYSIS_FORECAST_PHY_001_024. 

Alternatively run **shell_scripts/download_mercator**. Before running the script, follow the instructions for modifying your ~/.netrc file in the comments of the script.

#### MOCHA

The url is embedded.

#### WHP Cruise (GO-SHIP)

Get data CTD data (for ctdo_dir) by choosing a GO-SHIP cruise (https://cchdo.ucsd.edu/search?q=GO-SHIP) and downloading the CTD data in whp_netcdf format. 
Visit (https://exchange-format.readthedocs.io/en/latest/index.html#) for information about whp_netcdf parameters, specific to GO-SHIP.

Get LADCP data (for uv_dir, wke_dir) at https://currents.soest.hawaii.edu/go-ship/ladcp/.

#### World Ocean Atlas (WOA)

Functions build the url based on arguments, but coarser resolutions and seasonal climatologies are available at (https://www.nodc.noaa.gov/OC5/woa18/woa18data.html). Note NCEI is scheduled to update data urls in the near future. Functions will be updated as such.

#### World Ocean Database (WOD)

Search and select World Ocean Database data at (https://www.nodc.noaa.gov/OC5/SELECT/dbsearch/dbsearch.html).
