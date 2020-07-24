### wod_build

#### Syntax

```Matlab
[wod] = wod_build(wod_dir,variable_list)
```
#### Description

``wod_build(wod_dir,variable_list)`` loads profiles in path ``wod_dir`` into the struct ``wod`` with all variables specified in ``variable_list``. Variables lon, lat, date, z are included automatically.

#### Example 1


% wod_build

```Matlab

% Get variable information:

wod_dir = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/wod/*.nc'; % included
netcdf_info(wod_dir);

% Load data in path:

variable_list = {'Temperature','Salinity'}; % Variables to read (besides lon, lat, date, z).
[wod] = wod_build(wod_dir,variable_list);

% Plot profiles:

general_profiles(wod,'Temperature','depth')

```
<img src="https://user-images.githubusercontent.com/24570061/88361566-748d2280-cd47-11ea-82a7-0458d6e2c8dc.png" width="600">

[Back](https://github.com/lnferris/ocean_data_tools#building-uniform-structs-from-data-sources-1)

