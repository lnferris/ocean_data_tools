### mocha_build_profiles

#### Syntax

```Matlab
[mocha] = mocha_build_profiles(month,xcoords,ycoords)
[mocha] = mocha_build_profiles(month,xcoords,ycoords,zgrid)
```
#### Description

``[mocha] = mocha_build_profiles(month,xcoords,ycoords)`` builds a unform struct, ``mocha`` of profiles from the MOCHA Mid-Atlantic Bight climatology, pulling profiles nearest to coordinates specified by ``xcoords`` and ``ycoords``. The calendar month is specified by ``month``.

``[mocha] = mocha_build_profiles(month,xcoords,ycoords,zgrid)`` depth-interpolates the profiles to a vertical grid of ``zgrid``, in meters. ``zgrid=2`` would produce profiles interpolated to 2 meter vertical grid.

``xcoords`` and ``ycoords`` are vectors of coordinates. Rows or columns are fine, and both -180/180 or 0/360 notation are fine.

``month`` is an integer between 1 (January) and 12 (December).

#### Example 1

```Matlab

% Setup nctoolbox:

setup_nctoolbox

% Plot surface temperature:

month = 10; % Month (1 through 12).
depth = 0;
variable = 'temperature'; %  'temperature' 'salinity'
region = [34 42  -80 -70]; % [30 48 -80 -58]
mocha_simple_plot(month,depth,variable,region)

% Click stations on the plot to create a coordinate list:

[xcoords,ycoords] = transect_select('densify',10); % click desired transect on the figure, densify selection by 10x 

```

<img src="https://user-images.githubusercontent.com/24570061/88334226-73d09e00-ccff-11ea-867d-860d64744dc0.png" width="600">

```Matlab

% Build a uniform struct of profiles:

zgrid = 1; % vertical grid for linear interpolation in meters
[mocha] = mocha_build_profiles(month,xcoords,ycoords,zgrid); % zgrid optional, no interpolation if unspecified

% Make plots:

bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc';
general_map(mocha,bathymetry_dir,'2Dcontour')
general_section(mocha,'temperature','stn','depth',1,1)
```
<img src="https://user-images.githubusercontent.com/24570061/88334243-78955200-ccff-11ea-8196-4db6298cdec5.png" width="600">
<img src="https://user-images.githubusercontent.com/24570061/88334248-79c67f00-ccff-11ea-926b-a713efbb94d0.png" width="600">

[Back](https://github.com/lnferris/ocean_data_tools#building-uniform-structs-from-data-sources-1)

