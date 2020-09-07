
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 06-Sep-2020
%  Dependencies: nctoolbox

%  These are demonstrations of each function in ocean_data_tools. 
%  Please download nctoolbox and bathymetry (see README/Getting Started)
%  before running the demonstrations. Do not skip the initial setup.


%%                   initial setup

% Set up the nctoolbox dependency.
setup_nctoolbox

% Specify path to downloaded bathymetry. 
bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc'; % YOU MUST MODIFY LINE 15!

% Automatically generate paths to included test data. 
data_path = [fileparts(fileparts(matlab.desktop.editor.getActiveFilename)),'/','data/']; % DO NOT MODIFY LINES 18-23!
argo_dir = [data_path,'argo/*profiles*.nc']; 
ctdo_dir = [data_path,'whp_cruise/ctd/*.nc']; 
uv_dir = [data_path,'whp_cruise/uv/*.nc'];
wvke_dir = [data_path,'whp_cruise/wvke/'];
wod_dir = [data_path,'wod/*.nc']; 

% Uncomment any of the following to hard-code paths.
%argo_dir = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/argo/*profiles*.nc'; % uncomment to hard-code path
%ctdo_dir = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/whp_cruise/ctd/*.nc'; % uncomment to hard-code path
%uv_dir = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/whp_cruise/uv/*.nc'; % uncomment to hard-code path
%wvke_dir = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/whp_cruise/wvke/'; % uncomment to hard-code path
%wod_dir = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/wod/*.nc'; % uncomment to hard-code path


%%                  argo demonstration

% argo_build
listing = dir(argo_dir); % Peek at netCDF header info to inform choice of variable_list.
ncdisp([listing(1).folder '/' listing(1).name])
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
bathymetry_plot(bathymetry_extract(bathymetry_dir,bounding_region(argo)),'2Dcontour')

% argo_profiles

variable = 'TEMP_ADJUSTED'; % See object for options.
annotate = 1; 
argo_profiles(argo,variable,annotate) % annotate optional,  1=on 0=off

% argo_profiles_map

annotate = 1; 
argo_profiles_map(argo,annotate) % annotate optional,  1=on 0=off
bathymetry_plot(bathymetry_extract(bathymetry_dir,bounding_region(argo)),'2Dcontour') % add bathymetry contours


%%                  bathymetry demonstration

% bathymetry_extract

region = [-5.0, 45.0 ,120, -150];      % [-90 90 -180 180];
[bathy] = bathymetry_extract(bathymetry_dir,region);

% bathymetry_plot

ptype = '2Dcontour'; % '2Dscatter' '2Dcontour' '3Dsurf'
figure
bathymetry_plot(bathy,ptype)

% bathymetry_section

[cruise] = whp_cruise_build(ctdo_dir,uv_dir,wvke_dir,{'temperature'}); 
xref = 'lon'; % 'lon' 'lat' or a time vector of length(xcoords)
general_section(cruise,'temperature',xref,'pressure')
xcoords = cruise.lon; % could alternatively use transect_select() to select coordinates
ycoords = cruise.lat;
filled = 1;  % 1=on 0=off
region = bounding_region([],xcoords,ycoords);
[bathy] = bathymetry_extract(bathymetry_dir,region);
bathymetry_section(bathy,xcoords,ycoords,xref,filled) % filled optional


%%                  general demonstration

% general_map
[argo,matching_files] = argo_build(argo_dir,[-60.0 -50.0 150.0 160.0],'01-Nov-2015 00:00:00','01-Jan-2017 00:00:00',{'TEMP_ADJUSTED'});
ptype = '2Dcontour'; % '2Dscatter' '2Dcontour'
object = argo; % argo, cruise, hycom, mercator, woa, wod
general_map(object,bathymetry_dir,ptype) % bathymetry_dir, ptype optional

% general_depth_subset

variable_list = {'salinity','temperature','oxygen'};
[cruise] = whp_cruise_build(ctdo_dir,uv_dir,wvke_dir,variable_list); % Use a dummy path (e.g. uv_dir ='null') if missing data. 
depth_list = {'pressure','z','depth','depth_vke'}; % list of depth fields to subset
object = cruise;
zrange = [350 150]; % order and sign don't matter
[subobject] =  general_depth_subset(object,zrange,depth_list); % depth_list option, default 'depth'

% general_region_subset

object = argo; % % argo, cruise, hycom, mercator, woa, wod
general_map(object)
[xcoords,ycoords] = region_select(); % click desired  region on the figure
[object_sub] = general_region_subset(object,xcoords,ycoords); 

% general_remove_duplicates

source = 'http://tds.hycom.org/thredds/dodsC/GLBv0.08/expt_57.7';
date = '28-Aug-2017 00:00:00'; 
xcoords = -75:1/48:-74;
ycoords = 65:1/48:66;
variable_list = {'water_temp','salinity'}; 
[hycom] = model_build_profiles(source,date,variable_list,xcoords,ycoords);
object = hycom;
[sub_object] = general_remove_duplicates(object);

% general_section

object = argo; % argo, cruise, hycom, mercator, woa, wod
variable = 'TEMP_ADJUSTED'; % see particular struct for options
xref = 'lat'; % 'lat' 'lon' 'stn';
zref = 'PRES_ADJUSTED'; % See particular struct for options
interpolate = 0; % 1=on 0=off
contours = 0; % 1=on 0=off
general_section(object,variable,xref,zref,interpolate,contours) % interpolate, contours optional

% general_profiles

object = argo; % argo, cruise, hycom, mercator, woa, wod
variable = 'TEMP_ADJUSTED'; % see particular struct for options
general_profiles(object,variable,zref)


%%                  mocha demonstration

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
bathymetry_plot(bathymetry_extract(bathymetry_dir,region),'3Dsurf')
caxis([0 1])


%%                  whp cruise demonstration

% whp_cruise_build
listing = dir(ctdo_dir); % Peek at netCDF header info to inform choice of variable_list.
ncdisp([listing(1).folder '/' listing(1).name])
variable_list = {'salinity','temperature','oxygen'};
[cruise] = whp_cruise_build(ctdo_dir,uv_dir,wvke_dir,variable_list); % Use a dummy path (e.g. uv_dir ='null') if missing data. 
general_map(cruise,bathymetry_dir,'2Dcontour')

variable = 'temperature'; % See cruise for options.
xref = 'lon'; % See cruise for options.
zref = 'pressure'; % See cruise for options.
interpolate = 1; % 1=on 0=off
contours = 0; % 1=on 0=off
general_section(cruise,variable,xref,zref,interpolate,contours) % interpolate, contours optional

general_profiles(cruise,variable,zref)


%%                  woa demonstration

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
[woa] = general_remove_duplicates(woa); % thin struct to gridding of source (optional)
general_map(woa,bathymetry_dir,'2Dcontour')
general_section(woa,'salinity','lon','depth')
[bathy] = bathymetry_extract(bathymetry_dir,bounding_region([],xcoords,ycoords));
bathymetry_section(bathy,xcoords,ycoords,'lon',1) % filled optional
general_profiles(woa,'oxygen','depth')

% woa_domain_plot

woa_domain_plot(variable,time,region)


%%                  wod demonstration

% wod_build

listing = dir(wod_dir); % Peek at netCDF header info to inform choice of variable_list.
ncdisp([listing(1).folder '/' listing(1).name])
variable_list = {'Temperature','Salinity'}; % Variables to read (besides lon, lat, date, z).
[wod] = wod_build(wod_dir,variable_list);
general_map(wod,bathymetry_dir)
general_profiles(wod,'Temperature','depth')
