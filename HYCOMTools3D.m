
%%                  INFORMATION

%  Author: Lauren Newell Ferris
%  Institute: Virginia Institute of Marine Science
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Dec 2018; Last revision: 3-Dec-2018
%  Distributed under the terms of the MIT License
%  Dependencies: nctoolbox.github.io/nctoolbox/
%  Remember to run the command "setup_nctoolbox".

%%                 1. Load the Data

url = 'http://tds.hycom.org/thredds/dodsC/GLBv0.08/expt_57.7'; % url could also be a local file e.g. '/Users/lnferris/expt_57.7.nc'
nc = ncgeodataset(url); % Assign a ncgeodataset handle.
nc.variables % Print list of available variables. 
sv = nc{'water_temp'}; % Assign ncgeovariable handle: 'water_u' 'water_v' 'water_temp' 'salinity'
sv.attributes % Print ncgeovariable attributes.
svg = sv.grid_interop(:,:,:,:); % Get standardized (time,z,lat,lon) coordinates for the ncgeovariable.
datestr(sv.timeextent(),29) % Print date range of the ncgeovariable.

%%                2. Choose Region and Date

[lats,ds] = near(svg.lat,30.0); % Find lat index near southern boundary [-90 90] of region.
[latn,dn] = near(svg.lat,45.0);
[lonw,dw] = near(svg.lon,-15.0);% Find lon index near western boundary [-180 180] of region.
[lone,de] = near(svg.lon,10.0);
[tin,dt] = near(svg.time,datenum(2017,08,28));  % Find time index near date of interest. 

%%                3a. Plot full column (3-D) of temperature or salinity

lon_domain = svg.lon(lonw:lone); lat_domain = svg.lat(lats:latn); % Get lons/lats in region.
dep_domain = svg.z(:);
ts_data = squeeze(double(sv.data(tin,:,lats:latn,lonw:lone))); % Get T/S data in region. Dimensions: dep,lat,lon
ts_data = permute(ts_data,[2,3,1]); % Permute array since we'll plot in this order. Dimensions: lon,lat,dep

[lon_mesh,lat_mesh,dep_mesh] = meshgrid(lon_domain,lat_domain,dep_domain);  % Create coordinate mesh from lons/lats/deps.
lon_arr1D = reshape(lon_mesh,[],1); % Reshape in vectors.
lat_arr1D = reshape(lat_mesh,[],1); 
dep_arr1D = reshape(dep_mesh,[],1);
ts_arr1D = reshape(ts_data,[],1);

figure % Plot the T/S data.
scatter3(lon_arr1D,lat_arr1D,dep_arr1D,[],ts_arr1D,'.')
title({sprintf('%s',sv.attribute('standard_name'));url;datestr(svg.time(tin))},'interpreter','none');
hcb = colorbar; title(hcb,sv.attribute('units'));

%%                3b. Plot full column (3-D) of velocity magnitude sqrt(u^2+v^2)

sv_u = nc{'water_u'}; sv_v = nc{'water_v'}; % Assign ncgeovariable handles for water_u, water_v.
svg_u = sv_u.grid_interop(:,:,:,:);  % Get standardized (time,z,lat,lon) coordinates based on water_u.

lon_domain = svg_u.lon(lonw:lone); lat_domain = svg_u.lat(lats:latn); % Get lons/lats in region.
dep_domain = svg_u.z(:);
u_data = squeeze(double(sv_u.data(tin,:,lats:latn,lonw:lone))); % Get u velocity data in region. Dimensions: dep,lat,lon
u_data = permute(u_data,[2,3,1]); % Permute array since we'll plot in this order. Dimensions: lon,lat,dep
v_data = squeeze(double(sv_v.data(tin,:,lats:latn,lonw:lone)));
v_data = permute(v_data,[2,3,1]);

velocim_data = sqrt(u_data.^2+v_data.^2);

[lon_mesh,lat_mesh,dep_mesh] = meshgrid(lon_domain,lat_domain,dep_domain);  % Create coordinate mesh from lons/lats/deps.
lon_arr1D = reshape(lon_mesh,[],1); % Reshape in vectors.
lat_arr1D = reshape(lat_mesh,[],1); 
dep_arr1D = reshape(dep_mesh,[],1);
u_arr1D = reshape(u_data,[],1);
v_arr1D = reshape(v_data,[],1);
velocim_arr1D = reshape(velocim_data,[],1);

figure % Plot the velocity data.
scatter3(lon_arr1D,lat_arr1D,dep_arr1D,[],velocim_arr1D,'.')
title({'velocity magnitude';url;datestr(svg.time(tin))},'interpreter','none');
hcb = colorbar; title(hcb,sv_u.attribute('units'));

%hold on % Add directional arrows. (Slow to view; not recommended.)
%quiver3(lon_arr1D,lat_arr1D,dep_arr1D,u_arr1D,v_arr1D,u_arr1D.*0,'w') %quiver3(x,y,z,u,v,w)

%%                4a. Crudely interpolate and slice temperature or salinity data

ts_interp = interp3(lon_domain,lat_domain,dep_domain,ts_data,lon_mesh,lat_mesh,dep_mesh);

figure
xslice = lon_mesh(1):1:lon_mesh(end); % Lon locations to slice.
yslice = lat_mesh(1):1:lat_mesh(end); % Lat locations to slice.
slice(lon_mesh,lat_mesh,dep_mesh,ts_interp,xslice,yslice,[]); %slice(x,y,z,v,xslice,yslice,zslice)
shading flat
title({sprintf('%s (interpolated)',sv.attribute('standard_name'));url;datestr(svg.time(tin))},'interpreter','none');
hcb = colorbar; title(hcb,sv.attribute('units'));

%%                4b. Crudely interpolate and slice velocity data

velocim_interp = interp3(lon_domain,lat_domain,dep_domain,velocim_data,lon_mesh,lat_mesh,dep_mesh);

figure
xslice = lon_mesh(1):1:lon_mesh(end); % Lon locations to slice.
yslice = lat_mesh(1):1:lat_mesh(end); % Lat locations to slice.
slice(lon_mesh,lat_mesh,dep_mesh,velocim_interp,xslice,yslice,[]); %slice(x,y,z,v,xslice,yslice,zslice)
shading flat
title({'velocity magnitude (interpolated)';url;datestr(svg_u.time(tin))},'interpreter','none');
hcb = colorbar; title(hcb,sv_u.attribute('units'));
