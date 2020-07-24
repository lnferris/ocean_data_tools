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

