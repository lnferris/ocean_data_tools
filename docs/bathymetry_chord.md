### bathymetry_chord

#### Syntax

```Matlab
[bath_chord,lon_chord,lat_chord] = bathymetry_chord(bathymetry_dir,lon1,lat1,lon2,lat2,xref)
[bath_chord,lon_chord,lat_chord] = bathymetry_chord(bathymetry_dir,lon1,lat1,lon2,lat2,xref,filled)
[bath_chord,lon_chord,lat_chord] = bathymetry_chord(bathymetry_dir,lon1,lat1,lon2,lat2,xref,filled,width)
```
#### Description

``[bath_chord,lon_chord,lat_chord] = bathymetry_chord(bathymetry_dir,lon1,lat1,lon2,lat2,xref)`` extracts Smith & Sandwell Global Topography in path ``bathymetry_dir`` for use with a section plot. It is less precise than ``bathymetry_section``; a practical application is to capture seamounts that might have been nearby but not exactly beneath in a transect. Points lying within a narrow chord-like region of width 1/60-degrees are extracted, with ``lon1`` and ``lat1`` marking the beginning of the chord and ``lon2`` and ``lat2`` marking the end of the chord. The bathymetry section is plotted with ``xref = 'lon'`` or ``xref = 'lat'`` as the x-axis variable. The extracted data is output ``bath_chord``, ``lon_chord``, and ``lat_chord``. 

``[bath_chord,lon_chord,lat_chord] = bathymetry_chord(bathymetry_dir,lon1,lat1,lon2,lat2,xref,filled)`` allows the bathymetry to be filled in black down to the x-axis (instead of a simple line). Set ``filled=1`` to turn on, ``filled=0`` to turn off.

``[bath_chord,lon_chord,lat_chord] = bathymetry_chord(bathymetry_dir,lon1,lat1,lon2,lat2,xref,filled,width)`` allows the user to change the width of the chord-like region of extraction from the default 1/60 degrees.


#### Example 1

<img src="https://user-images.githubusercontent.com/24570061/88437360-53264800-cdd4-11ea-8b5a-c01cb973768e.png" width="600">

```Matlab

% Add bathymetry from 67S,160E to 66.5S,80W to a temperature section plot:

xref = 'lon'; % 'lon' 'lat'
general_section(cruise,'temperature',xref,'pressure')  % plot temperature section
lon1 = 160;
lat1 = -67;
lon2 = 280; 
lat2 = -66.5;
bathymetry_chord(bathymetry_dir,lon1,lat1,lon2,lat2,xref)

```
<img src="https://user-images.githubusercontent.com/24570061/88437270-2114e600-cdd4-11ea-9ace-0fb0898cf7fc.png" width="900">

[Back](https://github.com/lnferris/ocean_data_tools#building-uniform-structs-from-data-sources-1)

