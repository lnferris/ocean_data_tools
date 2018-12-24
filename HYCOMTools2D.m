%%                  INFORMATION

%  Author: Lauren Newell Ferris
%  Institute: Virginia Institute of Marine Science
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Dec 2018; Last revision: 2-Dec-2018
%  Distributed under the terms of the MIT License
%  Dependencies: nctoolbox.github.io/nctoolbox/
%  Remember to run the command "setup_nctoolbox".

%%                 1. Load the Data

url = 'http://tds.hycom.org/thredds/dodsC/GLBv0.08/expt_57.7';
nc = ncgeodataset(url); % Assign a ncgeodataset handle.
nc.variables % Print list of available variables. 
sv = nc{'water_temp'}; % Assign ncgeovariable handle: 'water_u' 'water_v' 'water_temp' 'salinity'
sv.attributes % Print ncgeovariable attributes.
svg = sv.grid_interop(:,:,:,:); % Get standardized (time,z,lat,lon) coordinates for the ncgeovariable.
datestr(sv.timeextent(),29) % Print date range of the ncgeovariable.

%%                2. Choose Region and Date

[lats,ds] = near(svg.lat,5.0); % Find lat index near southern boundary [-90 90] of region.
[latn,dn] = near(svg.lat,30.0);
[lonw,dw] = near(svg.lon,-100.0);% Find lon index near western boundary [-180 180] of region.
[lone,de] = near(svg.lon,-75.0);
[tin,dt] = near(svg.time,datenum(2017,08,28));  % Find time index near date of interest. 
din = 1; % Choose index of depth (z-level) to use for 2-D plots.

%%                3a. Plot of one depth level (2-D) of temperature or salinity

figure % Plot the depth level. 
pcolorjw(svg.lon(lonw:lone),svg.lat(lats:latn),double(sv.data(tin,din,lats:latn,lonw:lone))); % pcolorjw(x,y,c(time,depth,lat,lon))
title({sprintf('%s %.0fm',sv.attribute('standard_name'),svg.z(din));url;datestr(svg.time(tin))},'interpreter','none');
hcb = colorbar; title(hcb,sv.attribute('units'));

%%                3b. Plot one depth level (2-D) of velocity magnitude sqrt(u^2+v^2)

sv_u = nc{'water_u'}; sv_v = nc{'water_v'}; % Assign ncgeovariable handles for water_u, water_v.
svg_u = sv_u.grid_interop(:,:,:,:);  % Get standardized (time,z,lat,lon) coordinates based on water_u.
velocim = sqrt(double(sv_u.data(tin,din,lats:latn,lonw:lone)).^2+double(sv_v.data(tin,din,lats:latn,lonw:lone)).^2);

figure % Plot one depth level.
pcolorjw(svg_u.lon(lonw:lone),svg_u.lat(lats:latn),velocim); % pcolorjw(x,y,c)
title({sprintf('velocity magnitude %.0fm',svg_u.z(din));url;datestr(svg.time(tin))},'interpreter','none');
hcb = colorbar; title(hcb,sv_u.attribute('units'));

u = squeeze(double(sv_u.data(tin,din,lats:latn,lonw:lone))); % Add directional arrows.
v = squeeze(double(sv_v.data(tin,din,lats:latn,lonw:lone)));
hold on
quiver(svg_u.lon(lonw:lone),svg_u.lat(lats:latn),u,v,'w'); % quiver(x,y,u,v)

%%                3c. Plot sea surface elevation (2-D)

sv_el = nc{'surf_el'}; % Assign ncgeovariable handles for surf_el.  
sv_el.attributes
svg_el = sv_el.grid_interop(:,:,:,:);  % Get standardized (time,lat,lon) coordinates based on surf_el.

lon_domain = svg_el.lon(lonw:lone); lat_domain = svg_el.lat(lats:latn); % Get lons/lats in region.
el_data = squeeze(double(sv_el.data(tin,lats:latn,lonw:lone))); % Get elevation data in region.
[lon_mesh,lat_mesh] = meshgrid(lon_domain,lat_domain); % Create coordinate mesh from lons/lats.
lon_arr1D = reshape(lon_mesh,[],1); lat_arr1D = reshape(lat_mesh,[],1); el_arr1D = reshape(el_data,[],1); % Reshape in vectors.

figure % Plot the elevation data.
scatter(lon_arr1D,lat_arr1D,[],el_arr1D,'.')
title({sprintf('%s' ,sv_el.attribute('standard_name'));url;datestr(svg_el.time(tin))},'interpreter','none');
hcb = colorbar; title(hcb,sv_el.attribute('units'));
