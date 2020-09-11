### region_select

#### Syntax

```Matlab
[xcoords,ycoords] = region_select()
```
#### Description

``[xcoords,ycoords] = region_select()`` creates a list of x and y coordinates (which represent vertices of a polygon) selected by clicking stations on an existing (latitude vs. longitude) plot, returning them as ``xcoords`` and ``ycoords``.

``xcoords`` and ``ycoords`` are vectors of coordinates representing vertices of a polygon. -180/180 or 0/360 notation will match that of the existing plot.

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

% Choose a region for subsetting the uniform struct:

bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc';
general_map(argo,bathymetry_dir)
[xcoords,ycoords] = region_select(); % click desired  region on the figure

```
<img src="https://user-images.githubusercontent.com/24570061/88415528-a684a000-cdac-11ea-8f79-189818c2351c.png" width="600">

```Matlab
% Subset the struct:

[subargo] = general_region_subset(argo,xcoords,ycoords); 

```


[Back](https://github.com/lnferris/ocean_data_tools#miscellaneous-utilities-1)

