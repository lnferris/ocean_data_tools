### model_simple_plot

#### Syntax

```Matlab
[data,lat,lon] = model_simple_plot(model_type,source,date,variable,region,depth)
[data,lat,lon] = model_simple_plot(model_type,source,date,variable,region,depth,arrows)
```
#### Description

``[data,lat,lon] = model_simple_plot(model_type,source,date,variable,region,depth)`` plots the nearest available depth-level of HYCOM or Operational Mercator GLOBAL_ANALYSIS_FORECAST_PHY_001_024. ``variable`` specifies the parameter to be plotted and ``region`` is the rectangular region to be plotted. ``model_type ='hycom'`` or ``model_type ='mercator'`` specifies the model used. ``source`` is the url or local path of the relevant dataset. ``data``, ``lat``, and ``lon`` from the plotted layer are available outputs.

``[data,lat,lon] = model_simple_plot(model_type,source,date,variable,region,depth,arrows)`` adds directional arrows if it is a velocity magnitude plot. ``arrows=1`` is on, ``arrows=0`` is off.

``source`` (a character array) is the path to either a local netcdf file or an OpenDAP url.

``date`` is a date string in format 'dd-mmm-yyyy HH:MM:SS'. 

``variable`` is a string or character array and is the name of the parameter to be plotted.

``depth`` is (a single, double, integer) indicates negative meters below the surface.

``region`` is a vector containing the bounds [S N W E] of the region to be plotted, -180/180 or 0/360 longtitude format is fine.  Limits may cross the dateline e.g. [35 45 170 -130].

``data``, ``lon``, and ``lat`` are double arrays containing the plotted data layer. As such, this function can be used to extract data layers from HYCOM or Operational Mercator GLOBAL_ANALYSIS_FORECAST_PHY_001_024.

HYCOM variables: 
```Matlab
'water_u' 
'water_v' 
'water_temp' 
'salinity' 
'velocity' 
'surf_el' 
'water_u_bottom' 
'water_v_bottom' 
'water_temp_bottom' 
'salinity_bottom'
```
Mercator variables: 
```Matlab
'thetao' 
'so' 
'uo' 
'vo' 
'velocity'
'mlotst' 
'siconc'
'usi' 
'vsi' 
'sithick'
'bottomT' 
'zos'
```
                     

#### Example 1


```Matlab

% Setup nctoolbox: 

setup_nctoolbox

% Plot temperature at the depth level closest to 150m:

model_type = 'mercator'; % 'hycom' 'mercator'
source = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/mercator/global-analysis-forecast-phy-001-024_1593408360353.nc'; 
date = '18-Mar-2020 00:00:00';   
variable = 'thetao'; 
region = [60.0, 70.0 ,-80, -60];      % [-90 90 -180 180]
depth = -150;                
arrows = 0;  
model_simple_plot(model_type,source,date,variable,region,depth,arrows)

```
<img src="https://user-images.githubusercontent.com/24570061/88408553-b8147a80-cda1-11ea-98bf-e1d9b45aa53c.png" width="600">

[Back](https://github.com/lnferris/ocean_data_tools#plotting-gridded-data-without-building-structs-1)

