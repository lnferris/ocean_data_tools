%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 14-Jul-2020
%  Distributed under the terms of the MIT License
%  Dependencies: nctoolbox

%  These are demonstrations of each function in ocean_data_tools. 
%  Please download nctoolbox and bathymetry (see README/Getting Started)
%  before running the demonstrations.


%%                  argo demonstration

argo_dir = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/argo/*profiles*.nc'; % included
bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc'; % need to download

% argo_build

netcdf_info(argo_dir);
region = [-60.0 -50.0 150.0 160.0]; %  Search region [-90 90 -180 180]
start_date = '01-Nov-2015 00:00:00';
end_date = '01-Jan-2017 00:00:00';
variable_list = {'TEMP_ADJUSTED','PSAL_ADJUSTED'}; % Variables to read (besides id, lon, lat, date, z).
[argo,~] = argo_build(argo_dir,region,start_date,end_date,variable_list);

% argo_platform_subset

platform_id = 1900980;
[argo_sub] = argo_platform_subset(argo,platform_id);

% argo_platform_map 

annotate = 1; 
argo_platform_map(argo,annotate) % annotate optional,  1=on 0=off
bathymetry_plot(bathymetry_dir,bathymetry_region(argo),'2Dcontour')

% argo_profiles

variable = 'TEMP_ADJUSTED'; % See object for options.
annotate = 1; 
argo_profiles(argo,variable,annotate) % annotate optional,  1=on 0=off

% argo_profiles_map

annotate = 1; 
argo_profiles_map(argo,annotate) % annotate optional,  1=on 0=off
bathymetry_plot(bathymetry_dir,bathymetry_region(argo),'2Dcontour') % add bathymetry contours


%%                  bathymetry demonstration

bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc'; % need to download
ctdo_dir = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/whp_cruise/ctd/*.nc'; % included
uv_dir = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/whp_cruise/uv/*.nc'; % included
wvke_dir = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/whp_cruise/wvke/'; % included

%  bathymetry_chord

lon1 = 160; % Starting point of linear slice. If you want to do something exceptionally weird e.g. 240:210 just use bathymetry_section.
lat1 = -67;
lon2 = 280; % Ending point of linear slice.
lat2 = -66.5;
xref = 'lon'; % 'lon' 'lat'
width = 1/60; % Approximate width of chord in degrees
[cruise] = whp_cruise_build(ctdo_dir,uv_dir,wvke_dir,{'temperature'}); 
general_section(cruise,'temperature',xref,'pressure') 
filled = 0;
bathymetry_chord(bathymetry_dir,lon1,lat1,lon2,lat2,xref,filled,width) % filled, width optional

% bathymetry_plot

region = [-5.0, 45.0 ,120, -150];      % [-90 90 -180 180]
ptype = '2Dcontour'; % '2Dscatter' '2Dcontour' '3Dsurf'
figure
bathymetry_plot(bathymetry_dir,region,ptype)

% bathymetry_section

xref = 'lon'; % 'lon' 'lat'
general_section(cruise,'temperature',xref,'pressure')
xcoords = cruise.lon; % could alternatively use transect_select() to select coordinates
ycoords = cruise.lat;
filled = 1;  % 1=on 0=off
bathymetry_section(bathymetry_dir,xcoords,ycoords,xref,filled) % filled optional


%%                  general demonstration


argo_dir = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/argo/*profiles*.nc'; % included
bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc'; % need to download

% general_map
[argo,matching_files] = argo_build(argo_dir,[-60.0 -50.0 150.0 160.0],'01-Nov-2015 00:00:00','01-Jan-2017 00:00:00',{'TEMP_ADJUSTED'});
ptype = '2Dcontour'; % '2Dscatter' '2Dcontour'
object = argo; % argo, cruise, hycom, mercator, woa, wod
general_map(object,bathymetry_dir,ptype)

% general_region_subset

object = argo; % % argo, cruise, hycom, mercator, woa, wod
general_map(object)
[xcoords,ycoords] = region_select(); % click desired  region on the figure
[object_sub] = general_region_subset(object,xcoords,ycoords); 

% general_section

object = argo; % argo, cruise, hycom, mercator, woa, wod
variable = 'TEMP_ADJUSTED'; % see particular struct for options
xref = 'lat'; % 'lat' 'lon' 'stn';
zref = 'depth'; % See particular struct for options
interpolate = 0; % 1=on 0=off
contours = 0; % 1=on 0=off
general_section(object,variable,xref,zref,interpolate,contours) % interpolate, contours optional

% general_profiles

object = argo; % argo, cruise, hycom, mercator, woa, wod
variable = 'TEMP_ADJUSTED'; % see particular struct for options
general_profiles(object,variable,zref)


%%                  mocha demonstration

setup_nctoolbox

bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc'; % need to download

% mocha_simple_plot

month = 10; % Month (1 through 12).
depth = 0;
variable = 'temperature'; %  'temperature' 'salinity'
region = [34 42  -80 -70]; % [30 48 -80 -58]

mocha_simple_plot(month,depth,variable,region)

% mocha_build_profiles

[xcoords,ycoords] = transect_select(10); % click desired transect on the figure, densify selection by 10x 
zgrid = 1; % vertical grid for linear interpolation in meters
[mocha] = mocha_build_profiles(month,xcoords,ycoords,zgrid); % zgrid optional, no interpolation if unspecified
general_map(mocha,bathymetry_dir,'2Dcontour')
general_section(mocha,'temperature','stn','depth',1,1)
general_profiles(mocha,'salinity','depth')

% mocha_domain_plot

mocha_domain_plot(month,variable,region)
 

%%                  model (hycom) demonstration

setup_nctoolbox

bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc'; % need to download

% model_simple_plot - HYCOM EXAMPLE

model = 'hycom'; % 'hycom' 'mercator'
source = 'http://tds.hycom.org/thredds/dodsC/GLBv0.08/expt_57.7'; % url or local .nc 
date = '28-Aug-2017 00:00:00';  
variable = 'velocity';                 % 'water_u' 'water_v' 'water_temp' 'salinity' 'velocity' 'surf_el' 'water_u_bottom' 'water_v_bottom' 'water_temp_bottom' 'salinity_bottom' 
region = [-5.0, 45.0 ,160,-150 ];      % [-90 90 -180 180]
depth = -150;                          % Depth level between 0 and -5000m
arrows = 0;                            % Velocity direction arrows 1=on 0=off
[data,lat,lon] = model_simple_plot(model,source,date,variable,region,depth,arrows); % optionally output the plotted data layer

% model_build_profiles  - HYCOM EXAMPLE

[xcoords,ycoords] = transect_select(10); % click desired transect on the figure, densify selection by 10x 
variable_list = {'water_temp','salinity'}; % 'water_u' 'water_v' 'water_temp' 'salinity'
zgrid = 1; % vertical grid for linear interpolation in meters
[hycom] =  model_build_profiles(source,date,variable_list,xcoords,ycoords,zgrid); % zgrid optional, no interpolation if unspecified
general_map(hycom,bathymetry_dir,'2Dcontour')
general_section(hycom,'water_temp','stn','depth',1,1)
general_profiles(hycom,'salinity','depth')

% model_domain_plot - HYCOM EXAMPLE

variable = 'salinity'; % 'water_u' 'water_v' 'water_temp' 'salinity' 'velocity' 
model_domain_plot(model,source,date,variable,region)


%%                  model (mercator) demonstration

setup_nctoolbox

bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc'; % need to download

% model_simple_plot - MERCATOR EXAMPLE

model = 'mercator'; % 'hycom' 'mercator'
source = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/mercator/global-analysis-forecast-phy-001-024_1593408360353.nc'; % included
date = '18-Mar-2020 00:00:00';   
variable = 'thetao'; % 'thetao' 'so' 'uo' 'vo' 'velocity' 'mlotst' 'siconc' 'usi' 'vsi' 'sithick' 'bottomT' 'zos'
region = [60.0, 70.0 ,-80, -60];      % [-90 90 -180 180]
depth = -150;                          % Depth level between 0 and -5728m
arrows = 0;  
model_simple_plot(model,source,date,variable,region,depth,arrows)

% model_build_profiles  - MERCATOR EXAMPLE

variable_list = {'thetao','so','uo'}; % thetao' 'so' 'uo' 'vo'
[xcoords,ycoords] = transect_select(10); % click desired transect on the figure, densify selection by 10x 
zgrid = 1; % vertical grid for linear interpolation in meters
[mercator] =  model_build_profiles(source,date,variable_list,xcoords,ycoords,zgrid); % zgrid optional, no interpolation if unspecified
general_map(mercator,bathymetry_dir,'2Dcontour')
general_section(mercator,'thetao','stn','depth')
general_profiles(mercator,'so','depth')

% model_domain_plot - MERCATOR EXAMPLE

variable = 'velocity';  % thetao' 'so' 'uo' 'vo' 'velocity'
model_domain_plot(model,source,date,variable,region)
bathymetry_plot(bathymetry_dir,region,'3Dsurf')
caxis([0 1])


%%                  whp cruise demonstration

ctdo_dir = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/whp_cruise/ctd/*.nc'; % included
uv_dir = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/whp_cruise/uv/*.nc'; % included
wvke_dir = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/whp_cruise/wvke/'; % included
bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc'; % need to download

% whp_cruise_build

netcdf_info(ctdo_dir) % Get cruise information.
variable_list = {'salinity','temperature','oxygen'};
[cruise] = whp_cruise_build(ctdo_dir,uv_dir,wvke_dir,variable_list); % Use a dummy path (e.g. uv_dir ='null') if missing data. 
general_map(cruise,bathymetry_dir,'2Dcontour')

% whp_cruise_section

variable = 'temperature'; % See cruise for options.
xref = 'lon'; % See cruise for options.
zref = 'pressure'; % See cruise for options.
interpolate = 1; % 1=on 0=off
contours = 0; % 1=on 0=off
general_section(cruise,variable,xref,zref,interpolate,contours) % interpolate, contours optional

% whp_cruise_profiles

general_profiles(cruise,variable,zref)


%%                  woa demonstration

setup_nctoolbox

bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc'; % need to download

% woa_simple_plot

variable = 'nitrate'; % 'temperature' 'salinity' 'oxygen' 'o2sat' 'AOU' 'silicate' 'phosphate' 'nitrate'
time = '03'; % '00' for annual climatology '01' '10' etc. for monthly climatology
region = [-5.0, 45.0 ,-120, -150]; 
depth = -0; % meters -0 to -5500
woa_simple_plot(variable,time,region,depth)

% woa_build_profiles   

variable_list = {'temperature','salinity','oxygen'}; % 'temperature' 'salinity' 'oxygen' 'o2sat' 'AOU' 'silicate' 'phosphate' 'nitrate'
time = '00'; % '00' for annual climatology '01' '10' etc. for monthly climatology
[xcoords,ycoords] = transect_select(10); % click desired transect on the figure, densify selection by 10x 
zgrid = 1; % vertical grid for linear interpolation in meters
[woa] =  woa_build_profiles(variable_list,time,xcoords,ycoords,zgrid); % zgrid optional, no interpolation if unspecified
[woa] = remove_duplicate_profiles(woa); % thin struct to gridding of source
general_map(woa,bathymetry_dir,'2Dcontour')
general_section(woa,'salinity','lon','depth')
bathymetry_section(bathymetry_dir,xcoords,ycoords,'lon',1) % filled optional
general_profiles(woa,'oxygen','depth')

% woa_domain_plot

woa_domain_plot(variable,time,region)


%%                  wod demonstration

wod_dir = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/wod/*.nc'; % included
bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc'; % need to download

% wod_build

netcdf_info(wod_dir); % Get information to inform choice of variable_list.
variable_list = {'Temperature','Salinity'}; % Variables to read (besides lon, lat, date, z).
[wod] = wod_build(wod_dir,variable_list);
general_map(wod,bathymetry_dir)
general_profiles(wod,'Temperature','depth')
