%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 25-Jun-2020
%  Distributed under the terms of the MIT License
%  Dependencies: nctoolbox

function mocha_simple_plot(month,depth,variable,region)

url = 'http://tds.marine.rutgers.edu/thredds/dodsC/other/climatology/mocha/MOCHA_v3.nc';
nc = ncgeodataset(url); % Assign a ncgeodataset handle.
nc.variables % Print list of available variables. 
sv = nc{variable}; % Assign ncgeovariable handle: 'climatology_bounds' 'temperature' 'salinity' 'time' 'latitude' 'longitude' 'depth'
sv.attributes % Print ncgeovariable attributes. % Print ncgeovariable attributes.
svg = sv.grid_interop(:,:,:,:); % Get standardized (lat,lon,dep,time) coordinates for the ncgeovariable.

[din,~] = near(svg.z,depth); % Choose index of depth (z-level) to use for 2-D plots; see svg.z for options

% Reshape into vectors and sort
lon = reshape(svg.lon,[],1); 
lat = reshape(svg.lat,[],1);
data = reshape(squeeze(double(sv.data(month,din,:,:))),[],1);

inds = find(lat >= region(1) & lat <= region(2) & lon >= region(3) & lon <= region(4));

figure 
scatter(lon(inds),lat(inds),[],data(inds),'.')
title({url;sprintf('%s   month: %s   depth: %.0fm',sv.attribute('standard_name'),datestr(svg.time(month),'mmm'),svg.z(din))},'interpreter','none');
hcb = colorbar; title(hcb,sv.attribute('units'));

end