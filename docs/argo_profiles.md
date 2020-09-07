### argo_profiles

#### Syntax

```Matlab
argo_profiles(argo,variable) 
argo_profiles(argo,variable,annotate)
```
#### Description

``argo_profiles(argo,variable)`` plots vertical profiles of the specified variable in struct ``argo`` as a function of depth (PRES_ADJUSTED); where ``argo`` is a struct created by ``argo_build`` and ``variable`` is a field name.
 
``argo_profiles(argo,variable,annotate)`` adds number annotations to the markers by default ``annotate=0``. Set ``annotate=1`` to turn on annotation. The annotations of profiles correspond to those of ``argo_profiles_map`` called on the same struct.

#### Example 1


```Matlab

% Get variable information:

argo_dir = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/argo/*profiles*.nc';
listing = dir(argo_dir); 
ncdisp([listing(1).folder '/' listing(1).name]) % Peek at netCDF header info to inform choice of variable_list.

% Load Argo data from west of New Zealand:

region = [-60.0 -50.0 150.0 160.0]; %  Search region [-90 90 -180 180]
start_date = '28-Dec-2016 00:00:00';
end_date = '01-Jan-2017 00:00:00';
variable_list = {'TEMP_ADJUSTED','PSAL_ADJUSTED'};
[argo,matching_files] = argo_build(argo_dir,region,start_date,end_date,variable_list);

% Plot profiles with annotations:

variable = 'TEMP_ADJUSTED'; % See object for options.
annotate = 1; 
argo_profiles(argo,variable,annotate) % annotate optional,  1=on 0=off

```
<img src="https://user-images.githubusercontent.com/24570061/88327048-b04acc80-ccf4-11ea-8e1d-4ae00634953c.png" width="600">

```Matlab
% Map profiles with annotations:

annotate = 1; 
argo_profiles_map(argo,annotate) % annotate optional,  1=on 0=off
bathymetry_plot(bathymetry_extract(bathymetry_dir,bounding_region(argo)),'2Dcontour') % add bathymetry contours
```

<img src="https://user-images.githubusercontent.com/24570061/88327053-b2149000-ccf4-11ea-8d1d-c0493bf9ef43.png" width="600">

[Back](https://github.com/lnferris/ocean_data_tools#additional-functions-for-inspecting-argo-data-1)

