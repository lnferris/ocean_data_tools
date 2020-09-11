### argo_build

#### Syntax

```Matlab
[argo,matching_files] = argo_build(argo_dir,region,start_date,end_date,variable_list)
```
#### Description

``[argo,matching_files] = argo_build(argo_dir,region,start_date,end_date,variable_list)`` searches pathway ``argo_dir`` for profiles meeting the search criteria ``region``, ``start_date``, and ``end_date``. Profiles are loaded into the struct array ``argo`` with all variables specified in ``variable_list``. Files containing matching profiles are listed in ``matching_files``.

``argo_dir`` is a character array search path with wildcards. The search path should be the path to the netcdf files themselves, not their directory. 

``region`` is a vector containing the bounds [S N W E] of the search region, with limits [-90 90 -180 180]. Limits may cross the dateline e.g. [35 45 170 -130].

``start_date`` and ``end_date`` are date strings in format ``'dd-mmm-yyyy HH:MM:SS'``.

``argo`` is a uniform struct containing data from the profiles matching the region and date criteria. Some data is included automatically while some must be specificed. The variables PLATFORM_NUMBER, LONGITUDE, LATITUDE, JULD, and PRES_ADJUSTED are included automatically. Additional variables must be specified in ``variable_list``, a cell array where each element is the string name of a variable.

``matching_files`` is a string array where each string is the full path to a file which contained a profile matching the region and date criteria.

#### Example 1


```Matlab

% Get variable information:

argo_dir = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/argo/*profiles*.nc';
listing = dir(argo_dir); 
ncdisp([listing(1).folder '/' listing(1).name]) % Peek at netCDF header info to inform choice of variable_list.

% Load Argo data from west of New Zealand:

region = [-60.0 -50.0 150.0 160.0]; %  Search region [-90 90 -180 180]
start_date = '01-Nov-2015 00:00:00';
end_date = '01-Jan-2017 00:00:00';
variable_list = {'TEMP_ADJUSTED','PSAL_ADJUSTED'};
[argo,matching_files] = argo_build(argo_dir,region,start_date,end_date,variable_list);

% Make plots:

general_profiles(argo,'TEMP_ADJUSTED','depth')
general_map(argo,bathymetry_dir,'2Dcontour')

```
<img src="https://user-images.githubusercontent.com/24570061/88301724-fd1dab80-ccd2-11ea-9ea7-7badf1424865.png" width="600">
<img src="https://user-images.githubusercontent.com/24570061/88301788-11fa3f00-ccd3-11ea-9cdf-1622f701bfe9.png" width="600">

[Back](https://github.com/lnferris/ocean_data_tools#building-uniform-structs-from-data-sources-1)

