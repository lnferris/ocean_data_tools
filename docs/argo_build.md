### argo_build


#### Syntax

```Matlab
[argo,matching_files] = argo_build(argo_dir,region,start_date,end_date,variable_list)
```
#### Description

``[argo,matching_files] = argo_build(argo_dir,region,start_date,end_date,variable_list)`` searches pathway ``argo_dir`` for profiles meeting the search criteria ``region``, ``start_date``, and ``end_date``. Profiles are loaded into the struct array ``argo`` with all variables specified in ``variable_list``. Variables PLATFORM_NUMBER, LONGITUDE, LATITUDE, JULD, and PRES_ADJUSTED are included automatically. Files containing matching profiles are listed in ``matching_files``.


#### Example 1


```Matlab

% Get variable information:

argo_dir = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/argo/*profiles*.nc';
netcdf_info(argo_dir);

% Load Argo data from west of New Zealand:

region = [-60.0 -50.0 150.0 160.0]; %  Search region [-90 90 -180 180]
start_date = '01-Nov-2015 00:00:00';
end_date = '01-Jan-2017 00:00:00';
variable_list = {'TEMP_ADJUSTED','PSAL_ADJUSTED'};
[argo,matching_files] = argo_build(argo_dir,region,start_date,end_date,variable_list);

% Make plots:

general_profiles(argo,variable,'depth')
general_map(argo,bathymetry_dir,'2Dcontour')

```
<img src="https://user-images.githubusercontent.com/24570061/88301724-fd1dab80-ccd2-11ea-9ea7-7badf1424865.png" width="700">
<img src="https://user-images.githubusercontent.com/24570061/88301788-11fa3f00-ccd3-11ea-9cdf-1622f701bfe9.png" width="700">

[Back to README](https://github.com/lnferris/ocean_data_tools#building-uniform-structs-from-data-sources-1)

