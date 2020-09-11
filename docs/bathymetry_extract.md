### bathymetry_extract

#### Syntax

```Matlab
[bathy] =  bathymetry_extract(bathymetry_dir,region)
```
#### Description

``[bathy] =  bathymetry_extract(bathymetry_dir,region)`` extracts Smith & Sandwell Global Topography in path ``bathymetry_dir`` over the specified rectangular ``region``. Struct ``bathy`` has fields ``z``, ``lat``, and ``lon``. Struct bathy has fields z, lat, and lon and contains only the data from the specified region.

``bathymetry_dir`` is the character array path to the Smith & Sandwell Global Topography file "topo_20.1.nc"

``region`` is a vector containing the bounds [S N W E] of the search region, with limits [-90 90 -180 180]. Limits may cross the dateline e.g. [35 45 170 -130].

#### Example 1

```Matlab
% Extract relevant bathymetry over a region:

bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc';
region = [-60.0 -50.0 150.0 160.0];
[bathy] = bathymetry_extract(bathymetry_dir,region);
```

#### Example 2

```Matlab
% Extract relevant bathymetry around struct argo:

bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc';
region = bounding_region(argo);
[bathy] = bathymetry_extract(bathymetry_dir,region);

```

[Back](https://github.com/lnferris/ocean_data_tools#adding-bathymetry-to-existing-plots-1)

