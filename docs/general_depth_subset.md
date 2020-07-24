### general_depth_subset

#### Syntax

```Matlab
general_depth_subset(object,zrange)
general_depth_subset(object,zrange,depth_list)
```
#### Description

``[subobject] =  general_depth_subset(object,zrange)`` subsets ``object`` by depth-range ``zrange``; where ``object`` is a struct created by any of the ``_build`` functions in ocean_data_tools (e.g. ``argo``, ``cruise``, ``hycom``, ``mercator``, ``woa``, ``wod``). The default depth-variable used to subset is ``'depth'``. ``zrange`` is a 2-element vector e.g. ``zrange=[0 200]`` in meters or dbar. Order and sign of ``zrange`` does not matter.

``[subobject] =  general_depth_subset(object,zrange,depth_list)`` enables the user to specify one or more depth variables (instead of using default ``'depth'``) e.g. ``depth_list = {'pressure'}`` or ``depth_list = {'pressure','z','depth','depth_vke'}``.

#### Example 1


```Matlab
% Build a uniform struct from HYCOM and plot a temperature section:

[hycom] =  model_build_profiles(source,date,variable_list,xcoords,ycoords,zgrid);
general_section(hycom,'water_temp','lat','depth',1,1)

```
<img src="https://user-images.githubusercontent.com/24570061/88417509-0892d480-cdb0-11ea-9685-0da4b82f99f4.png" width="700">

```Matlab
% Subset to upper 450 meters and replot the temperature section:

[hycom] =  general_depth_subset(hycom,[0 450]);
general_section(hycom,'water_temp','lat','depth',1,1)

```
<img src="https://user-images.githubusercontent.com/24570061/88417524-10527900-cdb0-11ea-8a5c-b8c6607a2386.png" width="700">


[Back](https://github.com/lnferris/ocean_data_tools#general-functions-for-subsetting-and-plotting-uniform-structs-1)

