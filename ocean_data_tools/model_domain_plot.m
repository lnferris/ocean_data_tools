
function model_domain_plot(model_type,source,date,variable,region)
% model_domain_plot plots all depth levels of HYCOM or Operational Mercator
% GLOBAL_ANALYSIS_FORECAST_PHY_001_024
% 
%% Syntax
% 
% model_domain_plot(model_type,source,date,variable,region)
%
%% Description 
% 
% model_domain_plot(model_type,source,date,variable,region) plots all depth 
% levels over a particular rectangular region. variable specifies the parameter 
% to be plotted. model_type ='hycom' or model_type ='mercator' specifies the model used.
% source is the url or local path of the relevant dataset
%
% source (a character array) is the path to either a local netcdf file or an
% OpenDAP url.
%
% date is a date string in format 'dd-mmm-yyyy HH:MM:SS'. 
%
% variable is a string or character array and is the name of the parameter
% to be plotted.
%
% region is a vector containing the bounds [S N W E] of the region to be 
% plotted, -180/180 or 0/360 longtitude format is fine.  Limits may cross 
% the dateline e.g. [35 45 170 -130].
%
%% Example 1
% Plot a salinity domain from HYCOM:
% 
% model_type = 'hycom'; % 'hycom' 'mercator'
% source = 'http://tds.hycom.org/thredds/dodsC/GLBv0.08/expt_57.7'; % url or local .nc 
% date = '28-Aug-2017 00:00:00';   
% region = [-5.0, 45.0 ,160,-150 ];      % [-90 90 -180 180]
% variable = 'salinity'; % 'water_u' 'water_v' 'water_temp' 'salinity' 'velocity' 
% model_domain_plot(model_type,source,date,variable,region)
%
%% Example 2
% Plot a temperature domain from Mercator:
% 
% model_type = 'mercator'; % 'hycom' 'mercator'
% source = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/mercator/global-analysis-forecast-phy-001-024_1593408360353.nc'; % included
% date = '18-Mar-2020 00:00:00';   
% region = [60.0, 70.0 ,-80, -60];      % [-90 90 -180 180]
% variable = 'velocity';  % thetao' 'so' 'uo' 'vo' 'velocity'
% model_domain_plot(model_type,source,date,variable,region)
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 09-Sep-2020
% 
% See also model_build_profiles and model_simple_plot.

assert(isa(date,'char'),'Error: date must be format ''dd-mmm-yyyy HH:MM:SS''');
assert(length(region)==4,'Error: Region must be format [-90 90 -180 180].');
assert(strcmp(model_type,'hycom')| strcmp(model_type,'mercator'),'Error: model_type =''hycom'' or model_type =''mercator''.');

% deal with inputs other than [-90 90 -180 180] e.g  [-90 90 20 200] 
region(region>180) = region(region>180)- 360;
region(region<-180) = region(region<-180)+360;

if strcmp(model_type,'hycom')  
    standard_vars = {'water_u','water_v','water_temp','salinity'}; 
elseif strcmp(model_type,'mercator') 
    standard_vars = {'thetao','so','uo','vo'};    
else
    disp('Check spelling of model.');
    
    return
end

nc = ncgeodataset(source); % Assign a ncgeodataset handle.
disp([ newline 'List of available variables:'])
nc.variables            % Print list of available variables. 

if ~any(strcmp(standard_vars,variable))    
    if strcmp(variable,'velocity') 
        model_domain_plot_velocity(model_type,nc,date,region)
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

% Make Plot

if need2merge == 1
    
    dataA = reshape(permute(squeeze(double(sv.data(tin,:,lats:latn,lonw_A:lone_A))),[2,3,1]),[],1); % permute array to be lon x lat x dep
    [lon_mesh,lat_mesh,dep_mesh] = meshgrid(svg.lon(lonw_A:lone_A),svg.lat(lats:latn),svg.z(:)); 
    lon = reshape(lon_mesh,[],1); 
    lat = reshape(lat_mesh,[],1); 
    z = reshape(dep_mesh,[],1);
    scatter3(lon,lat,z,[],dataA,'.')
    
    hold on 
    dataB = reshape(permute(squeeze(double(sv.data(tin,:,lats:latn,lonw_B:lone_B))),[2,3,1]),[],1); % permute array to be lon x lat x dep
    [lon_mesh,lat_mesh,dep_mesh] = meshgrid(svg.lon(lonw_B:lone_B)+360,svg.lat(lats:latn),svg.z(:)); 
    lon = reshape(lon_mesh,[],1); 
    lat = reshape(lat_mesh,[],1); 
    z = reshape(dep_mesh,[],1);
    scatter3(lon,lat,z,[],dataB,'.')

else   
    
    data = reshape(permute(squeeze(double(sv.data(tin,:,lats:latn,lonw:lone))),[2,3,1]),[],1); % permute array to be lon x lat x dep
    [lon_mesh,lat_mesh,dep_mesh] = meshgrid(svg.lon(lonw:lone),svg.lat(lats:latn),svg.z(:)); 
    lon = reshape(lon_mesh,[],1); 
    lat = reshape(lat_mesh,[],1); 
    z = reshape(dep_mesh,[],1);
    scatter3(lon,lat,z,[],data,'.')

end    

title({sprintf('%s',sv.attribute('standard_name'));datestr(svg.time(tin))},'interpreter','none');
hcb = colorbar; title(hcb,sv.attribute('units'),'interpreter','none');

end
