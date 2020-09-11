### model_build_profiles

#### Syntax

```Matlab
[model] = model_build_profiles(source,date,variable_list,xcoords,ycoords)
[model] = model_build_profiles(source,date,variable_list,xcoords,ycoords,zgrid)
```
#### Description

``[model] = model_build_profiles(source,date,variable_list,xcoords,ycoords)`` builds a struct of profiles from HYCOM or Operational Mercator GLOBAL_ANALYSIS_FORECAST_PHY_001_024, pulling profiles nearest to coordinates specified by ``xcoords`` and ``ycoords``. Profiles are loaded into the struct array ``model`` with all variables specified in ``variable_list``.

``[model] = model_build_profiles(source,date,variable_list,xcoords,ycoords,zgrid)`` depth-interpolates the profiles to a vertical grid of ``zgrid``, in meters. ``zgrid=2`` would produce profiles interpolated to 2 meter vertical grid.

``source`` (a character array) is the path to either a local netcdf file or an OpenDAP url.

``date`` is a date string in format 'dd-mmm-yyyy HH:MM:SS'. 

``variable_list`` is a cell array where each element is the string name of a variable to be read and included in struct ``model``.

``xcoords`` and ``ycoords`` are vectors of coordinates. Rows or columns are fine, and both -180/180 or 0/360 notation are fine.

HYCOM variables: 
```Matlab
'water_u' 
'water_v' 
'water_temp' 
'salinity' 
```
Mercator variables: 
```Matlab
'thetao' 
'so' 
'uo' 
'vo' 
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

% Click stations on the plot to create a coordinate list:

[xcoords,ycoords] = transect_select(10); % click desired transect on the figure, densify selection by 10x 

```
<img src="https://user-images.githubusercontent.com/24570061/88411026-3c1c3180-cda5-11ea-81d3-d3b656315464.png" width="600">

```Matlab

% Build a uniform struct of profiles:

variable_list = {'thetao','so','uo'}; % thetao' 'so' 'uo' 'vo'
zgrid = 1; % vertical grid for linear interpolation in meters
[mercator] =  model_build_profiles(source,date,variable_list,xcoords,ycoords,zgrid); % zgrid optional, no interpolation if unspecified

% Make plots:

general_map(mercator,bathymetry_dir,'2Dcontour')
general_section(mercator,'thetao','stn','depth',1,1)

```
<img src="https://user-images.githubusercontent.com/24570061/88411140-6b32a300-cda5-11ea-922e-48bf06df90b3.png" width="600">
<img src="https://user-images.githubusercontent.com/24570061/88411172-7685ce80-cda5-11ea-9ae9-0989c763bef9.png" width="600">

[Back](https://github.com/lnferris/ocean_data_tools#building-uniform-structs-from-data-sources-1)

