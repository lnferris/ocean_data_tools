
function [bath,lat,lon] = bathymetry_extract(bathymetry_dir,region)
% bathymetry_extract extracts global seafloor topography (Smith & Sandwell,
% 1997) for a specified region
% 
%% Syntax
% 
% [bath,lat,lon]=  bathymetry_extract(bathymetry_dir,region)
% 
%% Description 
% 
% [bath,lat,lon]=  bathymetry_extract(bathymetry_dir,region) extracts
% Smith & Sandwell Global Topography in path bathymetry_dir over the specified
% rectangular region. This function is called by functions
% bathymetry_section, bathymetry_chord, and bathymetry_plot.
%
%% Example 1
% Extract relevant bathymetry over a region:
% 
% bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc';
% region = [-60.0 -50.0 150.0 160.0];
% [bath,lat,lon] = bathymetry_extract(bathymetry_dir,region);
% 
%% Example 2
% Extract relevant bathymetry around struct argo:
%
% bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc';
% region = bathymetry_region(argo);
% [bath,lat,lon] = bathymetry_extract(bathymetry_dir,region);
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 30-Jun-2020
% 
% See also bathymetry_region, bathymetry_section, bathymetry_chord, and bathymetry_plot.

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
 
end


