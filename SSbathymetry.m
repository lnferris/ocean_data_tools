%%                  INFORMATION

%  Author: Lauren Newell Ferris
%  Institute: Virginia Institute of Marine Science
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Dec 2018; Last revision: 18-Dec-2018
%  Distributed under the terms of the MIT License
%  Dependencies: extract1m_modified.m

%%  Load version 18.1 Bathymetry data

ss_path='/Users/lnferris/Desktop/topo_18.1.img'; % Path to Smith & Sandwell database
region = [-95.0 -75.0 55.0 70.0]; % W E S N, limits [-180 180 -80.738 80.738]
[data,vlat,vlon] = extract1m_modified(region,ss_path);
vlon(vlon>180) = vlon(vlon>180)-360; % Wrap bathymetry lons to -180/180

%%  2D Scatter Plot

[lon_mesh,lat_mesh] = meshgrid(vlon,vlat); % Create coordinate mesh from lons/lats.
lon_mesh = reshape(lon_mesh,[],1); 
lat_mesh = reshape(lat_mesh,[],1); 
data_mesh = reshape(data,[],1); % Reshape in vectors.

figure
scatter(lon_mesh,lat_mesh,[],data_mesh)
colorbar
colormap('gray')

%%  2D Contour plot

figure
contour(vlon,vlat,data)
colormap('gray')

%%  3D Surface plot

figure 
surf(vlon,vlat,data,'LineStyle','none')
colorbar
colormap('gray')
light('Position',[-1 0 0],'Style','local')
