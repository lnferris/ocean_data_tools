### general_section

#### Syntax

```Matlab
general_section(object,variable,xref,zref)
general_section(object,variable,xref,zref,interpolate)
general_section(object,variable,xref,zref,interpolate,contours)
```
#### Description

``general_section(object,variable,xref,zref)`` creates a section plot from ``object``; where ``object`` is a struct created by any of the ``_build`` functions in ocean_data_tools (e.g. ``argo``, ``cruise``, ``hycom``, ``mercator``, ``woa``, ``wod``). The color field is specified by ``variable``. ``xref`` and ``zref`` specify fields to use for the x-axis and z-axis.

``general_section(object,variable,xref,zref,interpolate)`` interpolates the plot using the MATLAB ``shading`` function. ``interpolate=1`` for on, ``interpolate=0`` for off.

``general_section(object,variable,xref,zref,interpolate,contours)`` adds contours to the section plot. ``contours=1`` for on, ``contours=0`` for off.

``variable`` is the string name of the field (of ``object``) to be plotted as the color variable of the section plot

``zref`` is the string name of the field (of ``object``) to be plotted as the depth variable of the section plot

``xref`` is the string name of the field (of ``object``) to be plotted as the horizontal variable of the section plot, usually ``'stn'``, ``'lat'``, or ``'lon'``. Alteratively pass ``xref = 'km'`` to plot in along-track distance. Assumes spherical earth.


#### Example 1


```Matlab

% Setup nctoolbox:

setup_nctoolbox

% Built a uniform struct from MOCHA climatology:

month = 10; % Month (1 through 12).
depth = 0;
variable = 'temperature'; %  'temperature' 'salinity'
region = [34 42  -80 -70]; % [30 48 -80 -58]
mocha_simple_plot(month,depth,variable,region)
[xcoords,ycoords] = transect_select(10); % click desired transect on the figure, densify selection by 10x 
zgrid = 1; % vertical grid for linear interpolation in meters
[mocha] = mocha_build_profiles(month,xcoords,ycoords,zgrid); % zgrid optional, no interpolation if unspecified
```
<img src="https://user-images.githubusercontent.com/24570061/88334226-73d09e00-ccff-11ea-867d-860d64744dc0.png" width="600">

```Matlab

% Make a temperature section:

object = mocha; % argo, cruise, hycom, mercator, woa, wod
variable = 'temperature'; % see particular struct for options
xref = 'stn';  % 'lat' 'lon' 'stn';
zref = 'depth;  See particular struct for options
interpolate = 1; % 1=on 0=off
contours = 1; % 1=on 0=off
general_section(object,variable,xref,zref,interpolate,contours)
```
<img src="https://user-images.githubusercontent.com/24570061/88334248-79c67f00-ccff-11ea-926b-a713efbb94d0.png" width="600">

[Back](https://github.com/lnferris/ocean_data_tools#general-functions-for-subsetting-and-plotting-uniform-structs-1)


