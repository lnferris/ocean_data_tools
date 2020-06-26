%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 21-Jun-2020
%  Distributed under the terms of the MIT License
%  Dependencies: nctoolbox

%  Demonstrations of ocean_data_tools. 
%  Try running one section at a time.
%  See README for nfo on how to download data.
%  Setup nctoolbox (run command below once) before using ocean_data_tools.

setup_nctoolbox


%% argo

% argo_build

argo_dir = '/Users/lnferris/Desktop/coriolis_25feb2018/*profiles*.nc';
netcdf_info(argo_dir);
region = [-90.0 90.0 -90.0 -60.0]; %  Search region [-90 90 -180 180]
start_date = '01-Jan-2016 00:00:00';
end_date = '10-Jan-2016 00:00:00';
variable_list = {'TEMP_ADJUSTED','PSAL_ADJUSTED'}; % Variables to read (besides id, lon, lat, date, z).
[argo,matching_files] = argo_build(argo_dir,region,start_date,end_date,variable_list);

% argo_platform_subset

platform_id = 7900204;
[argo_sub] = argo_platform_subset(argo,platform_id);

% argo_platform_map

annotate = 1; 
argo_platform_map(argo,annotate) % annotate optional,  1=on 0=off
bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc';
bathymetry_plot(bathymetry_dir,bathymetry_region(argo),'2Dcontour')

% argo_profiles

variable = 'TEMP_ADJUSTED'; % See object for options.
annotate = 1; 
argo_profiles(argo,variable,annotate) % annotate optional,  1=on 0=off

% argo_profiles_map

annotate = 1; 
argo_profiles_map(argo,annotate) % annotate optional,  1=on 0=off
bathymetry_plot(bathymetry_dir,bathymetry_region(argo),'2Dcontour') % add bathymetry contours


%% bathymetry (smith & sandwell)

%  bathymetry_chord

bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc';
lon1 = 160; % Starting point of linear slice.
lat1 = -67;
lon2 = 280; % Ending point of linear slice.
lat2 = -66.5;
xref = 'lon'; % 'lon' 'lat'
width = 1/60; % Approximate width of chord in degrees
whp_cruise_section(cruise,variable,xref) 
filled = 0;
bathymetry_chord(bathymetry_dir,lon1,lat1,lon2,lat2,xref,width,filled) % width, filled optional

% bathymetry_plot

bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc';
region = [-5.0, 45.0 ,120, -150];      % [-90 90 -180 180]
ptype = '2Dcontour'; % '2Dscatter' '2Dcontour' '3Dsurf'
figure
bathymetry_plot(bathymetry_dir,region,ptype)

% bathymetry_section

xref = 'lon'; % 'lon' 'lat'
whp_cruise_section(cruise,variable,xref)
xcoords = cruise.lon; % could alternatively use transect_select() to select coordinates
ycoords = cruise.lat;
filled = 1;  % 1=on 0=off
bathymetry_section(bathymetry_dir,xcoords,ycoords,xref,filled) % filled optional


%% general

% general_map

bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc';
ptype = '2Dcontour'; % '2Dscatter' '2Dcontour'
object = hycom; % argo or cruise or hycom or woa or wod
general_map(object,bathymetry_dir,ptype)

% general_region_subset

object = cruise; % argo or cruise or hycom or woa or wod
general_map(object)
[xcoords,ycoords] = region_select(); % click desired  region on the figure
[hycom_sub] = general_region_subset(object,xcoords,ycoords); 

% general_section

object = hycom; % argo or hycom or woa or wod
variable = 'salinity'; % see particular struct for options
xref = 'lat'; % 'lat' 'lon' 'stn';
interpolate = 1; % 1=on 0=off
contours = 1; % 1=on 0=off
general_section(object,variable,xref,interpolate,contours) % interpolate, contours optional

% general_profiles

object = hycom; % argo or hycom or woa or wod
variable = 'salinity'; % see particular struct for options
general_profiles(object,variable)


%% mocha

setup_nctoolbox

%mocha_simple_plot

month = 10; % Month (1 through 12).
depth = 0;
variable = 'temperature'; %  'temperature' 'salinity'
region = [34 42  -80 -70]; % [30 48 -80 -58]
mocha_simple_plot(month,depth,variable,region)


%% model (hycom example)

setup_nctoolbox

% model_simple_plot - HYCOM EXAMPLE

model = 'hycom'; % 'hycom' 'mercator'
source = 'http://tds.hycom.org/thredds/dodsC/GLBv0.08/expt_57.7'; % url or local .nc 
date = '28-Aug-2017 00:00:00';  
variable = 'surf_el';                  % 'water_u' 'water_v' 'water_temp' 'salinity' 'velocity' 'surf_el' 'water_u_bottom' 'water_v_bottom' 'water_temp_bottom' 'salinity_bottom' 
region = [-5.0, 45.0 ,120, -150];      % [-90 90 -180 180]
depth = -150;                          % Depth level between 0 and -5000m
arrows = 0;                            % Velocity direction arrows 1=on 0=off
model_simple_plot(model,source,date,variable,region,depth,arrows)

% model_build_profiles  - HYCOM EXAMPLE

[xcoords,ycoords] = transect_select(10); % click desired transect on the figure, densify selection by 10x 
variable_list = {'water_temp','salinity'}; % 'water_u' 'water_v' 'water_temp' 'salinity'
[hycom] =  model_build_profiles(source,date,variable_list,xcoords,ycoords);
bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc';
general_map(hycom,bathymetry_dir,'2Dcontour')
general_section(hycom,'water_temp','stn')
general_profiles(hycom,'salinity')

% model_domain_plot - HYCOM EXAMPLE

variable = 'velocity'; % 'water_u' 'water_v' 'water_temp' 'salinity' 'velocity' 
model_domain_plot(model,source,date,variable,region)


%% model (mercator example)

setup_nctoolbox

% model_simple_plot - MERCATOR EXAMPLE

model = 'mercator'; % 'hycom' 'mercator'
source = '/Users/lnferris/Desktop/global-analysis-forecast-phy-001-024_1592862540227.nc';
date = '18-Mar-2020 00:00:00';   
variable = 'thetao'; % 'thetao' 'so' 'uo' 'vo' 'velocity' 'mlotst' 'siconc' 'usi' 'vsi' 'sithick' 'bottomT' 'zos'
region = [45.0, 80.0 ,-80, -50];      % [-90 90 -180 180]
depth = -150;                          % Depth level between 0 and -5728m
arrows = 0;  
model_simple_plot(model,source,date,variable,region,depth,arrows)

% model_build_profiles  - MERCATOR EXAMPLE

[xcoords,ycoords] = transect_select(10); % click desired transect on the figure, densify selection by 10x 
variable_list = {'thetao','so','uo'}; % thetao' 'so' 'uo' 'vo'
[mercator] =  model_build_profiles(source,date,variable_list,xcoords,ycoords);
bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc';
general_map(mercator,bathymetry_dir,'2Dcontour')
general_section(mercator,'thetao','stn')
general_profiles(mercator,'so')

% model_domain_plot - MERCATOR EXAMPLE

variable = 'velocity';  % thetao' 'so' 'uo' 'vo' 'velocity'
model_domain_plot(model,source,date,variable,region)


%% whp cruise data (go-ship)

% whp_cruise_build

ctdo_dir = '/Users/lnferris/Desktop/S04P/320620180309_nc_ctd/*.nc';
%uv_dir = '/Users/lnferris/Desktop/S04P/processed_uv_20181030_nc/*.nc'; % Can use .nc or .mat for uv
uv_dir = '/Users/lnferris/Desktop/S04P/processed_uv_20181030/*.mat';
wvke_dir = '/Users/lnferris/Desktop/S04P/processed_w_20181030/';
netcdf_info(ctdo_dir) % Get cruise information.
[cruise] = whp_cruise_build(ctdo_dir,uv_dir,wvke_dir); % Use a dummy path (e.g. uv_dir ='null') if missing data. 

% whp_cruise_section

variable = 'CTDTMP'; % 'CTDSAL' 'CTDTMP' 'CTDOXY' 'U' 'V' 'DC_W' 'P0' 'EPS'
xref = 'lon'; %'lon' 'lat' 'stn' 
interpolate = 0; % 1=on 0=off
contours = 0; % 1=on 0=off
whp_cruise_section(cruise,variable,xref,interpolate,contours) % interpolate, contours optional

% whp_cruise_profiles

whp_cruise_profiles(cruise,variable)


%% woa (world ocean atlas)

setup_nctoolbox

% woa_simple_plot

variable = 'nitrate'; % 'temperature' 'salinity' 'oxygen' 'o2sat' 'AOU' 'silicate' 'phosphate' 'nitrate'
time = '03'; % '00' for annual climatology '01' '10' etc. for monthly climatology
region = [-5.0, 45.0 ,120, -150]; 
depth = -0; % meters -0 to -5500
woa_simple_plot(variable,time,region,depth)

% woa_build_profiles   

variable_list = {'temperature','salinity','oxygen'}; % 'temperature' 'salinity' 'oxygen' 'o2sat' 'AOU' 'silicate' 'phosphate' 'nitrate'
time = '00'; % '00' for annual climatology '01' '10' etc. for monthly climatology
[xcoords,ycoords] = transect_select(10); % click desired transect on the figure, densify selection by 10x 
[woa] =  woa_build_profiles(variable_list,time,xcoords,ycoords);
bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc';
general_map(woa,bathymetry_dir,'2Dcontour')
general_section(woa,'salinity','stn')
general_profiles(woa,'oxygen')

% woa_domain_plot

woa_domain_plot(variable,time,region)


%% wod (world ocean database)

% wod_build

wod_dir = '/Users/lnferris/Desktop/woddata/*O.nc';
netcdf_info(wod_dir); % Get information to inform choice of variable_list.
variable_list = {'Temperature','Salinity'}; % Variables to read (besides lon, lat, date, z).
[wod] = wod_build(wod_dir,variable_list);
bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc';
general_map(wod,bathymetry_dir)
general_profiles(wod,'Temperature')
