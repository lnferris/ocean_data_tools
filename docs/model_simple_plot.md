### model_simple_plot

#### Syntax

```Matlab
[data,lat,lon] = model_simple_plot(model,source,date,variable,region,depth)
[data,lat,lon] = model_simple_plot(model,source,date,variable,region,depth,arrows)
```
#### Description

``[data,lat,lon] = model_simple_plot(model,source,date,variable,region,depth)`` plots one ``depth`` level of HYCOM or Operational Mercator GLOBAL_ANALYSIS_FORECAST_PHY_001_024. ``variable`` specifies the parameter to be plotted and ``region`` is the rectangular region to be plotted. In addition to innate variables, each model has the additional derived variable ``variable='velocity'``. ``model='hycom'`` or ``model='mercator'`` specifies the model used. ``source`` is the url or local path of the relevant dataset. ``data``, ``lat``, and ``lon`` from the plotted layer are available outputs.

``[data,lat,lon] = model_simple_plot(model,source,date,variable,region,depth,arrows)`` adds directional arrows if it is a velocity magnitude plot. ``arrows=1`` is on, ``arrows=0`` is off.

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
```Matlab
Mercator variables: 
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

% Plot temperature at the depth level closes to 150m:

model = 'mercator'; % 'hycom' 'mercator'
source = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/mercator/global-analysis-forecast-phy-001-024_1593408360353.nc'; 
date = '18-Mar-2020 00:00:00';   
variable = 'thetao'; 
region = [60.0, 70.0 ,-80, -60];      % [-90 90 -180 180]
depth = -150;                
arrows = 0;  
model_simple_plot(model,source,date,variable,region,depth,arrows)

```
<img src="https://user-images.githubusercontent.com/24570061/88408553-b8147a80-cda1-11ea-98bf-e1d9b45aa53c.png" width="600">

[Back](https://github.com/lnferris/ocean_data_tools#plotting-gridded-data-without-building-structs-1)

