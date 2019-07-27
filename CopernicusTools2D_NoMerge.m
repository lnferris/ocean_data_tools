%%                  INFORMATION

%  Author: Lauren Newell Ferris
%  Institute: Virginia Institute of Marine Science
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  March 2019; Last revision: 26-Jul-2019
%  Distributed under the terms of the MIT License

%  Be aware that Part 2 of this script takes about 70 seconds.
%  Use command 'ncdisp(file_name)' to get metadata.

%  The user might wonder why this might need to be implemented without nctoolbox dependency.
%  The reason is to facilitate dateline-crossing without splitting the dataset.

%%                 1. Load the Data

file_name = '/Users/lnferris/Documents/data/copernicus_phys/mercatorpsy4v3r1_gl12_mean_20161129_R20161207.nc'; % Data directory.

nc = netcdf.open(file_name, 'NOWRITE'); % Open the file as a netcdf datasource
lat = netcdf.getVar(nc,netcdf.inqVarID(nc,'latitude'));
lon = netcdf.getVar(nc,netcdf.inqVarID(nc,'longitude'));
dep = netcdf.getVar(nc,netcdf.inqVarID(nc,'depth'));
time = netcdf.getVar(nc,netcdf.inqVarID(nc,'time'));
thetao = netcdf.getVar(nc,netcdf.inqVarID(nc,'thetao')); % 'sea_water_potential_temperature'
so = netcdf.getVar(nc,netcdf.inqVarID(nc,'so')); % 'Practical Salinity Unit'
uo = netcdf.getVar(nc,netcdf.inqVarID(nc,'uo')); % 'Eastward velocity' m/s
vo = netcdf.getVar(nc,netcdf.inqVarID(nc,'vo')); % 'Northward velocity' m/s

%%                 2. Scale and Order (West to East) the Data

% Prepare dataset for plotting along dataline and scale data.
neginds = lon<0;
posinds = lon>=0;
lon = [lon(posinds); lon(neginds)+360];

% Scale temperature
thetao = double(cat(1,thetao(posinds,:,:),thetao(neginds,:,:)));
scale_factor = netcdf.getAtt(nc,netcdf.inqVarID(nc,'thetao'),'scale_factor');
add_offset = netcdf.getAtt(nc,netcdf.inqVarID(nc,'thetao'),'add_offset');
thetao = thetao(:,:,:)*scale_factor+add_offset;

% Scale salinity
so = double(cat(1,so(posinds,:,:),so(neginds,:,:)));
scale_factor = netcdf.getAtt(nc,netcdf.inqVarID(nc,'so'),'scale_factor');
add_offset = netcdf.getAtt(nc,netcdf.inqVarID(nc,'so'),'add_offset');
so = so(:,:,:)*scale_factor+add_offset;

% Scale u velocity
uo = double(cat(1,uo(posinds,:,:),uo(neginds,:,:)));
scale_factor = netcdf.getAtt(nc,netcdf.inqVarID(nc,'uo'),'scale_factor');
add_offset = netcdf.getAtt(nc,netcdf.inqVarID(nc,'uo'),'add_offset');
uo = uo(:,:,:)*scale_factor+add_offset;

% Scale v velocity
vo = double(cat(1,vo(posinds,:,:),vo(neginds,:,:)));
scale_factor = netcdf.getAtt(nc,netcdf.inqVarID(nc,'vo'),'scale_factor');
add_offset = netcdf.getAtt(nc,netcdf.inqVarID(nc,'vo'),'add_offset');
vo = vo(:,:,:)*scale_factor+add_offset;

data_temp = thetao;
data_sal = so;
data_u = uo;
data_v = vo;
data_U = sqrt(uo.^2+vo.^2);

%%                 3. Choose Region and Depth

[lats,ds] = near(lat,45.0); % Find lat index near southern boundary [-90 90] of region.
[latn,dn] = near(lat,77.0);
[lonw,dw] = near(lon,155.0);% Find lon index near western boundary [0 360] of region.
[lone,de] = near(lon,240.0);
din = 1; % Choose index of depth (inspect variable 'dep') to use for 2-D plots.

%%                 4. Make 2-D Plots

plotCopern(lon,lonw,lone,lat,lats,latn,data_temp,din)
colorbar
caxis([-2 15])
title({sprintf('%s %.0fm','potential temperature',dep(din));datestr(double(time/24) + datenum(1950,1,1))},'interpreter','none')

plotCopern(lon,lonw,lone,lat,lats,latn,data_sal,din)
colorbar
caxis([30 34])
title({sprintf('%s %.0fm','practical salinity',dep(din));datestr(double(time/24) + datenum(1950,1,1))},'interpreter','none')

plotCopern(lon,lonw,lone,lat,lats,latn,data_u,din)
colorbar
caxis([0 1])
title({sprintf('%s %.0fm','eastward velocity',dep(din));datestr(double(time/24) + datenum(1950,1,1))},'interpreter','none')

plotCopern(lon,lonw,lone,lat,lats,latn,data_v,din)
colorbar
caxis([0 1])
title({sprintf('%s %.0fm','northward velocity',dep(din));datestr(double(time/24) + datenum(1950,1,1))},'interpreter','none')

plotCopern(lon,lonw,lone,lat,lats,latn,data_U,din)
colorbar
caxis([0 1])
title({sprintf('%s %.0fm','velocity magnitude sqrt(u^2+v^2)',dep(din));datestr(double(time/24) + datenum(1950,1,1))},'interpreter','none')

%%                    FUNCTIONS

function output_txt = myupdatefcn(~, event_obj, X, Y, Z)
% ~            Currently not used (empty)
% event_obj    Object containing event data structure
% output_txt   Data cursor text
%find the closest data point to the cursor
cursor_pos = event_obj.Position;
dist2_to_dots = (X - cursor_pos(1)).^2 + (Y - cursor_pos(2)).^2;
[~, item_idx] = min(dist2_to_dots);
output_txt = {sprintf('X: %g', X(item_idx)), sprintf('Y: %g', Y(item_idx)), sprintf('Z: %g', Z(item_idx)) };
end

function plotCopern(lon,lonw,lone,lat,lats,latn,data_set,din)
lon_domain = lon(lonw:lone); lat_domain = lat(lats:latn); % Get lons/lats in region.
cropped_data = data_set(lonw:lone,lats:latn,din); % Get data in region.
[lat_mesh,lon_mesh] = meshgrid(lat_domain,lon_domain); % Create coordinate mesh from lons/lats.
lon_arr1D = reshape(lon_mesh,[],1);
lat_arr1D = reshape(lat_mesh,[],1); 
cropped_data_arr1D = reshape(cropped_data,[],1);  % Reshape in vectors.

figure % Plot data.
scatter(lon_arr1D,lat_arr1D,[],cropped_data_arr1D.','.')

% Add colorbar value to data cursor.
dcm_obj = datacursormode();
set(dcm_obj,'UpdateFcn',@(hObject, event_obj) myupdatefcn(hObject,event_obj,lon_arr1D,lat_arr1D,cropped_data1D) );
end
