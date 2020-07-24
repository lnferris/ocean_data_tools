### general_map

#### Syntax

```Matlab
general_map(object)
general_map(object,bathymetry_dir)
general_map(object,bathymetry_dir,ptype)
```
#### Description

``general_map(object)`` plots coordinate locations (``object.lon`` and ``object.lat``); where ``object`` is a struct created by any of the ``_build`` functions in ocean_data_tools (e.g. ``argo``, ``cruise``, ``hycom``, ``mercator``, ``woa``, ``wod``). 

``general_map(object,bathymetry_dir)`` adds bathymetry contours from Smith & Sandwell Global Topography with path ``bathymetry_dir``.

``general_map(object,bathymetry_dir,ptype)`` allows the user to modify plot type from the default contours e.g. ``ptype = '2Dscatter'`` or ``'2Dcontour'``

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

% Make a map:

bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc';
ptype = '2Dcontour'; % '2Dscatter' '2Dcontour'
general_map(argo,bathymetry_dir,ptype)

```
<img src="https://user-images.githubusercontent.com/24570061/88301724-fd1dab80-ccd2-11ea-9ea7-7badf1424865.png" width="600">

[Back](https://github.com/lnferris/ocean_data_tools#general-functions-for-subsetting-and-plotting-uniform-structs-1)

