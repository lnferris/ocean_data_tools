
function [data,lat,lon] = model_simple_plot_layer(nc,date,variable,region)
% This is the layer variable (e.g. sea ice, SSH) portion of model_simple_plot
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 13-Jul-2020
% See also model_simple_plot and model_simple_plot_velocity.

sv = nc{variable}; % Assign ncgeovariable handle.
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

% Format and merge data

if need2merge == 1
    data = cat(2,squeeze(double(sv.data(tin,lats:latn,lonw_B:lone_B))),squeeze(double(sv.data(tin,lats:latn,lonw_A:lone_A))));
    lon = [svg.lon(lonw_B:lone_B)+360; svg.lon(lonw_A:lone_A)];
else   
    data = squeeze(double(sv.data(tin,lats:latn,lonw:lone)));
    lon = svg.lon(lonw:lone);
end    
lat = svg.lat(lats:latn);
[lon,lon_inds] = sort(lon);
data = data(:,lon_inds);

% Plot

pcolor(lon,lat,data); 
shading flat
title({sprintf('%s %.0fm',sv.attribute('standard_name'));datestr(svg.time(tin))},'interpreter','none');
hcb = colorbar; title(hcb,sv.attribute('units'));

end
