### woa_build_profiles

#### Syntax

```Matlab
[woa] =   woa_build_profiles(variable_list,time,xcoords,ycoords)
[woa] =   woa_build_profiles(variable_list,time,xcoords,ycoords,zgrid)
```
#### Description

``[woa] =   woa_build_profiles(variable_list,time,xcoords,ycoords)`` builds a struct of profiles from World Ocean Atlas 2018 Statistical Mean for All Decades Objectively Analyzed Mean Fields at Standard Depth Levels, pulling profiles nearest to coordinates specified by ``xcoords`` and ``ycoords``. ``time`` specifies monthly or annual climatology; ``time ='00'`` for annual climatology and ``'01'`` ``'10'`` etc. for monthly climatology. Profiles are loaded into the struct array ``woa`` with all variables specified in ``variable_list``. The function builds the url, extracting the maximum resolution available (typically 0.25-deg or 1.00-degree grid). Resolution depends on the variable. If the user requests only 0.25-degree variables in variable_list, data will be returned in  0.25-degree resolution. If any requested variable is coarser (1-degree) all variables will be returned in 1-degree resolution.

``[woa] =  woa_build_profiles(variable_list,time,xcoords,ycoords,zgrid)`` depth-interpolates the profiles to a vertical grid of ``zgrid``, in meters. ``zgrid=2`` would produce profiles interpolated to 2 meter vertical grid.

Available variables are:

``'temperature'`` (degrees Celsius)    
``'salinity'`` (psu)                    
``'oxygen'`` (umol/kg)                 
``'o2sat'`` (%)

``'AOU'`` (umol/kg)                
``'silicate'`` (umol/kg)          
``'phosphate'`` (umol/kg)   
``'nitrate'`` (umol/kg)                      

#### Example 1


```Matlab

% Setup nctoolbox:

setup_nctoolbox

% Plot surface nitrate:

variable = 'nitrate';
time = '03';
region = [-5.0, 45.0 ,-120, -150]; 
depth = -0; 
woa_simple_plot(variable,time,region,depth)

% Click stations on the plot to create a coordinate list:

[xcoords,ycoords] = transect_select(10); % click desired transect on the figure, densify selection by 10x 

```
<img src="https://user-images.githubusercontent.com/24570061/88359631-5c1a0980-cd41-11ea-8e2b-c331e28e1e09.png" width="900">

```Matlab

% Build a uniform struct of profiles:

variable_list = {'temperature','salinity','oxygen'}; % 'temperature' 'salinity' 'oxygen' 'o2sat' 'AOU' 'silicate' 'phosphate' 'nitrate'
time = '00'; % '00' for annual climatology '01' '10' etc. for monthly climatology
zgrid = 1; % vertical grid for linear interpolation in meters
[woa] =  woa_build_profiles(variable_list,time,xcoords,ycoords,zgrid); % zgrid optional, no interpolation if unspecified
[woa] = general_remove_duplicates(woa); % thin struct to gridding of source (optional)

% Make a section plot:

general_section(woa,'salinity','lon','depth',1,1)
```

<img src="https://user-images.githubusercontent.com/24570061/88359633-5d4b3680-cd41-11ea-84bd-ef62b5f42fbb.png" width="900">

[Back](https://github.com/lnferris/ocean_data_tools#building-uniform-structs-from-data-sources-1)

