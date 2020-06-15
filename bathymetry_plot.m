%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 15-Jun-2020
%  Distributed under the terms of the MIT License

% inputs: 
    % ss_path= '/Users/lnferris/Desktop/topo_18.1.img'; % Path to Smith & Sandwell database
    % region = S N W E [-80.738 80.738 -180 180 ];
    % type = '2Dscatter' '2Dcontour' '3Dsurf'

function bathymetry_plot(ss_path,region,ptype)

% Remap region from SNWE to WESN.
region = [region(3) region(4) region(1) region(2)];

% Load bathymetry data.
[data,vlat,vlon] = extract1m_modified(region,ss_path);

% Remap to -180/180 if not crossing dateline.
if min(vlon) > 180
    vlon = vlon-360;
end    

hold on

if strcmp(ptype,'2Dscatter')
    
    % 2D Scatter Plot
    disp('Plotting...2Dscatter is slow.');
    [lon_mesh,lat_mesh] = meshgrid(vlon,vlat); % Create coordinate mesh from lons/lats.
    lon_mesh = reshape(lon_mesh,[],1); 
    lat_mesh = reshape(lat_mesh,[],1); 
    data_mesh = reshape(data,[],1); % Reshape in vectors.
    scatter(lon_mesh,lat_mesh,[],data_mesh)
    %c1 = colorbar;
    %ylabel(c1,'Depth [m]')
    colormap jet
    
elseif strcmp(ptype,'2Dcontour')

    % 2D Contour plot
    contour(vlon,vlat,data)
    %c1 = colorbar;
    %ylabel(c1,'Depth [m]')
    colormap jet

elseif strcmp(ptype,'3Dsurf')
    
    % 3D Surface plot
    surf(vlon,vlat,data,'LineStyle','none')
    %c1 = colorbar;
    %ylabel(c1,'Depth [m]')
    colormap jet
    light('Position',[-1 0 0],'Style','local')
    
else 
    disp('Check spelling of plot type');
end

hold off
end