### argo_build

#### Syntax

```Matlab
[subargo] = argo_platform_subset(argo,platform_id) 
```
#### Description

``[subargo] = argo_platform_subset(argo,platform_id)`` subsets ``argo`` by Argo platform ID (PLATFORM_NUMBER) into struct ``subargo``; where ``argo`` is a struct created by ``argo_build`` and platform_id is the integer ID


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

% Subset by platform:

platform_id = 5904421;
[subargo] = argo_platform_subset(argo,platform_id);

% Make a plot:

argo_platform_map(subargo,1)
bathymetry_plot(bathymetry_dir,bathymetry_region(argo),'2Dcontour')

```
<img src="https://user-images.githubusercontent.com/24570061/88316847-6955da80-cce6-11ea-8bb0-d9d0523a3a29.png" width="700">


<img src="https://user-images.githubusercontent.com/24570061/88324607-ec306280-ccf1-11ea-8f9a-81320046ccf4.png" width="700">



[Back](https://github.com/lnferris/ocean_data_tools#building-uniform-structs-from-data-sources-1)

