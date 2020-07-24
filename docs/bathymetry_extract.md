### bathymetry_extract

#### Syntax

```Matlab
[bath,lat,lon]=  bathymetry_extract(bathymetry_dir,region)
```
#### Description

``[bath,lat,lon]=  bathymetry_extract(bathymetry_dir,region)`` extracts Smith & Sandwell Global Topography in path ``bathymetry_dir`` over the specified rectangular ``region``. This function is called by functions ``bathymetry_section``, ``bathymetry_chord``, and ``bathymetry_plot``.

#### Example 1

```Matlab
% Extract relevant bathymetry over a region:

bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc';
region = [-60.0 -50.0 150.0 160.0];
[bath,lat,lon] = bathymetry_extract(bathymetry_dir,region);
```

#### Example 2

```Matlab
% Extract relevant bathymetry around struct argo:

bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc';
region = bathymetry_region(argo);
[bath,lat,lon] = bathymetry_extract(bathymetry_dir,region);

```

[Back](https://github.com/lnferris/ocean_data_tools#adding-bathymetry-to-existing-plots-1)

