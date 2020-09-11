### general_remove_duplicates

#### Syntax

```Matlab
[subobject] = general_remove_duplicates(object)
[subobject] = general_remove_duplicates(object,var3)
```
#### Description

``[subobject] = general_remove_duplicates(object)`` removes profiles without unique coordinate locations; where ``object`` is a struct created by any of the ``_build`` functions in ocean_data_tools (e.g. ``argo``, ``cruise``, ``hycom``, ``mercator``, ``woa``, ``wod``).  This function can be used to remove duplicates when the user accidentally built an ``object`` using a coordinate list (``xcoords``, ``ycoords``) that exceeded the spatial resolution of the model or other raw data source itself.

``[subobject] = general_remove_duplicates(object,var3)`` uses a third field ``var3`` as a uniqueness criterion, usually date. This avoids removing profiles with the same coordinate location but unique dates. ``var3`` should be a fieldname used to filter the data e.g. ``var3='date'``.

``subobject`` is a struct which is structurally identical to ``object`` but contains data only spatially-unique (or also var3-unique) profiles

#### Example 1


```Matlab

% Build a uniform struct from HYCOM, requesting 49 profiles at a higher resolution than the model itself:

source = 'http://tds.hycom.org/thredds/dodsC/GLBv0.08/expt_57.7';
date = '28-Aug-2017 00:00:00';
xcoords = -75:1/48:-74;
ycoords = 65:1/48:66;
variable_list = {'water_temp','salinity'}; 
[hycom] = model_build_profiles(source,date,variable_list,xcoords,ycoords);

% Remove duplicate profiles, resulting in 39 unique profiles:

object = hycom;
[subobject] = general_remove_duplicates(object);

```
<img src="https://user-images.githubusercontent.com/24570061/88433788-bd3aef00-cdcc-11ea-99c4-653bca43d1d0.png" width="600">

[Back](https://github.com/lnferris/ocean_data_tools#general-functions-for-subsetting-and-plotting-uniform-structs-1)


