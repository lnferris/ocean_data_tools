### woa_domain_plot

#### Syntax

```Matlab
woa_domain_plot(variable,time,region)
```
#### Description

``woa_domain_plot(variable,time,region)`` plots all depth levels of  World Ocean Atlas 2018 Statistical Mean for All Decades, Objectively Analyzed Mean Fields at Standard Depth Levels over the specified ``region``. ``variable`` specifies the parameter to be plotted and ``region`` is the rectangular region to be plotted. ``time`` specifies monthly or annual climatology; ``time = '00'`` for annual climatology and ``'01'`` ``'10'`` etc. for monthly climatology. The function builds the url, extracting the maximum resolution available (typically 0.25-deg or 1.00-degree grid). 

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

% Plot a 3-D nitrate domain:

variable = 'nitrate';
time = '03';
region = [-5.0, 45.0 ,-120, -150]; 
woa_domain_plot(variable,time,region)

```
<img src="https://user-images.githubusercontent.com/24570061/88359635-5e7c6380-cd41-11ea-8f39-62beb8ecf912.png" width="900">

[Back](https://github.com/lnferris/ocean_data_tools#plotting-gridded-data-without-building-structs-1)
