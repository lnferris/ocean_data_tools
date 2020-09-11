### transect_select

#### Syntax

```Matlab
[xcoords,ycoords] = transect_select() 
[xcoords,ycoords] = transect_select(densify)
```
#### Description

``[xcoords,ycoords] = transect_select()`` creates a list of x and y coordinates selected by clicking stations on an existing (latitude vs. longitude) plot, returning them as ``xcoords`` and ``ycoords``

``[xcoords,ycoords] = transect_select(densify)`` auto-generates additional stations with the multiplier ``densify``. ``densify=10`` would fill in 10 stations for every station clicked using linear interpolation of complex coordinates.

``densify`` should be an integer. If it is not an integer it will be rounded to an integer.

``xcoords`` and ``ycoords`` are vectors of coordinates representing a polygonal chain. -180/180 or 0/360 notation will match that of the existing plot.

#### Example 1


```Matlab

% Plot HYCOM surface salinity:

model_type = 'hycom'; 
source = 'http://tds.hycom.org/thredds/dodsC/GLBv0.08/expt_57.7';
date = '28-Aug-2017 00:00:00';  
variable = 'salinity;                
region = [-5.0, 45.0 ,160,-150 ];      
depth = -150;                                                   
model_simple_plot(model_type,source,date,variable,region,depth);

% Click stations on the plot to create a coordinate list:

[xcoords,ycoords] = transect_select(10); % click desired transect on the figure, densify selection by 10x

```
<img src="https://user-images.githubusercontent.com/24570061/88406388-9f569580-cd9e-11ea-9871-e4d55941d7c4.png" width="500">

```Matlab

% Build a uniform struct from the coordinates:

variable_list = {'water_temp','salinity'}; % 'water_u' 'water_v' 'water_temp' 'salinity'
[hycom] =  model_build_profiles(source,date,variable_list,xcoords,ycoords);

% Map stations:

bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc';
general_map(hycom,bathymetry_dir,'2Dcontour')

```
<img src="https://user-images.githubusercontent.com/24570061/88406404-a67da380-cd9e-11ea-8d49-bd4db591c282.png" width="500">


[Back](https://github.com/lnferris/ocean_data_tools#miscellaneous-utilities-1)

