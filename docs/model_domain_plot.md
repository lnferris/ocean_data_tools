### model_domain_plot

#### Syntax

```Matlab
model_domain_plot(model_type,source,date,variable,region)
```
#### Description

``model_domain_plot(model,source,date,variable,region)`` plots all depth levels of HYCOM or Operational Mercator GLOBAL_ANALYSIS_FORECAST_PHY_001_024 over a particular rectangular ``region``. ``variable`` specifies the parameter to be plotted.  In addition to innate variables, each model has the additional derived variable ``variable='velocity'``. ``model_type ='hycom'`` or ``model_type ='mercator'`` specifies the model used. ``source`` is the url or local path of the relevant dataset.

``source`` (a character array) is the path to either a local netcdf file or an OpenDAP url.

``date`` is a date string in format 'dd-mmm-yyyy HH:MM:SS'. 

``variable`` is a string or character array and is the name of the parameter to be plotted.

``region`` is a vector containing the bounds [S N W E] of the region to be plotted, -180/180 or 0/360 longtitude format is fine.  Limits may cross the dateline e.g. [35 45 170 -130].

HYCOM variables: 
```Matlab
'water_u' 
'water_v' 
'water_temp' 
'salinity' 
'velocity' 
```
Mercator variables: 
```Matlab
'thetao' 
'so' 
'uo' 
'vo' 
'velocity'
```
                     
#### Example 1


```Matlab

% Setup nctoolbox: 

setup_nctoolbox

% Plot a 3-D velocity domain from Operational Mercator:

model_type = 'mercator'; % 'hycom' 'mercator'
source = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/mercator/global-analysis-forecast-phy-001-024_1593408360353.nc'; 
date = '18-Mar-2020 00:00:00';   
variable = 'thetao'; 
region = [60.0, 70.0 ,-80, -60];      % [-90 90 -180 180]
variable = 'velocity'; 
model_domain_plot(model,source,date,variable,region)

% Add bathymetry:

bathymetry_plot(bathymetry_dir,region,'3Dsurf')
caxis([0 1])

```
<img src="https://user-images.githubusercontent.com/24570061/88409944-ab912180-cda3-11ea-84bc-f848a4f795bc.png" width="700">

[Back](https://github.com/lnferris/ocean_data_tools#plotting-gridded-data-without-building-structs-1)
