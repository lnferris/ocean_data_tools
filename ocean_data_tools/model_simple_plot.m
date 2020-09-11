
function [data,lat,lon] = model_simple_plot(model_type,source,date,variable,region,depth,arrows)
% model_simple_plot plots one depth level of HYCOM or Operational Mercator
% GLOBAL_ANALYSIS_FORECAST_PHY_001_024
% 
%% Syntax
% 
% [data,lat,lon] = model_simple_plot(model_type,source,date,variable,region,depth)
% [data,lat,lon] = model_simple_plot(model_type,source,date,variable,region,depth,arrows)
%
%% Description 
% 
% [data,lat,lon] = model_simple_plot(model_type,source,date,variable,region,depth) plots 
% the nearest available depth-level of HYCOM or Operational Mercator
% GLOBAL_ANALYSIS_FORECAST_PHY_001_024. variable specifies the parameter 
% to be plotted and region is the rectangular region to be plotted. model_type ='hycom' or
% model_type ='mercator' specifies the model used. source is the url or local
% path of the relevant dataset. data, lat, and lon from the plotted layer
% are available outputs.
%
% [data,lat,lon] =
% model_simple_plot(model_type,source,date,variable,region,depth,arrows) adds
% directional arrows if it is a velocity magnitude plot. arrows=1 is on,
% arrows=0 is off.
%
% source (a character array) is the path to either a local netcdf file or an
% OpenDAP url.
%
% date is a date string in format 'dd-mmm-yyyy HH:MM:SS'. 
%
% variable is a string or character array and is the name of the parameter
% to be plotted.
%
% depth is (a single, double, integer) indicates negative meters below the surface.
%
% region is a vector containing the bounds [S N W E] of the region to be 
% plotted, -180/180 or 0/360 longtitude format is fine.  Limits may cross 
% the dateline e.g. [35 45 170 -130].
%
% data, lon, and lat are double arrays containing the plotted data layer.
% As such, this function can be used to extract data layers from HYCOM or 
% Operational Mercator GLOBAL_ANALYSIS_FORECAST_PHY_001_024.
%
%% Example 1
% Plot surface velocity from HYCOM:
% 
% model_type = 'hycom'; % 'hycom' 'mercator'
% source = 'http://tds.hycom.org/thredds/dodsC/GLBv0.08/expt_57.7'; % url or local .nc 
% date = '28-Aug-2017 00:00:00';  
% variable = 'velocity';                 % 'water_u' 'water_v' 'water_temp' 'salinity' 'velocity' 'surf_el' 'water_u_bottom' 'water_v_bottom' 'water_temp_bottom' 'salinity_bottom' 
% region = [-5.0, 45.0 ,160,-150 ];      % [-90 90 -180 180]
% depth = -150;                          % Depth level between 0 and -5000m
% arrows = 0;                            % Velocity direction arrows 1=on 0=off
% [data,lat,lon] = model_simple_plot(model_type,source,date,variable,region,depth,arrows); % optionally output the plotted data layer
%
%% Example 2
% Plot temperature at ~150m depth from Mercator:
% 
% model_type = 'mercator'; % 'hycom' 'mercator'
% source = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/mercator/global-analysis-forecast-phy-001-024_1593408360353.nc'; % included
% date = '18-Mar-2020 00:00:00';   
% variable = 'thetao'; % 'thetao' 'so' 'uo' 'vo' 'velocity' 'mlotst' 'siconc' 'usi' 'vsi' 'sithick' 'bottomT' 'zos'
% region = [60.0, 70.0 ,-80, -60];      % [-90 90 -180 180]
% depth = -150;                          % Depth level between 0 and -5728m 
% model_simple_plot(model_type,source,date,variable,region,depth)
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 09-Sep-2020
% 
% See also model_build_profiles and model_domain_plot.

if nargin < 7
    arrows = 0;
end

if strcmp(model_type,'hycom')  
    standard_vars = {'water_u','water_v','water_temp','salinity'};
    slab_vars = {'water_u_bottom','water_v_bottom','water_temp_bottom','salinity_bottom','surf_el'};    
elseif strcmp(model_type,'mercator')  
    standard_vars = {'thetao','so','uo','vo'};
    slab_vars = {'mlotst','siconc','usi','vsi','sithick','bottomT','zos'};          
else
    disp('Check spelling of model.');   
    return
end

% deal with inputs other than [-90 90 -180 180] e.g  [-90 90 20 200] 
region(region>180) = region(region>180)- 360;
region(region<-180) = region(region<-180)+360;

nc = ncgeodataset(source); % Assign a ncgeodataset handle.
disp([ newline 'List of available variables:'])
nc.variables            % Print list of available variables. 

if ~any(strcmp(standard_vars,variable))   
    if any(strcmp(slab_vars,variable))
        [data,lat,lon] = model_simple_plot_layer(nc,date,variable,region);
        return
        
    elseif strcmp(variable,'velocity') 
        [data,lat,lon] = model_simple_plot_velocity(model_type,nc,date,region,depth,arrows);
        return   
    else    
        disp('Check spelling of variable variable');    
    end
    
end

sv = nc{variable}; % Assign ncgeovariable handle: 'water_u' 'water_v' 'water_temp' 'salinity'
disp([ newline 'List of variable attributes:'])
sv.attributes % Print ncgeovariable attributes.
disp([ newline 'Available date range:'])
datestr(sv.timeextent(),29) % Print date range of the ncgeovariable.
svg = sv.grid_interop(:,:,:,:); % Get standardized (time,z,lat,lon) coordinates for the ncgeovariable.

% Prepare to handle 0/360 model data

model360 = all(svg.lon>=0); 
if model360
    if region(3) < 0
        region(3) = region(3) +360;
    end
    if region(4) < 0
        region(4) = region(4) +360;
    end
end

% Find Indices

[tin,~] = near(svg.time,datenum(date,'dd-mmm-yyyy HH:MM:SS'));  % Find time index near date of interest. 
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
    if ~model360
        [lonw_A] = near(svg.lon,region(3));% Find lon indexes of lefthand chunk.
        [lone_A] = near(svg.lon,180);
        [lonw_B] = near(svg.lon,-180);% Find lon indexes of righthand chunk.
        [lone_B] = near(svg.lon,region(4)); 
    elseif model360   
        [lonw_A] = near(svg.lon,region(3));% Find lon indexes of lefthand chunk.
        [lone_A] = near(svg.lon,360);
        [lonw_B] = near(svg.lon,0);% Find lon indexes of righthand chunk.
        [lone_B] = near(svg.lon,region(4)); 
    end
end

% Format and merge data

if need2merge == 1
    data = cat(2,squeeze(double(sv.data(tin,din,lats:latn,lonw_B:lone_B))),squeeze(double(sv.data(tin,din,lats:latn,lonw_A:lone_A))));
    lon = [svg.lon(lonw_B:lone_B)+360; svg.lon(lonw_A:lone_A)];
else   
    data = squeeze(double(sv.data(tin,din,lats:latn,lonw:lone)));
    lon = svg.lon(lonw:lone);
end
lat = svg.lat(lats:latn);
[lon,lon_inds] = sort(lon);
data = data(:,lon_inds);

% Plot

pcolor(lon,lat,data); 
shading flat
title({sprintf('%s %.0fm',sv.attribute('standard_name'),svg.z(din));datestr(svg.time(tin))},'interpreter','none');
hcb = colorbar; title(hcb,sv.attribute('units')); 

end
