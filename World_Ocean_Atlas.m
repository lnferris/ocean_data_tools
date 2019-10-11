%%                          INFORMATION

%  Author: Lauren Newell Ferris
%  Institute: Virginia Institute of Marine Science
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  October 2019; Last revision: 10-Oct-2019
%  Distributed under the terms of the MIT License

% Data information:
% https://www.nodc.noaa.gov/OC5/woa18/woa18data.html

% Dependencies: 
% nctoolbox (https://github.com/nctoolbox/nctoolbox)
% ocean_data_tools (https://github.com/lnferris/ocean_data_tools)

% Instructions:
% a. Run section 1A (temperature), 1B (salinity), or 1C (oxygen).
% b. Set the lat/lon of your desired region on lines 84-87. Run section 2.
% c. Run section 3.
% d. List virtual profile lat/lons on line 123-124. Run section 4.

%% 1. [Option A] Load World Ocean Atlas 2018 0.25-degree Temperature (degrees Celsius)

setup_nctoolbox

% Specify data access url.
                    
tem_url = 'https://data.nodc.noaa.gov/thredds/dodsC/ncei/woa/temperature/decav/0.25/woa18_decav_t00_04.nc';
url = tem_url;

% Assign a ncgeodataset handle.
nc = ncgeodataset(url); 

% Print list of available variables. 
nc.variables 

% Assign ncgeovariable handle.
sv = nc{'t_an'}; 

%% 1. [Option B] Load World Ocean Atlas 2018 0.25-degree Salinity (psu)

setup_nctoolbox

% Specify data access url.
sal_url = 'https://data.nodc.noaa.gov/thredds/dodsC/ncei/woa/salinity/decav/0.25/woa18_decav_s00_04.nc';
url = sal_url;

% Assign a ncgeodataset handle.
nc = ncgeodataset(url); 

% Print list of available variables. 
nc.variables 

% Assign ncgeovariable handle.
sv = nc{'s_an'}; 

%% 1. [Option C] Load World Ocean Atlas 2018 1-degree Dissolved Oxygen (�mol/kg)

setup_nctoolbox

% Specify data access url.
oxy_url = 'https://data.nodc.noaa.gov/thredds/dodsC/ncei/woa/oxygen/all/1.00/woa18_all_o00_01.nc';
url = oxy_url;

% Assign a ncgeodataset handle.
nc = ncgeodataset(url); 

% Print list of available variables.
nc.variables

% Assign ncgeovariable handle.
sv = nc{'o_an'}; 

%% 2. Plot entire 2-D surface of data.

% Print ncgeovariable attributes.
sv.attributes 

% Get standardized (time,z,lat,lon) coordinates for the ncgeovariable.
svg = sv.grid_interop(:,:,:,:); 

% Specify coordinates of a specific region to get indices of region boundaries.
[lats,~] = near(svg.lat,20.0); % Southern boundary [-90 90] of region.
[latn,~] = near(svg.lat,45.0); % Northern boundary [-90 90] of region.
[lonw,~] = near(svg.lon,-90.0); % Western boundary [-180 180] of region.
[lone,~] = near(svg.lon,-50.0); % Eastern boundary [-180 180] of region.
[din,~] = near(svg.z,0); % Depth of interest to use for 2-D plot.

figure % Plot the depth level. 
pcolorjw(svg.lon(lonw:lone),svg.lat(lats:latn),double(sv.data(1,din,lats:latn,lonw:lone))); % pcolorjw(x,y,c(time,depth,lat,lon))
title({sprintf('%s %.0fm',sv.attribute('standard_name'),svg.z(din));url},'interpreter','none');
hcb = colorbar; title(hcb,sv.attribute('units'));

%% 3. Plot entire 3-D domain of data.

% Get longitude, latitude, and depth data only for the desired region.
lon_domain = svg.lon(lonw:lone);
lat_domain = svg.lat(lats:latn);
dep_domain = svg.z(:);

% Get T/S data in region. Dimensions: dep,lat,lon
tso_data = squeeze(double(sv.data(1,:,lats:latn,lonw:lone))); 
tso_data = permute(tso_data,[2,3,1]); % Permute array since we'll plot in this order. Dimensions: lon,lat,dep

% Create coordinate mesh from lons/lats/deps.
[lon_mesh,lat_mesh,dep_mesh] = meshgrid(lon_domain,lat_domain,dep_domain);  

% Reshape coordinate mesh and data into vectors to allow easy plotting.
lon_arr1D = reshape(lon_mesh,[],1); 
lat_arr1D = reshape(lat_mesh,[],1); 
dep_arr1D = reshape(dep_mesh,[],1);
tso_arr1D = reshape(tso_data,[],1);

% Plot the data.
figure
scatter3(lon_arr1D,lat_arr1D,dep_arr1D,[],tso_arr1D,'.')
title({sprintf('%s',sv.attribute('long_name'));url;},'interpreter','none');
hcb = colorbar; title(hcb,sv.attribute('units'));

%% 4. Create virtual profiles.

profile_lons = [-70, -55, -50];
profile_lats = [38, 25, 40];

for n = 1:length(profile_lons)
    
% Add profile marker to 3-D domain.
hold on
[~,~] = HYCOM_virtual_cast(profile_lons(n),profile_lats(n),sv,svg,1,'cast_map');

end

figure
hold all
for n = 1:length(profile_lons)
% Plot raw virtual cast.

[woa_tracer,woa_z] = HYCOM_virtual_cast(profile_lons(n),profile_lats(n),sv,svg,1,'cast_profile');

% Plot interpolated virtual cast.
zz = woa_z(1):-1:woa_z(end);
ttrace = interp1(woa_z,woa_tracer,zz,'linear');
scatter(ttrace,zz,'.r')
end

% Add a title and legend.
legend('raw virtual cast (black)', 'interpolated virtual cast (red)')
title({sprintf('%s',sv.attribute('standard_name'))},'interpreter','none');
