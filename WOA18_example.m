%%                  INFORMATION

%  Author: Lauren Newell Ferris
%  Institute: Virginia Institute of Marine Science
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Sep 2019; Last revision: 17-Sep-2019
%  Distributed under the terms of the MIT License
%  Dependencies: nctoolbox.github.io/nctoolbox/
%  Remember to run the command "setup_nctoolbox".


%% 1a. Load WOA18 temperature...

temp_url = 'https://data.nodc.noaa.gov/thredds/dodsC/ncei/woa/temperature/decav/0.25/woa18_decav_t00_04.nc';
url = temp_url;
nc = ncgeodataset(url); % Assign a ncgeodataset handle.
nc.variables % Print list of available variables. 
sv = nc{'t_an'}; % Assign ncgeovariable handle.


%% 2. Plot entire 3-D domain of data.

sv.attributes % Print ncgeovariable attributes.
svg = sv.grid_interop(:,:,:,:); % Get standardized (time,z,lat,lon) coordinates for the ncgeovariable.
[lats,ds] = near(svg.lat,-10.0); % Find lat index near southern boundary [-90 90] of region.
[latn,dn] = near(svg.lat,20.0);
[lonw,dw] = near(svg.lon,40.0);% Find lon index near western boundary [-180 180] of region.
[lone,de] = near(svg.lon,120.0);
[tin,dt] = near(svg.time,datenum(0,0,0));  % Find time index near date of interest. 

lon_domain = svg.lon(lonw:lone); lat_domain = svg.lat(lats:latn); % Get lons/lats in region.
dep_domain = svg.z(:);
ts_data = squeeze(double(sv.data(tin,:,lats:latn,lonw:lone))); % Get T/S data in region. Dimensions: dep,lat,lon
ts_data = permute(ts_data,[2,3,1]); % Permute array since we'll plot in this order. Dimensions: lon,lat,dep
[lon_mesh,lat_mesh,dep_mesh] = meshgrid(lon_domain,lat_domain,dep_domain);  % Create coordinate mesh from lons/lats/deps.
lon_arr1D = reshape(lon_mesh,[],1); % Reshape in vectors.
lat_arr1D = reshape(lat_mesh,[],1); 
dep_arr1D = reshape(dep_mesh,[],1);
ts_arr1D = reshape(ts_data,[],1);
figure 
scatter3(lon_arr1D,lat_arr1D,dep_arr1D,[],ts_arr1D,'.')
title({sprintf('%s',sv.attribute('long_name'));url;},'interpreter','none');
hcb = colorbar; title(hcb,sv.attribute('units'));
