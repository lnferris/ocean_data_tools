### glider_build

#### Syntax

```Matlab
[glider] = glider_build(glider_dir)
[glider] = glider_build(glider_dir,variable_list)
```
#### Description

``[glider] = glider_build(glider_dir,variable_list)`` loads data (a single netCDF file downloaded from [gliders.ioos.us/erddap](https://gliders.ioos.us/erddap/index.html)) from ``glider_dir`` into struct array ``glider``. Glider profiles are loaded with all variables specified in ``variable_list``. 

The only required argument is ``glider_dir``. By default, the following variables are loaded:
```
'profile_id'
'time'
'latitude'
'longitude'
'precise_time'
'depth'
'pressure'
'temperature'
'conductivity'
'salinity'
'density'
'precise_lat'
'precise_lon'
'time_uv'
'lat_uv',
'lon_uv'
'u'
'v' 
```

This default list can be overridden by passing a user-defined ``variable_list``, a cell array where each element is the string name of a variable. 

``glider_dir`` is a character array search path to a single netcdf file downloaded from gliders.ioos.us/erddap). The path should be the path to the netcdf file itself, not its directory. 

#### Example 1


```Matlab

% Get variable information:

glider_dir = '/Users/lnferris/Desktop/ce_311-20170725T1930.nc';  % included
ncdisp(glider_dir) % Peek at netCDF header info to inform choice of variable_list.

% Load glider data:

[glider] = glider_build(glider_dir); 

% Make plots:

figure
general_map(glider,bathymetry_dir)

figure
general_section(glider,'salinity','km','depth')

```
<img src="https://user-images.githubusercontent.com/24570061/94057510-b66d3000-fdad-11ea-8261-c2dddbf72439.png" width="600">
<img src="https://user-images.githubusercontent.com/24570061/94057516-b79e5d00-fdad-11ea-85e0-3e274feff845.png" width="600">

[Back](https://github.com/lnferris/ocean_data_tools#building-uniform-structs-from-data-sources-1)

