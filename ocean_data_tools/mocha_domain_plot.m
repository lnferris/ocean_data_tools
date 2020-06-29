
%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 28-Jun-2020
%  Distributed under the terms of the MIT License
%  Dependencies: nctoolbox

function mocha_domain_plot(month,variable,region)

url = 'http://tds.marine.rutgers.edu/thredds/dodsC/other/climatology/mocha/MOCHA_v3.nc';
nc = ncgeodataset(url); % Assign a ncgeodataset handle.
nc.variables % Print list of available variables. 
sv = nc{variable}; % Assign ncgeovariable handle: 'climatology_bounds' 'temperature' 'salinity' 'time' 'latitude' 'longitude' 'depth'
sv.attributes % Print ncgeovariable attributes. % Print ncgeovariable attributes.
svg = sv.grid_interop(:,:,:,:); % Get standardized (lat,lon,dep,time) coordinates for the ncgeovariable.

% Reshape into vectors and sort
lon = reshape(svg.lon,[],1); 
lat = reshape(svg.lat,[],1);

inds = find(lat >= region(1) & lat <= region(2) & lon >= region(3) & lon <= region(4));

figure 
hold on

for zind = 1:length(svg.z)
    
data = reshape(squeeze(double(sv.data(month,zind,:,:))),[],1);

scatter3(lon(inds),lat(inds),svg.z(zind).*ones(length(data(inds)),1),[],data(inds),'.')
title({url;sprintf('%s   month: %s',sv.attribute('standard_name'),datestr(svg.time(month),'mmm'))},'interpreter','none');
hcb = colorbar; title(hcb,sv.attribute('units'));

end    

end