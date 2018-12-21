%%                  INFORMATION

%  Author: Lauren Newell Ferris
%  Institute: Virginia Institute of Marine Science
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Dec 2018; Last revision: 21-Dec-2018
%  Distributed under the terms of the MIT License
%  Dependencies: extract1m_modified.m

% inputs: 
    % ss_path= '/Users/lnferris/Desktop/topo_18.1.img'; % Path to Smith & Sandwell database
    % region = [-80.738 80.738 -180 180 ] %S N W E 
    % start_t = [-15 79] ; % Starting point of transect. [lon lat]
    % stop_t = [-3 62] % Ending point.
    % ref_axis = 'lat' 'lon'

function SSsection(ss_path,region,start_t,stop_t,ref_axis)
%SSsection('/Users/lnferris/Desktop/topo_18.1.img',[60.0 80.0 -35.0 0.0],start_t,stop_t,'lat')

% Remap region from SNWE to WESN.
region = [region(3) region(4) region(1) region(2)];

% Load bathymetry data.
[bath,vlat,vlon] = extract1m_modified(region,ss_path);

% Comment out this next line if you want to cross the dateline...
vlon(vlon>180) = vlon(vlon>180)-360; % Wrap bathymetry lons to -180/180

width = 1/60; % of a lat/lon degree
poly_x = [start_t(1)+width/2 start_t(1)-width/2 stop_t(1)-width/2 stop_t(1)+width/2 start_t(1)+width/2];
poly_y = [start_t(2)+width/2 start_t(2)-width/2 stop_t(2)-width/2 stop_t(2)+width/2 start_t(2)+width/2];

[lon_mesh,lat_mesh] = meshgrid(vlon,vlat);  % Create coordinate mesh from lons/lats/deps.
lon_arr1D = reshape(lon_mesh,[],1); 
lat_arr1D = reshape(lat_mesh,[],1); 
dep_arr1D = reshape(bath,[],1);

in = inpolygon(lon_arr1D,lat_arr1D,poly_x,poly_y); % Get indices of data in polygon.

if strcmp(ref_axis,'lon')
    plot(lon_arr1D(in),dep_arr1D(in),'k','LineWidth',4)
    
elseif strcmp(ref_axis,'lat')
    plot(lat_arr1D(in),dep_arr1D(in),'k','LineWidth',4)
    
else
    disp('Check spelling of reference axis');  
end
