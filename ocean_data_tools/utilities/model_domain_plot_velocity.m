%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 28-Jun-2020
%  Distributed under the terms of the MIT License
%  Dependencies: nctoolbox


function model_domain_plot_velocity(model,nc,date,region)

if strcmp(model,'hycom')  
    sv = nc{'water_u'};     % Assign ncgeovariable handle.
    sv_v = nc{'water_v'};     
elseif strcmp(model,'mercator') 
    sv = nc{'uo'};     % Assign ncgeovariable handle.
    sv_v = nc{'vo'};        
else
    disp('Check spelling of model.');
    return
end

sv.attributes % Print ncgeovariable attributes.
datestr(sv.timeextent(),29) % Print date range of the ncgeovariable.
svg = sv.grid_interop(:,:,:,:); % Get standardized (time,z,lat,lon) coordinates for the ncgeovariable.

model360 = all(svg.lon>=0); 
lon = svg.lon;
shift = 360;
if model360
    east_inds = find(lon>180);
    lon(east_inds) = lon(east_inds)-360;
    shift = 0;
end

% Find Indices

[tin,~] = near(svg.time,datenum(date,'dd-mmm-yyyy HH:MM:SS'));  % Find time index near date of interest. 
[lats,~] = near(svg.lat,region(1)); % Find lat index near southern boundary [-90 90] of region.
[latn,~] = near(svg.lat,region(2));
[lonw] = near(lon,region(3));% Find lon indexes in standard manner.
[lone] = near(lon,region(4));   

need2merge = 0;
if lonw > lone && ~model360
    [lonw_A] = near(lon,region(3));% Find lon indexes of lefthand chunk.
    [lone_A] = near(lon,180);
    [lonw_B] = near(lon,-180);% Find lon indexes of righthand chunk.
    [lone_B] = near(lon,region(4)); 
    need2merge = 1;
elseif lonw > lone && model360   
    [lonw_A] = near(lon,region(3));% Find lon indexes of lefthand chunk.
    [lone_A] = near(svg.lon,360);
    [lonw_B] = near(svg.lon,0);% Find lon indexes of righthand chunk.
    [lone_B] = near(lon,region(4)); 
    need2merge = 1;  
end

if region(3) > region(4) && model360  
    lon(east_inds) = lon(east_inds)+360;
end


% Make Plot

if need2merge == 1
    
    figure; % Plot left side
    u = reshape(permute(squeeze(double(sv.data(tin,:,lats:latn,lonw_A:lone_A))),[2,3,1]),[],1); % permute array to be lon x lat x dep
    v = reshape(permute(squeeze(double(sv_v.data(tin,:,lats:latn,lonw_A:lone_A))),[2,3,1]),[],1); % permute array to be lon x lat x dep
    data = sqrt(u.^2+v.^2);
    [lon_mesh,lat_mesh,dep_mesh] = meshgrid(lon(lonw_A:lone_A),svg.lat(lats:latn),svg.z(:)); 
    lon = reshape(lon_mesh,[],1); 
    lat = reshape(lat_mesh,[],1); 
    z = reshape(dep_mesh,[],1);
    scatter3(lon,lat,z,[],data,'.')
    
    hold on % Plot right side
    u = reshape(permute(squeeze(double(sv.data(tin,:,lats:latn,lonw_B:lone_B))),[2,3,1]),[],1); % permute array to be lon x lat x dep
    v = reshape(permute(squeeze(double(sv_v.data(tin,:,lats:latn,lonw_B:lone_B))),[2,3,1]),[],1); % permute array to be lon x lat x dep
    data = sqrt(u.^2+v.^2);
    [lon_mesh,lat_mesh,dep_mesh] = meshgrid(lon(lonw_B:lone_B)+shift,svg.lat(lats:latn),svg.z(:)); 
    lon = reshape(lon_mesh,[],1); 
    lat = reshape(lat_mesh,[],1); 
    z = reshape(dep_mesh,[],1);
    scatter3(lon,lat,z,[],data,'.')
    
    title({'velocity magnitude';datestr(svg.time(tin))},'interpreter','none');
    hcb = colorbar; title(hcb,sv.attribute('units'));

else   
    u = reshape(permute(squeeze(double(sv.data(tin,:,lats:latn,lonw:lone))),[2,3,1]),[],1); % permute array to be lon x lat x dep
    v = reshape(permute(squeeze(double(sv_v.data(tin,:,lats:latn,lonw:lone))),[2,3,1]),[],1); % permute array to be lon x lat x dep
    data = sqrt(u.^2+v.^2);
    [lon_mesh,lat_mesh,dep_mesh] = meshgrid(lon(lonw:lone),svg.lat(lats:latn),svg.z(:)); 
    lon = reshape(lon_mesh,[],1); 
    lat = reshape(lat_mesh,[],1); 
    z = reshape(dep_mesh,[],1);

    figure 
    scatter3(lon,lat,z,[],data,'.')
    title({'velocity magnitude';datestr(svg.time(tin))},'interpreter','none');
    hcb = colorbar; title(hcb,sv.attribute('units'));
end    


end