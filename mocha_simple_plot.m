%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 15-Jun-2020
%  Distributed under the terms of the MIT License
%  Dependencies: nctoolbox

function mocha_simple_plot(month,depth,variable)

url = 'http://tds.marine.rutgers.edu/thredds/dodsC/other/climatology/mocha/MOCHA_v3.nc';
nc = ncgeodataset(url); % Assign a ncgeodataset handle.
nc.variables % Print list of available variables. 
sv = nc{variable}; % Assign ncgeovariable handle: 'climatology_bounds' 'temperature' 'salinity' 'time' 'latitude' 'longitude' 'depth'
sv.attributes % Print ncgeovariable attributes. % Print ncgeovariable attributes.
svg = sv.grid_interop(:,:,:,:); % Get standardized (lat,lon,dep,time) coordinates for the ncgeovariable.

[din,dz] = near(svg.z,depth); % Choose index of depth (z-level) to use for 2-D plots; see svg.z for options
lat_mesh = svg.lat;
lon_mesh = svg.lon;
data = squeeze(double(sv.data(month,din,:,:))); % sv.data(month,depth,lat,lon)

%Plot of one depth level (2-D) of temperature or salinity

lon_mesh = reshape(lon_mesh,[],1); % Reshape into vectors.
lat_mesh = reshape(lat_mesh,[],1);
data = reshape(data,[],1); 
figure % Plot the temperature or salinity data.
scatter(lon_mesh,lat_mesh,[],data,'.')
title({url;sprintf('%s   month: %s   depth: %.0fm',sv.attribute('standard_name'),datestr(svg.time(month),'mmm'),svg.z(din))},'interpreter','none');
hcb = colorbar; title(hcb,sv.attribute('units'));
end