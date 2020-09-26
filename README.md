# ocean_data_tools: a MATLAB toolbox for interacting with bulk freely-available oceanographic data

<img src="https://user-images.githubusercontent.com/24570061/85356569-4664ba80-b4dd-11ea-9ec7-8ec26df76dcf.png" width="500">

[![GitHub license](https://img.shields.io/github/license/lnferris/ocean_data_tools)](https://github.com/lnferris/ocean_data_tools/blob/master/LICENSE) [![GitHub stars](https://img.shields.io/github/stars/lnferris/ocean_data_tools)](https://github.com/lnferris/ocean_data_tools/stargazers) [![GitHub forks](https://img.shields.io/github/forks/lnferris/ocean_data_tools)](https://github.com/lnferris/ocean_data_tools/network) [![GitHub issues](https://img.shields.io/github/issues/lnferris/ocean_data_tools)](https://github.com/lnferris/ocean_data_tools/issues)
[![View ocean_data_tools on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/80047-ocean_data_tools)

**Copyright (c) 2020 lnferris** 

ocean_data_tools simplifies the process of extracting, formatting, and visualizing freely-available oceanographic data. While a wealth of oceanographic data is accessible online, some end-users may be dissuaded from utilizing this data due to the overhead associated with obtaining and formatting it into usable data structures. ocean_data_tools solves this problem by allowing the user to transform common oceanographic data sources into uniform structs, call generalized functions on these structs, easily perform custom calculations, and make graphics.

Find a bug, have a question, or want to contribute? Open an issue or email lnferris@alum.mit.edu.

### [Getting Started](#getting-started-1)

### [Dependencies](#dependencies-1)

### [Accessing Help](#accessing-help-1)

### [Contents](#contents-1)

### [Finding Data](#finding-data-1)

### [Citing ODT](#citing-odt-1)

## Getting Started

1. Download [bathymetry](#bathymetry).
2. Download [nctoolbox](https://github.com/nctoolbox/nctoolbox). You will need to run the command ``setup_nctoolbox`` at the beginning of each MATLAB session.
3. Add ocean_data_tools and nctoolbox to the path. Specifically, the following folders must be added to the [path](https://www.mathworks.com/help/matlab/matlab_env/what-is-the-matlab-search-path.html):

- ocean_data_tools/ocean_data_tools
- ocean_data_tools/ocean_data_tools/utilities
- nctoolbox/


4. Run each demonstration in **demos/demos.m**, which contains example usages for all functions. All required test data is included in **data/**.

Functions are named using a two-part system. The prefix (``argo_``, ``bathymetry_``, ``general_``, etc.) indicates the appropriate data source, while the suffix (``\_build``, ``\_profiles``, ``\_section``, etc.) indicates the action performed. Functions with the ``\_build`` suffix load raw data into uniform structs (e.g. ``argo``, ``cruise``, ``hycom``, ``mercator``, ``woa``, ``wod``). Uniform structs created by ``\_build`` functions are compatable with any ``general_`` function.

Main functions are located in **ocean_data_tools/**. Demonstrations are located in **demos/**. Test datas are located in **data/**. Shell scripts for batch downloading data are located in **shell_scripts/**. While shell scripts can be run directly in a macOS Terminal, running them in Windows requires [Cygwin](https://www.cygwin.com/) (and perhaps slight modification of commands). Python syntax examples are located in **python/**, which may be grow to become a module in the future.

## Dependencies

The only true dependency is [nctoolbox](https://github.com/nctoolbox/nctoolbox).

It is recommended to also download [Gibbs-SeaWater (GSW) Oceanographic Toolbox](http://www.teos-10.org/software.htm#1). A benefit of ocean_data_tools is that neatly packs data into uniform structs; at which point a user can easily apply custom calculations or functions from other toolboxes such as GSW. See an [example](docs/gsw_example.md).

## Accessing Help

To access help, run the command ``doc ocean_data_tools``.

## Contents

#### [Building uniform structs from data sources](#building-uniform-structs-from-data-sources-1)

#### [General functions for subsetting and plotting uniform structs](#general-functions-for-subsetting-and-plotting-uniform-structs-1)

#### [Plotting gridded data without building structs](#plotting-gridded-data-without-building-structs-1)

#### [Adding bathymetry to existing plots](#adding-bathymetry-to-existing-plots-1)

#### [Additional functions for inspecting Argo data](#additional-functions-for-inspecting-argo-data-1)

#### [Miscellaneous utilities](#miscellaneous-utilities-1)


### Building uniform structs from data sources

**[argo_build](docs/argo_build.md)** searches the locally-stored Argo profiles matching the specified region & time period and builds a uniform struct

**[glider_build](docs/glider_build.md)** loads an archived glider survey (downloaded from gliders.ioos.us/erddap) and builds a uniform struct

**[mocha_build_profiles](docs/mocha_build_profiles.md)** builds a uniform struct of profiles from the MOCHA Mid-Atlantic Bight climatology

**[model_build_profiles](docs/model_build_profiles.md)**  builds a uniform struct of profiles from HYCOM or Operational Mercator CMEMS GLOBAL_ANALYSIS_FORECAST_PHY_001_024

<img src="https://user-images.githubusercontent.com/24570061/88250150-ac776580-cc74-11ea-8c72-cea7cc50b4d9.png" width="700">

**[whp_cruise_build](docs/whp_cruise_build.md)** builds a uniform struct of profiles from GO-SHIP cruise data in WHP-Exchange Format

**[woa_build_profiles](docs/woa_build_profiles.md)** builds a uniform struct of profiles from World Ocean Atlas 2018 Statistical Mean for All Decades, Objectively Analyzed Mean Fields

**[wod_build](docs/wod_build.md)** builds a uniform struct of profiles from World Ocean Database data

*Don't see a function yet for your preferred data source? Email lnferris@alum.mit.edu to request or contribute.*

### General functions for subsetting and plotting uniform structs

**[general_depth_subset](docs/general_depth_subset.md)** subsets a uniform struct by depth

**[general_map](docs/general_map.md)** plots coordinate locations in a uniform struct, with optional bathymetry contours

**[general_profiles](docs/general_profiles.md)** plots vertical profiles in a uniform struct

**[general_region_subset](docs/general_region_subset.md)** subsets a uniform struct by polygon region

<img src="https://user-images.githubusercontent.com/24570061/88250944-358f9c00-cc77-11ea-9b0d-2d582ad186dd.png" width="700">

**[general_remove_duplicates](docs/general_remove_duplicates.md)** removes spatially (or spatially and temporally) non-unique profiles from a uniform struct

**[general_section](docs/general_section.md)** plots a data section from a uniform struct


### Plotting gridded data without building structs

**[mocha_domain_plot](docs/mocha_domain_plot.md)** plots a 3-D domain from the MOCHA Mid-Atlantic Bight climatology

**[mocha_simple_plot](docs/mocha_simple_plot.md)** plots a 2-D layer from the MOCHA Mid-Atlantic Bight climatology

**[model_domain_plot](docs/model_domain_plot.md)** plots a 3-D domain from HYCOM or Operational Mercator CMEMS GLOBAL_ANALYSIS_FORECAST_PHY_001_024

**[model_simple_plot](docs/model_simple_plot.md)** plots a 2-D layer from HYCOM or Operational Mercator CMEMS GLOBAL_ANALYSIS_FORECAST_PHY_001_024

<img src="https://user-images.githubusercontent.com/24570061/88250403-8900ea80-cc75-11ea-8a5d-8a474d2e5c3f.png" width="700">

**[woa_domain_plot](docs/woa_domain_plot.md)** plots a 3-D domain from World Ocean Atlas 2018 Statistical Mean for All Decades, Objectively Analyzed Mean Fields

**[woa_simple_plot](docs/woa_simple_plot.md)** plots a 2-D layer from World Ocean Atlas 2018 Statistical Mean for All Decades, Objectively Analyzed Mean Fields

### Adding bathymetry to existing plots

**[bathymetry_extract](docs/bathymetry_extract.md)** extracts a region of Smith & Sandwell Global Topography and outputs as arrays

**[bathymetry_plot](docs/bathymetry_plot.md)** adds bathymetry to 2-D (latitude vs. longitude) or 3-D (latitude vs. longitude vs. depth) data plots

<img src="https://user-images.githubusercontent.com/24570061/88251161-ed24ae00-cc77-11ea-87d6-0e3b4484764d.jpg" width="700">

**[bounding_region](docs/bounding_region.md)** finds the rectangular region around a uniform struct and/or list of coordinates to pass as an argument for other bathymetry functions

**[bathymetry_section](docs/bathymetry_section.md)** adds Smith & Sandwell Global Topography to a section from plot using bathymetry data nearest to specified coordinates

<img src="https://user-images.githubusercontent.com/24570061/88250660-3d027580-cc76-11ea-808c-f51d5105e420.png" width="700">

### Additional functions for inspecting Argo data

**[argo_platform_map](docs/argo_platform_map.md)** plots locations of Argo profiles in a uniform struct, coloring markers by platform (individual Argo float)

<img src="https://user-images.githubusercontent.com/24570061/88250439-a2099b80-cc75-11ea-9516-ad3d1f65fdf9.jpg" width="700">

**[argo_platform_subset](docs/argo_platform_subset.md)** subsets a uniform struct of Argo data to one platform (individual Argo float)

**[argo_profiles_map](docs/argo_profiles_map.md)** plots coordinate locations of Argo profiles in uniform struct argo, using colors corresponding to argo_profiles called on the same struct

**[argo_profiles](docs/argo_profiles.md)** plots vertical Argo profiles in uniform struct argo, using colors corresponding to argo_profiles_map called on the same struct


### Miscellaneous utilities

**[region_select](docs/region_select.md)** creates coordinate list (which represents vertices of a polygon region) by clicking stations on a plot

**[transect_select](docs/transect_select.md)** creates a coordinate list (which represents a virtual transect) by clicking stations on a plot

<img src="https://user-images.githubusercontent.com/24570061/88250639-2b20d280-cc76-11ea-9c94-3ce16300f735.png" width="700">


## Finding Data

There two types of datasets: those that need to be downloaded manually<sup>1</sup> and those that can be accessed remotely<sup>2</sup> through OpenDAP (e.g. the data can be accessed directly on the the internet using a url). 

#### argo<sup>1</sup>

Download [Argo data](https://argo.ucsd.edu/) directly from GDAC FTP servers using either the [Coriolis selection tool](http://www.argodatamgt.org/Access-to-data/Argo-data-selection), or the [US GDAC](https://nrlgodae1.nrlmry.navy.mil/cgi-bin/argo_select.pl). See the [Argo User's Manual](http://www.argodatamgt.org/Documentation) for more information.

Alternatively run **shell_scripts/download_argo** to download data via File Transfer Protocol.

#### bathymetry<sup>1</sup>

To get bathymetry data (for ``bathymetry_dir``), download Smith & Sandwell under [Global Topography V19.1](https://topex.ucsd.edu/marine_topo/) in netcdf form (topo_20.1.nc).

#### glider<sup>1</sup>

Vist [gliders.ioos.us/erddap](https://gliders.ioos.us/erddap/index.html). Click "View a List of All 779 Datasets" or use the "Advanced Search". After choosing a dataset, navigate to the [Data Access Form](https://gliders.ioos.us/erddap/tabledap/ce_311-20170725T1930-delayed.html). To get started, select these variables:

<img src="https://user-images.githubusercontent.com/24570061/94058620-419af580-fdaf-11ea-859a-616c8b5b1433.png" width="700">

Scroll to "File type:". In the drop-down menu, select ".nc". Click "Submit".

#### mocha<sup>2</sup>

The url for MOCHA Mid-Atlantic Bight climatology is embedded. See [Rutgers Marine catalog](http://tds.marine.rutgers.edu/thredds/catalog.html).

#### model<sup>1,2</sup>

HYCOM data may be accessed remotely using OpenDAP. Get the data url by visiting the [HYCOM website](https://www.hycom.org/dataserver/gofs-3pt1/analysis). For example, click Access Data Here -> GLBv0.08/expt_57.7 (Jun-01-2017 to Sep-30-2017)/ -> Hindcast Data: Jun-01-2017 to Sep-30-2017. Click on the OpenDAP link. Copy the url as and use this as the ``source`` in ``model_build_profiles``.

Alteratively, download subsetted HYCOM data using NCSS. Get the data url by visiting the [HYCOM website](https://www.hycom.org/dataserver/gofs-3pt1/analysis). For example, click Access Data Here -> GLBv0.08/expt_57.7 (Jun-01-2017 to Sep-30-2017)/ -> Hindcast Data: Jun-01-2017 to Sep-30-2017. Click on the NetcdfSubset link. Set constraints and copy the NCSS Request URL at the bottom of the page. Run **shell_scripts/download_hycom_lite**. To download multiple months or years, run **shell_scripts/download_hycom_bulk_daily** (partition files by day) or **shell_scripts/download_hycom_bulk_monthly** (partition files by month). Please use responsibly.

For Mercator, download Copernicus Marine data directly from FTP servers. First make a [Copernicus account](http://marine.copernicus.eu/services-portfolio/access-to-products/). Use the selection tool to download GLOBAL_ANALYSIS_FORECAST_PHY_001_024. Alternatively run **shell_scripts/download_mercator**. Before running the script, follow the instructions for modifying your ~/.netrc file in the comments of the script.

#### whp_cruise<sup>1</sup>

For [GO-SHIP data](https://usgoship.ucsd.edu/hydromap/), get CTD data (for ``ctdo_dir``) by choosing a [GO-SHIP cruise](https://cchdo.ucsd.edu/search?q=GO-SHIP) and downloading the CTD data in whp_netcdf format. More information about whp_netcdf parameters is available [here](https://exchange-format.readthedocs.io/en/latest/index.html#). Get LADCP data (for ``uv_dir``, ``wke_dir``) [here](https://currents.soest.hawaii.edu/go-ship/ladcp/). There is information about LACDP processing [here](https://www.ldeo.columbia.edu/~ant/LADCP.html).

#### woa<sup>2</sup>

Functions build the World Ocean Atlas url at maximum resolution based on arguments, but coarser resolutions and seasonal climatologies are available at the [NODC website](https://www.nodc.noaa.gov/OC5/woa18/woa18data.html). Note NCEI is scheduled to update data urls in the near future. Functions will be updated as such.

#### wod<sup>1</sup>

Search the [World Ocean Database](https://www.nodc.noaa.gov/OC5/SELECT/dbsearch/dbsearch.html) and select products.

## Citing ODT

Cite as:

*Ferris, L., (2020): ocean_data_tools: A MATLAB toolbox for interacting with bulk freely-available oceanographic data. July. Zenodo. doi:10.5281/zenodo.3353610.*

