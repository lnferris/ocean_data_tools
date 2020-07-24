### bathymetry_plot

#### Syntax

```Matlab
bathymetry_plot(bathymetry_dir,region,ptype)
```
#### Description

``bathymetry_plot(bathymetry_dir,region,ptype)`` extracts Smith & Sandwell Global Topography in path ``bathymetry_dir`` for use with a 2D (latitude vs. longitude) or 3D (latitude vs. longitude vs. depth) plot. The region extracted is given by ``region``, maximum latitudes and longitudes are [-80.738 80.738 -180 180], and should be in order [S N W E]. ``type = '2Dscatter'`` or ``'2Dcontour'`` or ``'3Dsurf'`` specifies the plot type.
                     
#### Example 1

```Matlab

% Setup nctoolbox: 

setup_nctoolbox

% Plot a 3-D velocity domain from Operational Mercator:

model = 'mercator'; % 'hycom' 'mercator'
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

[Back](https://github.com/lnferris/ocean_data_tools#adding-bathymetry-to-existing-plots-1)

