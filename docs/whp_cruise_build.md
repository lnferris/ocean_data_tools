### whp_cruise_build

#### Syntax

```Matlab
[cruise] = whp_cruise_build(ctdo_dir,uv_dir,wvke_dir,variable_list)
```
#### Description

``[cruise] = whp_cruise_build(ctdo_dir,uv_dir,wvke_dir,variable_list)`` searches pathways ``ctdo_dir``, ``uv_dir``, ``wvke_dir`` for CTD data in whp_netcdf format, horizontal LADCP data in netcdf format, and vertical LACDP data in netcdf format respectively. Variable lists for LADCP are fixed, while the CTD variable list is specified using ``variable_list`` (station, woce_date, longitude, latitude, and pressure are included automatically.) Lat/lon information (metadata) is pulled from the CTD files by default. If CTD is not found, metadata from LACDP files are used instead.

The paths used as arguments should point to data from the *same oceanographic cruise*.

``ctdo_dir`` is a character array search path with wildcards. The search path should be the path to the CTD netcdf files (in whp_netcdf format) themselves, not their directory.

``variable_list`` is a cell array where each element is the string name of a variable to be included from CTD files.

``uv_dir`` is a character array search path with wildcards. The search path should be the path to the horizontal LADCP data netcdf files themselves, not their directory.

``wvke_dir`` is a character array path to all files in the directory. 

Example paths: 

ctdo_dir = '/Users/lnferris/Documents/S14/ctd/\*.nc'; 

uv_dir = '/Users/lnferris/Documents/S14/whp_cruise/uv/\*.nc';

wvke_dir = '/Users/lnferris/Documents/S14/whp_cruise/wvke/';

#### Example 1


```Matlab

% Paths to data:

ctdo_dir = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/whp_cruise/ctd/*.nc'; % included
uv_dir = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/whp_cruise/uv/*.nc'; % included
wvke_dir = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/whp_cruise/wvke/'; % included
bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc'; % need to download

% Get information about available CTD+ variables:

listing = dir(ctdo_dir);
ncdisp([listing(1).folder '/' listing(1).name]) % Peek at netCDF header info to inform choice of variable_list.

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

