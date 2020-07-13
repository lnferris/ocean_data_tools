%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 22-Jun-2020
%  Distributed under the terms of the MIT License
%  Dependencies: nctoolbox

% 'temperature' (degrees Celsius)           't'
% 'salinity' (psu)                          's'
% 'oxygen' (umol/kg)              'o'
% 'o2sat' (%)           'O'
% 'AOU' (umol/kg)   'A'
% 'silicate' (umol/kg)                      'i'
% 'phosphate' (umol/kg)                     'p'
% 'nitrate' (umol/kg)                       'n'

function woa_domain_plot(variable,time,region)

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

[lats,~] = near(svg.lat,region(1)); % Find lat index near southern boundary [-90 90] of region.
[latn,~] = near(svg.lat,region(2));

if region(3) > region(4) && region(4) < 0 % If data spans the dateline...
    [lonw_A] = near(svg.lon,region(3));% Find lon indexes of lefthand chunk.
    [lone_A] = near(svg.lon,180);
    [lonw_B] = near(svg.lon,-180);% Find lon indexes of righthand chunk.
    [lone_B] = near(svg.lon,region(4)); 
else
    [lonw] = near(svg.lon,region(3));% Find lon indexes in standard manner.
    [lone] = near(svg.lon,region(4));   
end

% Make Plot

figure 
    
if region(3) > region(4) && region(4) < 0 % If data spans the dateline...
    
    dataA = reshape(permute(squeeze(double(sv.data(1,:,lats:latn,lonw_A:lone_A))),[2,3,1]),[],1); % permute array to be lon x lat x dep
    [lon_mesh,lat_mesh,dep_mesh] = meshgrid(svg.lon(lonw_A:lone_A),svg.lat(lats:latn),svg.z(:)); 
    lon = reshape(lon_mesh,[],1); 
    lat = reshape(lat_mesh,[],1); 
    z = reshape(dep_mesh,[],1);
    scatter3(lon,lat,z,[],dataA,'.')
    
    hold on 
    dataB = reshape(permute(squeeze(double(sv.data(1,:,lats:latn,lonw_B:lone_B))),[2,3,1]),[],1); % permute array to be lon x lat x dep
    [lon_mesh,lat_mesh,dep_mesh] = meshgrid(svg.lon(lonw_B:lone_B)+360,svg.lat(lats:latn),svg.z(:)); 
    lon = reshape(lon_mesh,[],1); 
    lat = reshape(lat_mesh,[],1); 
    z = reshape(dep_mesh,[],1);
    scatter3(lon,lat,z,[],dataB,'.')
      
else   

    data = reshape(permute(squeeze(double(sv.data(1,:,lats:latn,lonw:lone))),[2,3,1]),[],1); % permute array to be lon x lat x dep
    [lon_mesh,lat_mesh,dep_mesh] = meshgrid(svg.lon(lonw:lone),svg.lat(lats:latn),svg.z(:)); 
    lon = reshape(lon_mesh,[],1); 
    lat = reshape(lat_mesh,[],1); 
    z = reshape(dep_mesh,[],1);
    scatter3(lon,lat,z,[],data,'.')
    
end  

title({sprintf('%s',sv.attribute('standard_name'))},'interpreter','none');
hcb = colorbar; title(hcb,sv.attribute('units'),'interpreter','none');

end