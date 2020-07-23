![84697805-c6f34c00-af1c-11ea-8492-717a562113af](https://user-images.githubusercontent.com/24570061/85356569-4664ba80-b4dd-11ea-9ec7-8ec26df76dcf.png)

# ocean_data_tools 

[![GitHub license](https://img.shields.io/github/license/lnferris/ocean_data_tools)](https://github.com/lnferris/ocean_data_tools/blob/master/LICENSE) [![GitHub stars](https://img.shields.io/github/stars/lnferris/ocean_data_tools)](https://github.com/lnferris/ocean_data_tools/stargazers) [![GitHub forks](https://img.shields.io/github/forks/lnferris/ocean_data_tools)](https://github.com/lnferris/ocean_data_tools/network) [![GitHub issues](https://img.shields.io/github/issues/lnferris/ocean_data_tools)](https://github.com/lnferris/ocean_data_tools/issues)

**Copyright (c) 2020 lnferris** 

ocean_data_tools simplifies the process of extracting, formatting, and visualizing freely-available oceanographic data. While there is a wealth of oceanographic data accessible online, some end-users may be dissuaded from utilizing this data due to the overhead associated with batch downloading it and formatting it into usable data structures. ocean_data_tools solves this problem by allowing the user to transform common oceanographic data sources into uniform structs, call generalized functions on these structs, easily perform custom calculations, and make graphics.

Find a bug? Open an issue or email lnferris@alum.mit.edu.

### [Dependencies](#dependencies-1)

### [Getting Started](#getting-started-1)

### [Getting Data](#getting-data-1)

### [Contents](#contents-1)


## Dependencies

nctoolbox (https://github.com/nctoolbox/nctoolbox)

## Getting Started

1. Download bathymetry (see below).
2. Download the nctoolbox (https://github.com/nctoolbox/nctoolbox). This is a dependency. Remember to run the command ``setup_nctoolbox`` before use.
3. Run each demonstration in **demos/demos.m**. All test data (except for bathymetry) is included.

Functions are named using a two-part system. The prefix (``argo_``, ``bathymetry_``, ``general_``, etc.) indicates the appropriate data source, while the suffix (``\_build``, ``\_profiles``, ``\_section``, etc.) indicates the action performed. Functions with the ``\_build`` suffix load raw data into uniform structs (e.g. ``argo``, ``cruise``, ``hycom``, ``mercator``, ``woa``, ``wod``). Uniform structs created by ``\_build`` functions are compatable with any ``general_`` function, as well as functions in the Gibbs-SeaWater (GSW) Oceanographic Toolbox (http://www.teos-10.org/software.htm#1).

Main functions are located in **ocean_data_tools/**. Demonstrations are located in **demos/**. Test datas are located in **data/**. Shell scripts for batch downloading data are located in **shell_scripts/**. While shell scripts can be run directly in a macOS Terminal, running them in Windows requires Cygwin (https://www.cygwin.com/) or similar. Python syntax examples are located in **python/**, which may be grow to become a module in the future.

## Getting Data

### argo_

Download Argo (www.argo.ucsd.edu) data directly from GDAC FTP servers using either the Coriolis selection tool (http://www.argodatamgt.org/Access-to-data/Argo-data-selection), or the US GDAC (http://www.usgodae.org/cgi-bin/argo_select.pl). The Argo User's Manual is found at http://www.argodatamgt.org/Documentation.

Alternatively run **shell_scripts/download_argo** to download data via File Transfer Protocol.

### bathymetry_

To get bathymetry data (for ``bathymetry_dir``), download Smith & Sandwell under "Global Topography V19.1" (https://topex.ucsd.edu/marine_topo/) in netcdf form (topo_20.1.nc).

### mocha_

The url for MOCHA Mid-Atlantic Bight climatology is embedded. See Rutgers Marine catalog (http://tds.marine.rutgers.edu/thredds/catalog.html).

### model_

For HYCOM, download subsetted data directly using NCSS. Get the data url by visiting https://www.hycom.org/dataserver/gofs-3pt1/analysis. For example, click Access Data Here -> GLBv0.08/expt_57.7 (Jun-01-2017 to Sep-30-2017)/ -> Hindcast Data: Jun-01-2017 to Sep-30-2017. Click on the NetcdfSubset link. Set constraints and copy the NCSS Request URL at the bottom of the page. Run **shell_scripts/download_hycom_lite**. To download multiple months or years, run **shell_scripts/download_hycom_bulk_daily** (partition files by day) or **shell_scripts/download_hycom_bulk_monthly** (partition files by month). Please use responsibly.

For Mercator, download Copernicus Marine data directly from FTP servers. Go to http://marine.copernicus.eu/services-portfolio/access-to-products/ and make a Copernicus account. Use the selection tool to download GLOBAL_ANALYSIS_FORECAST_PHY_001_024. Alternatively run **shell_scripts/download_mercator**. Before running the script, follow the instructions for modifying your ~/.netrc file in the comments of the script.

### whp_cruise_

For GO-SHIP (https://usgoship.ucsd.edu/hydromap/) data, get CTD data (for ``ctdo_dir``) by choosing a GO-SHIP cruise (https://cchdo.ucsd.edu/search?q=GO-SHIP) and downloading the CTD data in whp_netcdf format. 
Visit https://exchange-format.readthedocs.io/en/latest/index.html# for information about whp_netcdf parameters, specific to GO-SHIP. Get LADCP data (for ``uv_dir``, ``wke_dir``) at https://currents.soest.hawaii.edu/go-ship/ladcp/. There is information about LACDP processing at https://www.ldeo.columbia.edu/~ant/LADCP.html.

### woa_

Functions build the World Ocean Atlas url based on arguments, but coarser resolutions and seasonal climatologies are available at https://www.nodc.noaa.gov/OC5/woa18/woa18data.html. Note NCEI is scheduled to update data urls in the near future. Functions will be updated as such.

### wod_

Search and select World Ocean Database data at https://www.nodc.noaa.gov/OC5/SELECT/dbsearch/dbsearch.html.

## Contents

#### [Building uniform structs from data sources](#building-uniform-structs-from-data-sources-1)

#### [General functions for subsetting and plotting uniform structs](#general-functions-for-subsetting-and-plotting-uniform-structs-1)

#### [Plotting gridded data without building structs](#plotting-gridded-data-without-building-structs-1)

#### [Adding bathymetry to existing plots](#adding-bathymetry-to-existing-plots-1)

#### [Additional functions for inspecting Argo data](#additional-functions-for-inspecting-argo-data-1)

#### [Miscellaneous utilities](#miscellaneous-utilities-1)


### Building uniform structs from data sources

**argo_build** searches the locally-stored Argo profiles matching the specified region & time period and builds a uniform struct

**mocha_build_profiles** builds a uniform struct of profiles from the MOCHA Mid-Atlantic Bight climatology

**model_build_profiles**  builds a uniform struct of profiles from HYCOM or Operational Mercator CMEMS GLOBAL_ANALYSIS_FORECAST_PHY_001_024

**whp_cruise_build** builds a uniform struct of profiles from GO-SHIP cruise data in WHP-Exchange Format

**woa_build_profiles** builds a uniform struct of profiles from World Ocean Atlas 2018 Statistical Mean for All Decades, Objectively Analyzed Mean Fields

**wod_build** builds a uniform struct of profiles from World Ocean Database data

### General functions for subsetting and plotting uniform structs

**general_depth_subset** subsets a uniform struct by depth

**general_map** plots coordinate locations in a uniform struct, with optional bathymetry contours

**general_profiles** plots vertical profiles in a uniform struct

**general_region_subset** subsets a uniform struct by polygon region

**general_remove_duplicates** removes spatially (or spatially and temporally) non-unique profiles from a uniform struct

**general_section** plots a data section from a uniform struct

### Plotting gridded data without building structs

**mocha_domain_plot** plots a 3-D domain from the MOCHA Mid-Atlantic Bight climatology

**mocha_simple_plot** plots a 2-D layer from the MOCHA Mid-Atlantic Bight climatology

**model_domain_plot** plots a 3-D domain from HYCOM or Operational Mercator CMEMS GLOBAL_ANALYSIS_FORECAST_PHY_001_024

**model_simple_plot** plots a 2-D layer from HYCOM or Operational Mercator CMEMS GLOBAL_ANALYSIS_FORECAST_PHY_001_024

**woa_domain_plot** plots a 3-D domain from World Ocean Atlas 2018 Statistical Mean for All Decades, Objectively Analyzed Mean Fields

**woa_simple_plot** plots a 2-D layer from World Ocean Atlas 2018 Statistical Mean for All Decades, Objectively Analyzed Mean Fields

### Adding bathymetry to existing plots

**bathymetry_chord** adds a slice of Smith & Sandwell Global Topography to a section plot

**bathymetry_extract** extracts a region of Smith & Sandwell Global Topography and outputs as arrays

**bathymetry_plot** adds bathymetry to 2-D (latitude vs. longitude) or 3-D (latitude vs. longitude vs. depth) data plots

**bathymetry_region** finds the rectangular region around a uniform struct to pass as an argument for other bathymetry functions

**bathymetry_section** adds Smith & Sandwell Global Topography to a section from plot using bathymetry data nearest to specified coordinates

### Additional functions for inspecting Argo data

**argo_platform_map** plots locations of Argo profiles in a uniform struct, coloring markers by platform (individual Argo float)

**argo_platform_subset** subsets a uniform struct of Argo data to one platform (individual Argo float)

**argo_profiles_map** plots coordinate locations of Argo profiles in uniform struct argo, using colors corresponding to argo_profiles called on the same struct

**argo_profiles** plots vertical Argo profiles in uniform struct argo, using colors corresponding to argo_profiles_map called on the same struct

### Miscellaneous utilities

**netcdf_info** gets information about the first netcdf file in a path and saves it to a text file

**region_select** creates coordinate list (which represents vertices of a polygon region) by clicking stations on a plot

**transect_select** creates a coordinate list (which represents a virtual transect) by clicking stations on a plot

