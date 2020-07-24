### bathymetry_section

#### Syntax

```Matlab
[bath_section,lon_section,lat_section] = bathymetry_section(bathymetry_dir,xcoords,ycoords,xref)
[bath_section,lon_section,lat_section] = bathymetry_section(bathymetry_dir,xcoords,ycoords,xref,filled)
```
#### Description

``[bath_section,lon_section,lat_section] = bathymetry_section(bathymetry_dir,xcoords,ycoords,xref)`` extracts Smith & Sandwell Global Topography in path ``bathymetry_dir`` for use with a section plot. Points are extracted nearest to each coordinate specified by ``xcoords`` (longitude) and ``ycoords`` (latitude). The bathymetry section is plotted with ``xref = 'lon'`` or ``xref = 'lat'`` as the x-axis variable. The extracted data is output ``bath_section``, ``lon_section``, and ``lat_section``.
 
``[bath_section,lon_section,lat_section] = bathymetry_section(bathymetry_dir,xcoords,ycoords,xref,filled)`` allows the bathymetry to be filled in black down to the x-axis (instead of a simple line). Set ``filled=1`` to turn on, ``filled=0`` to turn off.

#### Example 1

```Matlab

% Add bathymetry to a temperature section plot from the list of coordinates stored in struct cruise:

xref = 'lon'; % 'lon' 'lat'
general_section(cruise,'temperature',xref,'pressure') % plot temperature section
xcoords = cruise.lon; 
ycoords = cruise.lat;
filled = 1;
bathymetry_section(bathymetry_dir,xcoords,ycoords,xref,filled)
```

<img src="https://user-images.githubusercontent.com/24570061/88436173-b8c50500-cdd1-11ea-8270-22930d42843c.png" width="800">

[Back](https://github.com/lnferris/ocean_data_tools#adding-bathymetry-to-existing-plots-1)
