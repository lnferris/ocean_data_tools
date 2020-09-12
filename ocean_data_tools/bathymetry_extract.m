
function [bathy] = bathymetry_extract(bathymetry_dir,region)
% bathymetry_extract extracts global seafloor topography (Smith & Sandwell,
% 1997) for a specified region
% 
%% Syntax
% 
% [bathy] =  bathymetry_extract(bathymetry_dir,region)
% 
%% Description 
% 
% [bathy] =  bathymetry_extract(bathymetry_dir,region) extracts
% Smith & Sandwell Global Topography in path bathymetry_dir over the specified
% rectangular region. Struct bathy has fields z, lat, and lon and contains
% only the data from the specified region.
%
% bathymetry_dir is the character array path to the Smith & Sandwell Global Topography
% file "topo_20.1.nc"
%
% region is a vector containing the bounds [S N W E] of the search region, 
% with limits [-90 90 -180 180]. Limits may cross the dateline e.g. [35 45
% 170 -130].
%
%% Example 1
% Extract relevant bathymetry over a region:
% 
% bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc';
% region = [-60.0 -50.0 150.0 160.0];
% [bathy] = bathymetry_extract(bathymetry_dir,region);
% 
%% Example 2
% Extract relevant bathymetry around struct argo:
%
% bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc';
% region = bounding_region(argo);
% [bathy] = bathymetry_extract(bathymetry_dir,region);
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 09-Sep-2020
% 
% See also bounding_region, bathymetry_section, and bathymetry_plot.

assert(length(region)==4,'Error: Region must be format [-90 90 -180 180].');

% deal with inputs other than [-90 90 -180 180] e.g  [-90 90 20 200] 
region(region>180) = region(region>180)- 360;
region(region<-180) = region(region<-180)+360;

% load bathymetry.
nc = netcdf.open(bathymetry_dir, 'NOWRITE'); % open the file as netcdf datasource.
lon = netcdf.getVar(nc,netcdf.inqVarID(nc,'lon')); % [-180  180]
lat = netcdf.getVar(nc,netcdf.inqVarID(nc,'lat')); % [-80  80]
bath = netcdf.getVar(nc,netcdf.inqVarID(nc,'z')); % lon x lat
netcdf.close(nc); % close the file.  

% subset to region
[si,~] = near(lat,region(1)); % Find lat index near southern boundary [-90 90] of region.
[ni,~] = near(lat,region(2));
[wi,~] = near(lon,region(3));
[ei,~] = near(lon,region(4));
if wi == ei
    ei = ei-1;
end

lat = lat(si:ni);   
if wi > ei % if data spans the dateline...
    [wi_left] = near(lon,region(3));
    [ei_left] = near(lon,180);
    [wi_right] = near(lon,-180); 
    [ei_right] = near(lon,region(4)); 
    bath = [bath(wi_left:ei_left,si:ni); bath(wi_right:ei_right,si:ni)];
    lon = [lon(wi_left:ei_left); lon(wi_right:ei_right)+360];   

else 
    bath = bath(wi:ei,si:ni);
    lon = lon(wi:ei); 
end

[lon,lon_inds] = sort(lon);
bath = bath(lon_inds,:);

bathy.z = bath;
bathy.lon = lon;
bathy.lat = lat;
 
end


