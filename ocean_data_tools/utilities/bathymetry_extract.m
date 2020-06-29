%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 29-Jun-2020
%  Distributed under the terms of the MIT License

% bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc'; % Path to Smith & Sandwell database 

function [bath,lat,lon]=  bathymetry_extract(bathymetry_dir,region)

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
lat = lat(si:ni);   
if region(3) > region(4) % if data spans the dateline...
    [wi_left] = near(lon,region(3));
    [ei_left] = near(lon,180);
    [wi_right] = near(lon,-180); 
    [ei_right] = near(lon,region(4)); 
    bath = [bath(wi_left:ei_left,si:ni); bath(wi_right:ei_right,si:ni)];
    lon = [lon(wi_left:ei_left); lon(wi_right:ei_right)];   
    lon(lon < 0) = lon(lon < 0) + 360; % map to [0 360]
    [lon,lon_inds] = sort(lon);
    bath = bath(lon_inds,:);
else
    [lonw] = near(lon,region(3));
    [lone] = near(lon,region(4));   
    bath = bath(lonw:lone,si:ni);
    lon = lon(lonw:lone); 
end

[lon,lon_inds] = sort(lon);
bath = bath(lon_inds,:);
 
end


