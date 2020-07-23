### argo_platform_map

#### Syntax

```Matlab
argo_platform_map(argo)
argo_platform_map(argo,annotate)
```
#### Description

``argo_platform_map(argo)`` plots locations of Argo profiles in ``argo``, coloring markers by the specific Argo platform which made the measurements; where ``argo`` is a struct created by ``argo_build``.

``argo_platform_map(argo,annotate)`` adds number annotations to the markers which correspond to a longer Argo platform ID in the legend. By default ``annotate=0``. Set ``annotate=1`` to turn on annotation.


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

% Plot locations of Argo profiles, coloring by unique platform:

annotate = 1; 
argo_platform_map(argo,annotate) % annotate optional,  1=on 0=off
bathymetry_plot(bathymetry_dir,bathymetry_region(argo),'2Dcontour')

```
<img src="https://user-images.githubusercontent.com/24570061/88316847-6955da80-cce6-11ea-8bb0-d9d0523a3a29.png" width="700">

[Back](https://github.com/lnferris/ocean_data_tools#building-uniform-structs-from-data-sources-1)

