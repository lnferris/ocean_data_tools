### bounding_region

#### Syntax

```Matlab
[region] = bounding_region(object)
[region] = bounding_region(object,xcoords,ycoords)
[region] = bounding_region([],xcoords,ycoords)
```
#### Description

``[region] = bounding_region(object)`` finds a rectangular ``region`` = [S N W E]  around a struct ``object``; where ``object`` is a struct created by any of the ``_build`` functions in ocean_data_tools (e.g. ``argo``, ``cruise``, ``hycom``, ``mercator``, ``woa``, ``wod``). 

``[region] = bounding_region(object,xcoords,ycoords)`` ensures that the ``region`` bounding the above struct also ecompasses the points specified  by ``xcoords`` (longitude) and ``ycoords`` (latitude). This is useful for extracting bathymetry only once before using ``bathymetry_plot`` and a ``bathymetry_section``.

``[region] = bounding_region([],xcoords,ycoords)`` finds a rectangular ``region``  = [S N W E] around the points specified  by ``xcoords`` (longitude) and ``ycoords`` (latitude).


#### Example 1

```Matlab

% Map Argo profiles, coloring by platform:

argo_platform_map(argo,1)

% Extract relevant bathymetry around struct argo:

bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc';
region = bounding_region(argo);
[bathy] = bathymetry_extract(bathymetry_dir,region);

% Add bathymetry contours:

bathymetry_plot(bathy,region,'2Dcontour')
```
<img src="https://user-images.githubusercontent.com/24570061/88435475-430c6980-cdd0-11ea-9fa8-417bf9b71583.png" width="600">

#### Example 2

```Matlab
% Find the region around a list of coordinates (to be later used with bathymetry_section):

xcoords = -75:1/48:-74;
ycoords = 65:1/48:66;
region = bounding_region([],xcoords,ycoords);
```

[Back](https://github.com/lnferris/ocean_data_tools#adding-bathymetry-to-existing-plots-1)
