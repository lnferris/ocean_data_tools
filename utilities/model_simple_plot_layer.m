%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 28-Jun-2020
%  Distributed under the terms of the MIT License
%  Dependencies: nctoolbox

function [sv,svg] = model_simple_plot_layer(nc,date,variable,region)

sv = nc{variable}; % Assign ncgeovariable handle.
sv.attributes % Print ncgeovariable attributes.
datestr(sv.timeextent(),29) % Print date range of the ncgeovariable.
svg = sv.grid_interop(:,:,:,:); % Get standardized (time,z,lat,lon) coordinates for the ncgeovariable.

% Prepare to handle 0/360 model data

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

if need2merge == 1

    figA = figure; % Plot the lefthand depth level.
    pcolorjw(lon(lonw_A:lone_A),svg.lat(lats:latn),double(sv.data(tin,lats:latn,lonw_A:lone_A))); % pcolorjw(x,y,c(time,depth,lat,lon))

    figB = figure; % Plot the righthand depth level. 
    pcolorjw(lon(lonw_B:lone_B)+shift,svg.lat(lats:latn),double(sv.data(tin,lats:latn,lonw_B:lone_B))); % pcolorjw(x,y,c(time,depth,lat,lon))

    merge_figures(figA,figB)
    title({sprintf('%s %.0fm',sv.attribute('standard_name'));datestr(svg.time(tin))},'interpreter','none');
    hcb = colorbar; title(hcb,sv.attribute('units'));axis tight;

else   

    figure % Plot the depth level in standard manner.
    pcolorjw(lon(lonw:lone),svg.lat(lats:latn),double(sv.data(tin,lats:latn,lonw:lone))); % pcolorjw(x,y,c(time,depth,lat,lon))
    title({sprintf('%s %.0fm',sv.attribute('standard_name'));datestr(svg.time(tin))},'interpreter','none');
    hcb = colorbar; title(hcb,sv.attribute('units'));

end    