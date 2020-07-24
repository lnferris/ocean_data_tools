### argo_build

#### Syntax

```Matlab
[subobject] = general_remove_duplicates(object)
[subobject] = general_remove_duplicates(object,var3)
```
#### Description

``[subobject] = general_remove_duplicates(object)`` removes profiles without unique coordinate locations; where ``object`` is a struct created by any of the ``_build`` functions in ocean_data_tools (e.g. ``argo``, ``cruise``, ``hycom``, ``mercator``, ``woa``, ``wod``).  This function can be used to remove duplicates when the user accidentally built an ``object`` using a coordinate list (``xcoords``, ``ycoords``) that exceeded the spatial resolution of the model or other raw data source itself.

``[subobject] = general_remove_duplicates(object,var3)`` uses a third field ``var3`` as a uniqueness criterion, usually date. This avoids removing profiles with the same coordinate location but unique dates. ``var3`` should be a fieldname e.g. ``var3='date'``.

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

general_map(argo,bathymetry_dir,'2Dcontour')

```
<img src="https://user-images.githubusercontent.com/24570061/88301724-fd1dab80-ccd2-11ea-9ea7-7badf1424865.png" width="600">

[Back](https://github.com/lnferris/ocean_data_tools#building-uniform-structs-from-data-sources-1)

