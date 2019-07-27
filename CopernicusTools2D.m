%%                  INFORMATION

%  Author: Lauren Newell Ferris
%  Institute: Virginia Institute of Marine Science
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  March 2019; Last revision: 27-Jul-2019
%  Distributed under the terms of the MIT License

%  Dependencies: nctoolbox.github.io/nctoolbox/
%  Remember to run the command "setup_nctoolbox".

% USER INPUTS: Line 17, 21, 28, 29.

%%                 1. Load the Data

filename = '/Users/lnferris/Documents/data/copernicus_phys/mercatorpsy4v3r1_gl12_mean_20161129_R20161207.nc';
nc = ncgeodataset(filename); % Assign a ncgeodataset handle.
nc.variables % Print list of available variables.

sv = nc{'thetao'}; % Assign ncgeovariable handle for particular variable: 'sithick''siconc''thetao''so''uo''vo'
sv.attributes % Print ncgeovariable attributes.
svg = sv.grid_interop(:,:,:,:); % Get standardized (time,z,lat,lon) coordinates for the ncgeovariable.
datestr(sv.timeextent(),29) % Print date range of the ncgeovariable.

%%                2. Choose Region and Date

region = [45.0, 77.0 ,155, -120];      % [-90 90 -180 180]
din = 1; % Choose index of depth (z-level) to use for 2-D plots. Inspect 'svg.z' to see options.

if region(3) > region(4) && region(4) < 0 % If data spans the dateline...
[lonw_A] = near(svg.lon,region(3));% Find lon indexes of lefthand chunk.
[lone_A] = near(svg.lon,180);
[lonw_B] = near(svg.lon,-180);% Find lon indexes of righthand chunk.
[lone_B] = near(svg.lon,region(4));
else
[lonw] = near(svg.lon,region(3));% Find lon indexes in standard manner.
[lone] = near(svg.lon,region(4));
end
[lats] = near(svg.lat,region(1)); 
[latn] = near(svg.lat,region(2));

%%                 3a. Plot of one depth level (2-D) of temp, sal, ice, velocity component, etc.

if region(3) > region(4) && region(4) < 0 % If data spans the dateline...
    
figA = figure; % Plot the lefthand depth level.
pcolorjw(svg.lon(lonw_A:lone_A),svg.lat(lats:latn),double(sv.data(:,din,lats:latn,lonw_A:lone_A))); % pcolorjw(x,y,c(time,depth,lat,lon))

figB = figure; % Plot the righthand depth level. 
pcolorjw(svg.lon(lonw_B:lone_B)+360,svg.lat(lats:latn),double(sv.data(:,din,lats:latn,lonw_B:lone_B))); % pcolorjw(x,y,c(time,depth,lat,lon))

copyobj(get(get(figB, 'Children'),'Children'), get(figA, 'Children')); % Merge the two figures.
close(figB)
title({sprintf('%s %.0fm',sv.attribute('standard_name'),svg.z(din));datestr(svg.time)},'interpreter','none');
hcb = colorbar; title(hcb,sv.attribute('units'));axis tight;

else   
figure % Plot the depth level in standard manner.
pcolorjw(svg.lon(lonw:lone),svg.lat(lats:latn),double(sv.data(:,din,lats:latn,lonw:lone))); % pcolorjw(x,y,c(time,depth,lat,lon))
title({sprintf('%s %.0fm',sv.attribute('standard_name'),svg.z(din));datestr(svg.time)},'interpreter','none');
hcb = colorbar; title(hcb,sv.attribute('units'));
end

%%                3b. Plot one depth level (2-D) of velocity magnitude sqrt(u^2+v^2)

if region(3) > region(4) && region(4) < 0 % If data spans the dateline...  
sv_u = nc{'uo'}; sv_v = nc{'vo'}; % Assign ncgeovariable handles for water_u, water_v.
svg_u = sv_u.grid_interop(:,:,:,:);  % Get standardized (time,z,lat,lon) coordinates based on water_u.
velocim = sqrt(double(sv_u.data(:,din,lats:latn,lonw_A:lone_A)).^2+double(sv_v.data(:,din,lats:latn,lonw_A:lone_A)).^2);

figA = figure; % Plot one depth level.
pcolorjw(svg_u.lon(lonw_A:lone_A),svg_u.lat(lats:latn),velocim); % pcolorjw(x,y,c);    

sv_u = nc{'uo'}; sv_v = nc{'vo'}; % Assign ncgeovariable handles for water_u, water_v.
svg_u = sv_u.grid_interop(:,:,:,:);  % Get standardized (time,z,lat,lon) coordinates based on water_u.
velocim = sqrt(double(sv_u.data(:,din,lats:latn,lonw_B:lone_B)).^2+double(sv_v.data(:,din,lats:latn,lonw_B:lone_B)).^2);

figB = figure; % Plot one depth level.
pcolorjw(svg_u.lon(lonw_B:lone_B)+360,svg_u.lat(lats:latn),velocim); % pcolorjw(x,y,c); 

copyobj(get(get(figB, 'Children'),'Children'), get(figA, 'Children')); % Merge the two figures.
close(figB)
axis tight;
title({sprintf('velocity magnitude %.0fm',svg_u.z(din));datestr(svg.time)},'interpreter','none');
hcb = colorbar; title(hcb,sv_u.attribute('units'));

else
sv_u = nc{'uo'}; sv_v = nc{'vo'}; % Assign ncgeovariable handles for water_u, water_v.
svg_u = sv_u.grid_interop(:,:,:,:);  % Get standardized (time,z,lat,lon) coordinates based on water_u.
velocim = sqrt(double(sv_u.data(:,din,lats:latn,lonw:lone)).^2+double(sv_v.data(:,din,lats:latn,lonw:lone)).^2);

figure % Plot one depth level.
pcolorjw(svg_u.lon(lonw:lone),svg_u.lat(lats:latn),velocim); % pcolorjw(x,y,c)
title({sprintf('velocity magnitude %.0fm',svg_u.z(din));datestr(svg.time)},'interpreter','none');
hcb = colorbar; title(hcb,sv_u.attribute('units'));
end
