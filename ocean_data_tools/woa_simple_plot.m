
function [data,lat,lon] = woa_simple_plot(variable,time,region,depth)
% woa_simple_plot plots one depth level of World Ocean Atlas 2018 Statistical Mean 
% for All Decades, Objectively Analyzed Mean Fields at Standard Depth Levels
% 
%% Syntax
% 
% [data,lat,lon] = woa_simple_plot(variable,time,region,depth)
%
%% Description 
% 
% [data,lat,lon] = woa_simple_plot(variable,time,region,depth) plots 
% the nearest available depth-level to depth. variable specifies the parameter 
% to be plotted and region is the rectangular region to be plotted. time
% specifies monthly or annual climatology; time = '00' for annual climatology 
% and '01' '10' etc. for monthly climatology. The function builds the url,
% extracting the maximum resolution available (typically 0.25-deg or
% 1.00-degree grid). data, lat, and lon from the plotted layer
% are available outputs. Units and url codes of each variable are:
%
% 'temperature' (degrees Celsius)           't'
% 'salinity' (psu)                          's'
% 'oxygen' (umol/kg)                        'o'
% 'o2sat' (%)                               'O'
% 'AOU' (umol/kg)                           'A'
% 'silicate' (umol/kg)                      'i'
% 'phosphate' (umol/kg)                     'p'
% 'nitrate' (umol/kg)                       'n'
%
%% Example 1
% Plot surface nitrate from March climatology:
% 
% variable = 'nitrate'; % 'temperature' 'salinity' 'oxygen' 'o2sat' 'AOU' 'silicate' 'phosphate' 'nitrate'
% time = '03'; % '00' for annual climatology '01' '10' etc. for monthly climatology
% region = [-5.0, 45.0 ,-120, -150]; 
% depth = -0; % meters -0 to -5500
% woa_simple_plot(variable,time,region,depth)
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 09-Sep-2020
% 
% See also woa_build_profiles and woa_domain_plot.


% deal with inputs other than [-90 90 -180 180] e.g  [-90 90 20 200] 
region(region>180) = region(region>180)- 360;
region(region<-180) = region(region<-180)+360;

fine_vars = {'temperature','salinity'};
coarse_vars = {'oxygen','o2sat','AOU','silicate','phosphate','nitrate'};

if any(strcmp(fine_vars,variable)) 
    mod = '/decav/0.25/woa18_decav_'; 
    grid = '04';  
elseif any(strcmp(coarse_vars,variable))  
    mod = '/all/1.00/woa18_all_'; 
    grid = '01'; 
else
    disp('Check spelling of variable.');    
end

[~, tf] = ismember([fine_vars, coarse_vars],variable);
var_codes = {'t','s','o','O','A','i','p','n'};
var = var_codes{tf==1};

path = [variable,mod,var,time,'_',grid,'.nc'];
url = ['https://data.nodc.noaa.gov/thredds/dodsC/ncei/woa/',path];
nc = ncgeodataset(url); % Assign a ncgeodataset handle.
nc.variables % Print list of available variables.
sv = nc{[var,'_an']}; % Assign ncgeovariable handle. 
sv.attributes % Print ncgeovariable attributes.
svg = sv.grid_interop(:,:,:,:); % Get standardized (time,z,lat,lon) coordinates for the ncgeovariable.

% Find Indices

[din,~] = near(svg.z,depth); % Choose index of depth (z-level) to use for 2-D plots; see svg.z for options.
[lats,~] = near(svg.lat,region(1)); % Find lat index near southern boundary [-90 90] of region.
[latn,~] = near(svg.lat,region(2));
[lonw] = near(svg.lon,region(3));% Find lon indexes in standard manner.
[lone] = near(svg.lon,region(4));   
if lonw == lone
    lone = lone-1;
end

need2merge = 0;
if lonw > lone
    need2merge = 1;
    [lonw_A] = near(svg.lon,region(3));% Find lon indexes of lefthand chunk.
    [lone_A] = near(svg.lon,180);
    [lonw_B] = near(svg.lon,-180);% Find lon indexes of righthand chunk.
    [lone_B] = near(svg.lon,region(4));    
end

% Format and merge data

if need2merge == 1
    data = cat(2,squeeze(double(sv.data(1,din,lats:latn,lonw_B:lone_B))),squeeze(double(sv.data(1,din,lats:latn,lonw_A:lone_A))));
    lon = [svg.lon(lonw_B:lone_B)+360; svg.lon(lonw_A:lone_A)];
else   
    data = squeeze(double(sv.data(1,din,lats:latn,lonw:lone)));
    lon = svg.lon(lonw:lone);
end
lat = svg.lat(lats:latn);
[lon,lon_inds] = sort(lon);
data = data(:,lon_inds);

% Plot

pcolor(lon,lat,data); 
shading flat
title({sprintf('%s %.0fm',sv.attribute('standard_name'),svg.z(din));path},'interpreter','none');
hcb = colorbar; title(hcb,sv.attribute('units'),'interpreter','none');

end
