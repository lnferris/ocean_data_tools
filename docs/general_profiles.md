### general_profiles

#### Syntax

```Matlab
general_profiles(object,variable,zref)
```
#### Description

``general_profiles(object,variable,zref)`` plots vertical profiles of the specified ``variable`` in struct ``object`` as a function of the depth field specified by ``zref``; where ``object`` is a struct created by any of the ``_build`` functions in ocean_data_tools (e.g. ``argo``, ``cruise``, ``hycom``, ``mercator``, ``woa``, ``wod``) and ``variable`` is a field name.

``variable`` is the string name of the field (of ``object``) to be plotted as the x-variable of the vertical profile

``zref`` is the string name of the field (of ``object``) to be plotted as the depth variable of the vertical profile

#### Example 1


```Matlab

% Load Argo data from west of New Zealand:

region = [-60.0 -50.0 150.0 160.0]; %  Search region [-90 90 -180 180]
start_date = '01-Nov-2015 00:00:00';
end_date = '01-Jan-2017 00:00:00';
variable_list = {'TEMP_ADJUSTED','PSAL_ADJUSTED'};
[argo,matching_files] = argo_build(argo_dir,region,start_date,end_date,variable_list);

% Plot profiles:

object = argo;  % argo, cruise, hycom, mercator, woa, wod
variable = 'TEMP_ADJUSTED'; % see particular struct for options
zref = 'depth'; % see particular struct for options
general_profiles(object,variable,zref)

```
<img src="https://user-images.githubusercontent.com/24570061/88301788-11fa3f00-ccd3-11ea-9cdf-1622f701bfe9.png" width="600">

[Back](https://github.com/lnferris/ocean_data_tools#general-functions-for-subsetting-and-plotting-uniform-structs-1)

