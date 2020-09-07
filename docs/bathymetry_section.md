### bathymetry_section

#### Syntax

```Matlab
[bath_section,lon_section,lat_section,time_section] = bathymetry_section(bathymetry,xcoords,ycoords,xref)
[bath_section,lon_section,lat_section,time_section] = bathymetry_section(bathymetry,xcoords,ycoords,xref,filled)
[bath_section,lon_section,lat_section,time_section] = bathymetry_section(bathymetry,xcoords,ycoords,xref,filled,maxdistance)
```
#### Description

``[bath_section,lon_section,lat_section] = bathymetry_section(bathy,xcoords,ycoords,xref)`` makes a section plot from ``bathy``, where ``bathy`` is a struct of Smith & Sandwell Global Topography created using ``bathymetry_extract``.  Points are extracted nearest to each coordinate specified by ``xcoords`` (longitude) and ``ycoords`` (latitude). The bathymetry section is plotted against ``xref``; where ``xref = 'lon'``, ``'lat'``, or a time vector of length(xcoords). The extracted data is output ``bath_section``, ``lon_section``, ``lat_section``, and ``time_section``; output vectors are sorted by the selected reference axis (longitude, latitude, or time).
 
``[bath_section,lon_section,lat_section,time_section] = bathymetry_section(bathy,xcoords,ycoords,xref,filled)`` allows the bathymetry to be filled in black down to the x-axis (instead of a simple line). Set ``filled=1`` to turn on, ``filled=0`` to turn off.

``[bath_section,lon_section,lat_section,time_section] = bathymetry_section(bathy,xcoords,ycoords,xref,filled,maxdistance)`` does not pull values where ``xcoords`` and ``ycoords`` are not within ``maxdistance`` (degrees) of a Global Topography value. ``maxdistance=0.05`` would pull no bathymetry at times/places further than 0.05 diagonal degrees from an available Global Topography value.

#### Example 1

```Matlab

% Add bathymetry to a temperature section plot from the list of coordinates stored in struct cruise:

xref = 'lon'; 
general_section(cruise,'temperature',xref,'pressure') % plot temperature section
xcoords = cruise.lon; 
ycoords = cruise.lat;
filled = 1;
[bathy] = bathymetry_extract(bathymetry_dir,bounding_region(cruise));
bathymetry_section(bathy,xcoords,ycoords,xref,filled)
```
<img src="https://user-images.githubusercontent.com/24570061/88436173-b8c50500-cdd1-11ea-8270-22930d42843c.png" width="800">

#### Example 2
```Matlab
% Plot bathymetry nearest to a list of coordinates. Use latitude as the x-axis:

xref = 'lat'; 
xcoords = [60 60.1 60.4 60.2 59.9]; 
ycoords = [10 20.1 15.0 16.1 13.7]; 
[bathy] = bathymetry_extract(bathymetry_dir,bounding_region([],xcoords,ycoords));
figure
bathymetry_section(bathy,xcoords,ycoords,xref)
```
#### Example 3
```Matlab
% Plot bathymetry nearest to a list of coordinates. Use a time as the x-axis:

xref = [737009 737010 737011 737012 737013]; 
xcoords = [60 60.1 60.4 60.2 59.9]; 
ycoords = [10 20.1 15.0 16.1 13.7]; 
[bathy] = bathymetry_extract(bathymetry_dir,bounding_region([],xcoords,ycoords));
figure
bathymetry_section(bathy,xcoords,ycoords,xref)
```
#### Example 4
```Matlab
% Plot bathymetry nearest to a list of coordinates, using time as the x-axis and shading bathymetry. Only return bathymetry values for timesteps within 0.007 degrees of a bathymetry node:

xref = [737009 737010 737011 737012 737013]; 
xcoords = [60 60.1 60.4 60.2 59.9]; 
ycoords = [10 20.1 15.0 16.1 13.7]; 
[bathy] = bathymetry_extract(bathymetry_dir,bounding_region([],xcoords,ycoords));
filled = 1;
maxdistance = 0.007;
figure
bathymetry_section(bathy,xcoords,ycoords,xref,filled,maxdistance)
```

[Back](https://github.com/lnferris/ocean_data_tools#adding-bathymetry-to-existing-plots-1)
