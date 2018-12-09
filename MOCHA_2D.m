%%                  INFORMATION


%  Author: Lauren Newell Ferris
%  Institute: Virginia Institute of Marine Science
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Dec 2018; Last revision: 7-Dec-2018
%  Distributed under the terms of the MIT License
%  Dependencies: nctoolbox.github.io/nctoolbox/
%  Remember to run the command "setup_nctoolbox".
%  The user inputs are on lines 19 (choose variable), 25 (choose month), and 27 (choose depth).

%%                 1. Load the Data

url = 'http://tds.marine.rutgers.edu/thredds/dodsC/other/climatology/mocha/MOCHA_v3.nc';
nc = ncgeodataset(url); % Assign a ncgeodataset handle.
nc.variables % Print list of available variables. 
sv = nc{'temperature'}; % Assign ncgeovariable handle: 'climatology_bounds' 'temperature' 'salinity' 'time' 'latitude' 'longitude' 'depth'
sv.attributes % Print ncgeovariable attributes. % Print ncgeovariable attributes.
svg = sv.grid_interop(:,:,:,:); % Get standardized (lat,lon,dep,time) coordinates for the ncgeovariable.

%%                2. Choose Month and Depth (to use for 2-D plot)

month = 10; % Choose month [1 12].
depth_options = svg.z; % Create a vector to inspect which INDEX corresponds to which depth.
depth = 1; % Choose a depth INDEX.
lat_mesh = svg.lat;
lon_mesh = svg.lon;
data = squeeze(double(sv.data(month,depth,:,:))); % sv.data(month,depth,lat,lon)

%%                3. Plot of one depth level (2-D) of temperature or salinity

lon_mesh = reshape(lon_mesh,[],1); % Reshape into vectors.
lat_mesh = reshape(lat_mesh,[],1);
data = reshape(data,[],1); 
figure % Plot the temerpature or salinity data.
scatter(lon_mesh,lat_mesh,[],data,'.')
title({url;sprintf('%s   month: %s   depth: %.0fm',sv.attribute('standard_name'),datestr(svg.time(month),'mmm'),svg.z(depth))},'interpreter','none');
hcb = colorbar; title(hcb,sv.attribute('units'));
