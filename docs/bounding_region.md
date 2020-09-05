### bathymetry_region

#### Syntax

```Matlab
[region] = bathymetry_region(object)
```
#### Description

``[region] = bathymetry_region(object)`` finds a rectangular ``region`` = [S N W E]  around a struct ``object``; where ``object`` is a struct created by any of the ``_build`` functions in ocean_data_tools (e.g. ``argo``, ``cruise``, ``hycom``, ``mercator``, ``woa``, ``wod``). 

#### Example 1

```Matlab
% Extract relevant bathymetry around struct argo:

bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc';
region = bathymetry_region(argo);
[bath,lat,lon] = bathymetry_extract(bathymetry_dir,region);
```

#### Example 2

```Matlab
% Map Argo profiles, coloring by platform:

argo_platform_map(argo,1)

% Add bathymetry contours:

region = bathymetry_region(argo);
bathymetry_plot(bathymetry_dir,region,'2Dcontour')
```
<img src="https://user-images.githubusercontent.com/24570061/88435475-430c6980-cdd0-11ea-9fa8-417bf9b71583.png" width="600">

[Back](https://github.com/lnferris/ocean_data_tools#adding-bathymetry-to-existing-plots-1)
