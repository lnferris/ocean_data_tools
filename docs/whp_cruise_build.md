### whp_cruise_build

#### Syntax

```Matlab
[cruise] = whp_cruise_build(ctdo_dir,uv_dir,wvke_dir,variable_list)
```
#### Description

``[cruise] = whp_cruise_build(ctdo_dir,uv_dir,wvke_dir,variable_list)`` searches pathways ``ctdo_dir``, ``uv_dir``, ``wvke_dir`` for CTD data in whp_netcdf format, horizontal LADCP data in netcdf format, and vertical LACDP data in netcdf format respectively. Variable lists for LADCP are fixed, while the CTD variable list is specified using ``variable_list`` (station, woce_date, longitude, latitude, and pressure are included automatically.) Lat/lon information (metadata) is pulled from the CTD files by default. If CTD is not found, instead metadata from LACDP files are used.

#### Example 1


```Matlab

% Paths to data:

ctdo_dir = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/whp_cruise/ctd/*.nc'; % included
uv_dir = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/whp_cruise/uv/*.nc'; % included
wvke_dir = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/whp_cruise/wvke/'; % included
bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc'; % need to download

% Get information about available CTD+ variables:

netcdf_info(ctdo_dir) % Get cruise information.
variable_list = {'salinity','temperature','oxygen'};

% Build a uniform struct of cruise data:

[cruise] = whp_cruise_build(ctdo_dir,uv_dir,wvke_dir,variable_list); % Use a dummy path (e.g. uv_dir ='null') if missing data. 

% Map cruise stations:

general_map(cruise,bathymetry_dir,'2Dcontour')

```
<img src="https://user-images.githubusercontent.com/24570061/88341972-89989000-cd0c-11ea-8961-70c76fc639d8.png" width="700">


```Matlab
% Plot a salinity section:

variable = 'salinity'; % See cruise for options.
xref = 'lon'; % See cruise for options.
zref = 'pressure'; % See cruise for options.
general_section(cruise,variable,xref,zref)

```
<img src="https://user-images.githubusercontent.com/24570061/88346894-7939e280-cd17-11ea-96a2-735db5a527d5.png" width="800">


[Back](https://github.com/lnferris/ocean_data_tools#building-uniform-structs-from-data-sources-1)

