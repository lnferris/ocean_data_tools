# ocean_data_tools: A MATLAB toolbox for interacting with bulk freely-available oceanographic data.

<img src="https://user-images.githubusercontent.com/24570061/85356569-4664ba80-b4dd-11ea-9ec7-8ec26df76dcf.png" width="500">

[![GitHub license](https://img.shields.io/github/license/lnferris/ocean_data_tools)](https://github.com/lnferris/ocean_data_tools/blob/master/LICENSE) [![GitHub stars](https://img.shields.io/github/stars/lnferris/ocean_data_tools)](https://github.com/lnferris/ocean_data_tools/stargazers) [![GitHub forks](https://img.shields.io/github/forks/lnferris/ocean_data_tools)](https://github.com/lnferris/ocean_data_tools/network) [![GitHub issues](https://img.shields.io/github/issues/lnferris/ocean_data_tools)](https://github.com/lnferris/ocean_data_tools/issues)

**Copyright (c) 2020 lnferris** 

ocean_data_tools simplifies the process of extracting, formatting, and visualizing freely-available oceanographic data. While a wealth of oceanographic data is accessible online, some end-users may be dissuaded from utilizing this data due to the overhead associated with obtaining and formatting it into usable data structures. ocean_data_tools solves this problem by allowing the user to transform common oceanographic data sources into uniform structs, call generalized functions on these structs, easily perform custom calculations, and make graphics.

Find a bug, have a question, or want to contribute? Open an issue or email lnferris@alum.mit.edu.

### [Getting Started](#getting-started-1)

### [Dependencies](#dependencies-1)

### [Contents](#contents-1)

### [Finding Data](#finding-data-1)

## Getting Started

1. Download [bathymetry](#bathymetry_).
2. Download [nctoolbox](https://github.com/nctoolbox/nctoolbox). Run the command ``setup_nctoolbox`` at the beginning of a MATLAB session.
3. Run each demonstration in **demos/demos.m**, which contains example usages for all functions. All required tests data is included in **data/**.

Functions are named using a two-part system. The prefix (``argo_``, ``bathymetry_``, ``general_``, etc.) indicates the appropriate data source, while the suffix (``\_build``, ``\_profiles``, ``\_section``, etc.) indicates the action performed. Functions with the ``\_build`` suffix load raw data into uniform structs (e.g. ``argo``, ``cruise``, ``hycom``, ``mercator``, ``woa``, ``wod``). Uniform structs created by ``\_build`` functions are compatable with any ``general_`` function, as well as functions in the [Gibbs-SeaWater (GSW) Oceanographic Toolbox](http://www.teos-10.org/software.htm#1).

Main functions are located in **ocean_data_tools/**. Demonstrations are located in **demos/**. Test datas are located in **data/**. Shell scripts for batch downloading data are located in **shell_scripts/**. While shell scripts can be run directly in a macOS Terminal, running them in Windows requires [Cygwin](https://www.cygwin.com/) or similar. Python syntax examples are located in **python/**, which may be grow to become a module in the future.

## Dependencies

The only true dependency is [nctoolbox](https://github.com/nctoolbox/nctoolbox).

To take full advantage of ocean_data_tools, download [Gibbs-SeaWater (GSW) Oceanographic Toolbox](http://www.teos-10.org/software.htm#1). Uniform structs created by ocean_data_tools are compatable with GSW functions. See an [example](docs/gsw_example.md).

## Contents

#### [Building uniform structs from data sources](#building-uniform-structs-from-data-sources-1)

#### [General functions for subsetting and plotting uniform structs](#general-functions-for-subsetting-and-plotting-uniform-structs-1)

#### [Plotting gridded data without building structs](#plotting-gridded-data-without-building-structs-1)

#### [Adding bathymetry to existing plots](#adding-bathymetry-to-existing-plots-1)

#### [Additional functions for inspecting Argo data](#additional-functions-for-inspecting-argo-data-1)

#### [Miscellaneous utilities](#miscellaneous-utilities-1)


### Building uniform structs from data sources

**[argo_build](docs/argo_build.md)** searches the locally-stored Argo profiles matching the specified region & time period and builds a uniform struct

**[mocha_build_profiles](docs/mocha_build_profiles.md)** builds a uniform struct of profiles from the MOCHA Mid-Atlantic Bight climatology

**[model_build_profiles](docs/model_build_profiles.md)**  builds a uniform struct of profiles from HYCOM or Operational Mercator CMEMS GLOBAL_ANALYSIS_FORECAST_PHY_001_024

<img src="https://user-images.githubusercontent.com/24570061/88250150-ac776580-cc74-11ea-8c72-cea7cc50b4d9.png" width="700">

**[whp_cruise_build](docs/whp_cruise_build.md)** builds a uniform struct of profiles from GO-SHIP cruise data in WHP-Exchange Format

**[woa_build_profiles](docs/woa_build_profiles.md)** builds a uniform struct of profiles from World Ocean Atlas 2018 Statistical Mean for All Decades, Objectively Analyzed Mean Fields

**[wod_build](docs/wod_build.md)** builds a uniform struct of profiles from World Ocean Database data


### General functions for subsetting and plotting uniform structs

**general_depth_subset** subsets a uniform struct by depth

**general_map** plots coordinate locations in a uniform struct, with optional bathymetry contours

**general_profiles** plots vertical profiles in a uniform struct

**[general_region_subset](docs/general_region_subset.md)** subsets a uniform struct by polygon region

<img src="https://user-images.githubusercontent.com/24570061/88250944-358f9c00-cc77-11ea-9b0d-2d582ad186dd.png" width="700">

**general_remove_duplicates** removes spatially (or spatially and temporally) non-unique profiles from a uniform struct

**general_section** plots a data section from a uniform struct


### Plotting gridded data without building structs

**[mocha_domain_plot](docs/mocha_domain_plot.md)** plots a 3-D domain from the MOCHA Mid-Atlantic Bight climatology

**[mocha_simple_plot](docs/mocha_simple_plot.md)** plots a 2-D layer from the MOCHA Mid-Atlantic Bight climatology

**[model_domain_plot](docs/model_domain_plot.md)** plots a 3-D domain from HYCOM or Operational Mercator CMEMS GLOBAL_ANALYSIS_FORECAST_PHY_001_024

**[model_simple_plot](docs/model_simple_plot.md)** plots a 2-D layer from HYCOM or Operational Mercator CMEMS GLOBAL_ANALYSIS_FORECAST_PHY_001_024

<img src="https://user-images.githubusercontent.com/24570061/88250403-8900ea80-cc75-11ea-8a5d-8a474d2e5c3f.png" width="700">

**[woa_domain_plot](docs/woa_domain_plot.md)** plots a 3-D domain from World Ocean Atlas 2018 Statistical Mean for All Decades, Objectively Analyzed Mean Fields

**[woa_simple_plot](docs/woa_simple_plot.md)** plots a 2-D layer from World Ocean Atlas 2018 Statistical Mean for All Decades, Objectively Analyzed Mean Fields

### Adding bathymetry to existing plots

**bathymetry_chord** adds a slice of Smith & Sandwell Global Topography to a section plot

**bathymetry_extract** extracts a region of Smith & Sandwell Global Topography and outputs as arrays

**bathymetry_plot** adds bathymetry to 2-D (latitude vs. longitude) or 3-D (latitude vs. longitude vs. depth) data plots

<img src="https://user-images.githubusercontent.com/24570061/88251161-ed24ae00-cc77-11ea-87d6-0e3b4484764d.jpg" width="700">

**bathymetry_region** finds the rectangular region around a uniform struct to pass as an argument for other bathymetry functions

**bathymetry_section** adds Smith & Sandwell Global Topography to a section from plot using bathymetry data nearest to specified coordinates

<img src="https://user-images.githubusercontent.com/24570061/88250660-3d027580-cc76-11ea-808c-f51d5105e420.png" width="700">

### Additional functions for inspecting Argo data

**[argo_platform_map](docs/argo_platform_map.md)** plots locations of Argo profiles in a uniform struct, coloring markers by platform (individual Argo float)

<img src="https://user-images.githubusercontent.com/24570061/88250439-a2099b80-cc75-11ea-9516-ad3d1f65fdf9.jpg" width="700">

**[argo_platform_subset](docs/argo_platform_subset.md)** subsets a uniform struct of Argo data to one platform (individual Argo float)

**[argo_profiles_map](docs/argo_profiles_map.md)** plots coordinate locations of Argo profiles in uniform struct argo, using colors corresponding to argo_profiles called on the same struct

**[argo_profiles](docs/argo_profiles.md)** plots vertical Argo profiles in uniform struct argo, using colors corresponding to argo_profiles_map called on the same struct


### Miscellaneous utilities

**[netcdf_info](docs/netcdf_info.md)** gets information about the first netcdf file in a path and saves it to a text file

**[region_select](docs/region_select.md)** creates coordinate list (which represents vertices of a polygon region) by clicking stations on a plot

**[transect_select](docs/transect_select.md)** creates a coordinate list (which represents a virtual transect) by clicking stations on a plot

<img src="https://user-images.githubusercontent.com/24570061/88250639-2b20d280-cc76-11ea-9c94-3ce16300f735.png" width="700">


## Finding Data

#### argo

Download [Argo data](www.argo.ucsd.edu) directly from GDAC FTP servers using either the [Coriolis selection tool](http://www.argodatamgt.org/Access-to-data/Argo-data-selection), or the [US GDAC](http://www.usgodae.org/cgi-bin/argo_select.pl). See the [Argo User's Manual](http://www.argodatamgt.org/Documentation) for more information.

Alternatively run **shell_scripts/download_argo** to download data via File Transfer Protocol.

#### bathymetry

To get bathymetry data (for ``bathymetry_dir``), download Smith & Sandwell under [Global Topography V19.1](https://topex.ucsd.edu/marine_topo/) in netcdf form (topo_20.1.nc).

#### mocha

The url for MOCHA Mid-Atlantic Bight climatology is embedded. See [Rutgers Marine catalog](http://tds.marine.rutgers.edu/thredds/catalog.html).

#### model

For HYCOM, download subsetted data directly using NCSS. Get the data url by visiting the [HYCOM website](https://www.hycom.org/dataserver/gofs-3pt1/analysis). For example, click Access Data Here -> GLBv0.08/expt_57.7 (Jun-01-2017 to Sep-30-2017)/ -> Hindcast Data: Jun-01-2017 to Sep-30-2017. Click on the NetcdfSubset link. Set constraints and copy the NCSS Request URL at the bottom of the page. Run **shell_scripts/download_hycom_lite**. To download multiple months or years, run **shell_scripts/download_hycom_bulk_daily** (partition files by day) or **shell_scripts/download_hycom_bulk_monthly** (partition files by month). Please use responsibly.

For Mercator, download Copernicus Marine data directly from FTP servers. First make a [Copernicus account](http://marine.copernicus.eu/services-portfolio/access-to-products/). Use the selection tool to download GLOBAL_ANALYSIS_FORECAST_PHY_001_024. Alternatively run **shell_scripts/download_mercator**. Before running the script, follow the instructions for modifying your ~/.netrc file in the comments of the script.

#### whp_cruise

For [GO-SHIP data](https://usgoship.ucsd.edu/hydromap/), get CTD data (for ``ctdo_dir``) by choosing a [GO-SHIP cruise](https://cchdo.ucsd.edu/search?q=GO-SHIP) and downloading the CTD data in whp_netcdf format. More information about whp_netcdf parameters is available [here](https://exchange-format.readthedocs.io/en/latest/index.html#). Get LADCP data (for ``uv_dir``, ``wke_dir``) [here](https://currents.soest.hawaii.edu/go-ship/ladcp/). There is information about LACDP processing [here](https://www.ldeo.columbia.edu/~ant/LADCP.html).

#### woa

Functions build the World Ocean Atlas url at maximum resolution based on arguments, but coarser resolutions and seasonal climatologies are available at the [NODC website](https://www.nodc.noaa.gov/OC5/woa18/woa18data.html). Note NCEI is scheduled to update data urls in the near future. Functions will be updated as such.

#### wod

Search the [World Ocean Database](https://www.nodc.noaa.gov/OC5/SELECT/dbsearch/dbsearch.html) and select products.

