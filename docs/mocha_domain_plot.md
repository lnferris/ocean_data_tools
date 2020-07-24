### mocha_domain_plot

#### Syntax

```Matlab
mocha_domain_plot(month,variable,region)
```
#### Description

``mocha_domain_plot(month,variable,region)`` plots all depth-levels of ``variable`` over the specified ``region``. The calendar month is specified by ``month``.

#### Example 1


```Matlab

% Setup nctoolbox:

setup_nctoolbox

% Plot a 3-D temperature domain:

month = 10; % Month (1 through 12).
variable = 'temperature'; %  'temperature' 'salinity'
region = [34 42  -80 -70]; % [30 48 -80 -58]
mocha_domain_plot(month,variable,region)

% Add bathymetry:
bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc';
bathymetry_plot(bathymetry_dir,region,'3Dsurf')
caxis([27 38])

```

<img src="https://user-images.githubusercontent.com/24570061/88339261-ba29fb00-cd07-11ea-97a3-bef5868a1fa4.png" width="600">


[Back](https://github.com/lnferris/ocean_data_tools#plotting-gridded-data-without-building-structs-1)

