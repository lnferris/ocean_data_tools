### woa_simple_plot

#### Syntax

```Matlab
[data,lat,lon] = woa_simple_plot(variable,time,region,depth)
```
#### Description

``[data,lat,lon] = woa_simple_plot(variable,time,region,depth)`` plots the nearest available depth-level to ``depth``. ``variable`` specifies the parameter to be plotted and ``region`` is the rectangular region to be plotted. ``time``specifies monthly or annual climatology; ``time='00'`` for annual climatology and ``'01'`` ``'10'`` etc. for monthly climatology. The function builds the url, extracting the maximum resolution available (typically 0.25-deg or 1.00-degree grid). ``data``, ``lat``, and ``lon`` from the plotted layer are available outputs.

Available variables are:

``'temperature'`` (degrees Celsius)    
``'salinity'`` (psu)                    
``'oxygen'`` (umol/kg)                 
``'o2sat'`` (%)

``'AOU'`` (umol/kg)                
``'silicate'`` (umol/kg)          
``'phosphate'`` (umol/kg)   
``'nitrate'`` (umol/kg)

``time`` is a string or character array. ``'00'`` is annual climatology, while other codes e.g. ``'02'`` (February) or ``'11'`` (November) indicate monthly climatology.

``variable`` is a string or character array and is the name of the parameter to be plotted.

``depth`` is (a single, double, integer) indicates negative meters below the surface.

``region`` is a vector containing the bounds [S N W E] of the region to be plotted, -180/180 or 0/360 longtitude format is fine.  Limits may cross the dateline e.g. [35 45 170 -130].

``data``, ``lon``, and ``lat`` are double arrays containing the plotted data layer. As such, this function can be used to extract data layers from World Ocean Atlas 2018.

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

```
<img src="https://user-images.githubusercontent.com/24570061/88360391-7a810480-cd43-11ea-9472-2d18a306389b.png" width="900">

[Back](https://github.com/lnferris/ocean_data_tools#plotting-gridded-data-without-building-structs-1)

