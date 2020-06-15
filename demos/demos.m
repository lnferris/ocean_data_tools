%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 15-Jun-2020
%  Distributed under the terms of the MIT License
%  Dependencies: nctoolbox

%  Demonstrations of ocean_data_tools. 
%  Try running one section at a time.
%  See README for nfo on how to download data.
%  Setup nctoolbox (run command below once) before using ocean_data_tools.

setup_nctoolbox


%% argo

% argo_load

argo_dir = '/Users/lnferris/Desktop/coriolis_25feb2018/*profiles*.nc';
region = [-90.0 90.0 -90.0 -60.0]; %  Search region [-90 90 -180 180]
start_date = '01-Jan-2016 00:00:00';
end_date = '10-Jan-2016 00:00:00';
[argo,matching_files] = argo_load(argo_dir,region,start_date,end_date);

% argo_platform_map

annotate = 1; 
argo_platform_map(argo,annotate) % annotate optional,  1=on 0=off
bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_18.1.img';
bathymetry_plot(bathymetry_dir,bathymetry_region(argo),'2Dcontour')

% argo_platform_subset

platform_id = 1901411;
[argo_sub] = argo_platform_subset(argo,platform_id);

% argo_profiles_map

annotate = 1; 
argo_profiles_map(argo,annotate) % annotate optional,  1=on 0=off
bathymetry_plot(bathymetry_dir,bathymetry_region(argo),'2Dcontour') % add bathymetry contours

% argo_profiles

variable = 'TEMP'; % 'PSAL' 'TEMP'
annotate = 1; 
argo_profiles(argo,variable,annotate) % annotate optional,  1=on 0=off


%% bathymetry (smith & sandwell)

%  bathymetry_chord

bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_18.1.img';
lon1 = 160; % Starting point of linear slice.
lat1 = -67;
lon2 = 280; % Ending point of linear slice.
lat2 = -66.5;
xref = 'LON'; % 'LON' 'LAT'
width = 1/60; % Approximate width of chord in degrees
whp_cruise_section(cruise,variable,xref) 
bathymetry_chord(bathymetry_dir,lon1,lat1,lon2,lat2,xref,width) % width optional

% bathymetry_plot

bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_18.1.img';
region = [-5.0, 45.0 ,120, -150];      % [-90 90 -180 180]
ptype = '3Dsurf'; % '2Dscatter' '2Dcontour' '3Dsurf'
figure
bathymetry_plot(bathymetry_dir,region,ptype)

% bathymetry_section

xref = 'LON'; % 'LON' 'LAT'
whp_cruise_section(cruise,variable,xref)
xcoords = linspace(170,280,50); % could alternatively use transect_select() to select coordinates
ycoords = linspace(-70,-66,50);
bathymetry_section(bathymetry_dir,xcoords,ycoords,xref)

% bathymetry_section_whp

xref = 'LON'; % 'LON' 'LAT'
whp_cruise_section(cruise,variable,xref)
bathymetry_section_whp(bathymetry_dir,cruise,xref)


%% general

% general_map

bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_18.1.img';
ptype = '2Dcontour'; % '2Dscatter' '2Dcontour'
object = cruise; % cruise or argo or wod or hycom
general_map(object,bathymetry_dir,ptype)

% general_region_subset

object = hycom; % cruise or argo or wod hycom
general_map(object)
[xcoords,ycoords] = region_select(); % click desired  region on the figure
[hycom_sub] = general_region_subset(object,xcoords,ycoords); 


%% hycom

setup_nctoolbox 

% hycom_simple_plot

url = 'http://tds.hycom.org/thredds/dodsC/GLBv0.08/expt_57.7'; % Could also be a local file e.g. '/Users/lnferris/expt_57.7.nc'
date = '28-Aug-2017 00:00:00';   
variable = 'velocity';                 % 'water_u' 'water_v' 'water_temp' 'salinity' 'velocity'
region = [-5.0, 45.0 ,120, -150];      % [-90 90 -180 180]
depth = -150;                          % Depth level between 0 and -5000m
arrows = 0;                            % Velocity direction arrows 1=on 0=off
hycom_simple_plot(url,date,variable,region,depth,arrows) % arrows optional 

% hycom_build_profiles   

variable = 'salinity';  % 'water_u' 'water_v' 'water_temp' 'salinity'
hycom_simple_plot(url,date,variable,region,0)
[xcoords,ycoords] = transect_select(10); % click desired transect on the figure, densify selection by 10x 
[hycom] =  hycom_build_profiles(url,date,variable,xcoords,ycoords);
bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_18.1.img';
general_map(hycom,bathymetry_dir,'2Dcontour')

% hycom_section

xref = 'STN'; % 'LAT' 'LON' 'STN';
variable = 'salinity';  % 'water_u' 'water_v' 'water_temp' 'salinity'
hycom_section(hycom,variable,xref)

% hycom_profiles

hycom_profiles(hycom,variable)

%% mocha

%mocha_simple_plot

month = 10; 
depth = 0;
variable = 'temperature'; %  'temperature' 'salinity'
mocha_simple_plot(month,depth,variable)


%% whp cruise data (go-ship)

% whp_cruise_load

ctdo_dir = '/Users/lnferris/Desktop/S04P/320620180309_nc_ctd/*.nc';
%uv_dir = '/Users/lnferris/Desktop/S04P/processed_uv_20181030_nc/*.nc'; % Can use .nc or .mat for uv
uv_dir = '/Users/lnferris/Desktop/S04P/processed_uv_20181030/*.mat';
wvke_dir = '/Users/lnferris/Desktop/S04P/processed_w_20181030/';
[cruise] = whp_cruise_load(ctdo_dir,uv_dir,wvke_dir); % uv_dir, wvke_dir optional 

% whp_cruise_section

variable = 'CTDTMP'; % 'CTDSAL' 'CTDTMP' 'CTDOXY' 'U' 'V' 'DC_W' 'P0' 'EPS'
xref = 'LON'; %'LON' 'LAT' 'STN' 
whp_cruise_section(cruise,variable,xref)

% whp_cruise_profiles

whp_cruise_profiles(cruise,variable)


%% wod_load

wod_dir = '/Users/lnferris/Desktop/woddata/*.nc';
[wod] = wod_load(wod_dir);
general_map(wod,bathymetry_dir)


%% wod_profiles

variable = 'CTDTMP'; % 'CTDTMP'' 'CTDSAL'
wod_profiles(wod,variable)








