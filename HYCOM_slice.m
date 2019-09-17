%%                  INFORMATION

%  Author: Lauren Newell Ferris
%  Institute: Virginia Institute of Marine Science
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Dec 2018; Last revision: 9-Dec-2018
%  Distributed under the terms of the MIT License
%  Dependencies: nctoolbox.github.io/nctoolbox/, SSsection() optional
%  Remember to run the command "setup_nctoolbox".
%  The user inputs are on lines 16 (url), 19 (T or S), 26-30 (region/date),
%  42-44 (transect), 68 (decide to plot against lat or lon).

%%                 1. Load the Data

url = 'http://tds.hycom.org/thredds/dodsC/GLBv0.08/expt_57.7'; % url could also be a local file e.g. '/Users/lnferris/expt_57.7.nc'
nc = ncgeodataset(url); % Assign a ncgeodataset handle.
nc.variables % Print list of available variables. 
sv = nc{'water_temp'}; % Assign ncgeovariable handle: 'water_u' 'water_v' 'water_temp' 'salinity'
sv.attributes % Print ncgeovariable attributes.
svg = sv.grid_interop(:,:,:,:); % Get standardized (time,z,lat,lon) coordinates for the ncgeovariable.
datestr(sv.timeextent(),29) % Print date range of the ncgeovariable.

%%                2. Choose Region and Date

[lats,ds] = near(svg.lat,60.0); % Find lat index near southern boundary [-90 90] of region.
[latn,dn] = near(svg.lat,80.0);
[lonw,dw] = near(svg.lon,-35.0);% Find lon index near western boundary [-180 180] of region.
[lone,de] = near(svg.lon,0.0);
[tin,dt] = near(svg.time,datenum(2017,08,28));  % Find time index near date of interest. 
din = 1; % Choose index of depth (z-level) to use for 2-D plots.

%%                3. Plot one depth level (2-D) of temperature or salinity

figure % Plot the depth level. 
pcolorjw(svg.lon(lonw:lone),svg.lat(lats:latn),double(sv.data(tin,din,lats:latn,lonw:lone))); % pcolorjw(x,y,c(time,depth,lat,lon))
title({sprintf('%s %.0fm',sv.attribute('standard_name'),svg.z(din));url;datestr(svg.time(tin))},'interpreter','none');
hcb = colorbar; title(hcb,sv.attribute('units'));

%%                4. Create a virtual transect.

start_t = [-15 79] ; % Starting point of transect. [lon lat]
stop_t = [-3 62] ; % Ending point.
width = 1/12; % of a lat/lon degree
poly_x = [start_t(1)+width/2 start_t(1)-width/2 stop_t(1)-width/2 stop_t(1)+width/2 start_t(1)+width/2];
poly_y = [start_t(2)+width/2 start_t(2)-width/2 stop_t(2)-width/2 stop_t(2)+width/2 start_t(2)+width/2];

lon_domain = svg.lon(lonw:lone); 
lat_domain = svg.lat(lats:latn); % Get lons/lats in region.
dep_domain = svg.z(:);
data = squeeze(double(sv.data(tin,:,lats:latn,lonw:lone))); % Get T/S data in region. Dimensions: dep,lat,lon
data = permute(data,[2,3,1]); % Permute array since we'll plot in this order. Dimensions: lon,lat,dep

[lon_mesh,lat_mesh,dep_mesh] = meshgrid(lon_domain,lat_domain,dep_domain);  % Create coordinate mesh from lons/lats/deps.
lon_arr1D = reshape(lon_mesh,[],1); 
lat_arr1D = reshape(lat_mesh,[],1); 
dep_arr1D = reshape(dep_mesh,[],1);
data_arr1D = reshape(data,[],1); % Reshape in vectors.

in = inpolygon(lon_arr1D,lat_arr1D,poly_x,poly_y); % Get indices of data in polygon.

hold on
plot(poly_x,poly_y,'LineWidth',1) % % Plot polygon
plot(lon_arr1D(in),lat_arr1D(in),'r+') % Plot points inside polygon

%%                5. Make vertical section plot for transect
figure
scatter(lat_arr1D(in),dep_arr1D(in),[],data_arr1D(in)) % Decide whether plotting against lon or lat makes more sense...
hold on
SSsection('/Users/lnferris/Desktop/topo_18.1.img',[60.0 80.0 -35.0 0.0],start_t,stop_t,'lat') % Add bathymetry (optional).

%%                6. Plot (3-D) virtual transect though domain (3-D)

figure % Plot the T/S data.
scatter3(lon_arr1D,lat_arr1D,dep_arr1D,[],data_arr1D,'.')
title({sprintf('%s',sv.attribute('standard_name'));url;datestr(svg.time(tin))},'interpreter','none');
hcb = colorbar; title(hcb,sv.attribute('units'));
hold on
plot(poly_x,poly_y,'LineWidth',1) % % plot polygon
plot(lon_arr1D(in),lat_arr1D(in),'r+') % points inside polygon
