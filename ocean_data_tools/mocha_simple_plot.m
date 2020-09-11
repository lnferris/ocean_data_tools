
function mocha_simple_plot(month,depth,variable,region)
% mocha_simple_plot plots one depth level of MOCHA Mid-Atlantic Bight climatology
% 
%% Syntax
% 
% mocha_simple_plot(month,depth,variable,region)
%
%% Description 
% 
% mocha_simple_plot(month,depth,variable,region) plots the nearest available
% depth-level to depth. variable specifies the parameter to be plotted and region
% is the rectangular region to be plotted. the calendar month is specified by month.
%
% month is an integer between 1 (January) and 12 (December).
%
% depth is (a single, double, integer) indicates negative meters below the surface.
%
% variable is a string or character array and is the name of the parameter
% to be plotted.
%
% region is a vector containing the bounds [S N W E] of the region to be 
% plotted, -180/180 or 0/360 longtitude format is fine.  Limits may cross 
% the dateline e.g. [35 45 170 -130] but this is a Mid-Atlantic product so 
% there is no reason to try that.
%
%% Example 1
% Plot surface temperature from MOCHA climatology for October:
% 
% month = 10; % Month (1 through 12).
% depth = 0;
% variable = 'temperature'; %  'temperature' 'salinity'
% region = [34 42  -80 -70]; % [30 48 -80 -58]
% mocha_simple_plot(month,depth,variable,region)
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 09-Sep-2020
% 
% See also mocha_build_profiles and mocha_domain_plot.

% deal with inputs other than [-90 90 -180 180] e.g  [-90 90 20 200] 
region(region>180) = region(region>180)- 360;
region(region<-180) = region(region<-180)+360;

url = 'http://tds.marine.rutgers.edu/thredds/dodsC/other/climatology/mocha/MOCHA_v3.nc';
nc = ncgeodataset(url); % Assign a ncgeodataset handle.
disp([ newline 'List of available variables:'])
nc.variables % Print list of available variables. 
sv = nc{variable}; % Assign ncgeovariable handle: 'climatology_bounds' 'temperature' 'salinity' 'time' 'latitude' 'longitude' 'depth'
disp([ newline 'List of variable attributes:'])
sv.attributes % Print ncgeovariable attributes. % Print ncgeovariable attributes.
svg = sv.grid_interop(:,:,:,:); % Get standardized (lat,lon,dep,time) coordinates for the ncgeovariable.

[din,~] = near(svg.z,depth); % Choose index of depth (z-level) to use for 2-D plots; see svg.z for options

% Reshape into vectors and sort
lon = reshape(svg.lon,[],1); 
lat = reshape(svg.lat,[],1);
data = reshape(squeeze(double(sv.data(month,din,:,:))),[],1);

inds = find(lat >= region(1) & lat <= region(2) & lon >= region(3) & lon <= region(4));

hold on

scatter(lon(inds),lat(inds),[],data(inds),'.')
title({url;sprintf('%s   month: %s   depth: %.0fm',sv.attribute('standard_name'),datestr(svg.time(month),'mmm'),svg.z(din))},'interpreter','none');
hcb = colorbar; title(hcb,sv.attribute('units'));

hold off

end
