%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 28-Jun-2020
%  Distributed under the terms of the MIT License

% inputs: 
    % bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc'; % Path to
    % Smith & Sandwell database 
    % region = S N W E [-80.738 80.738 -180 180 ];
    % type = '2Dscatter' '2Dcontour' '3Dsurf'

function bathymetry_plot(bathymetry_dir,region,ptype)

% Load bathymetry data.
[bath,lat,lon] = bathymetry_extract(bathymetry_dir,region);



% deal with inputs other than [-90 90 -180 180] e.g  [-90 90 20 200] 
region(region>180) = region(region>180)- 360;
region(region<-180) = region(region<-180)+360;

if region(3) < 0
    east_inds = find(lon>180);
    lon(east_inds) = lon(east_inds)-360;    
end

[lon,lon_inds] = sort(lon);
bath = bath(lon_inds,:);

hold on

if strcmp(ptype,'2Dscatter')
    
    % 2D Scatter Plot
    lon = lon.*ones(1,length(lat));
    lat = (ones(1,length(lon)).*lat).';
    scatter(reshape(lon,[],1),reshape(lat,[],1),[],reshape(bath,[],1))
    %c1 = colorbar;
    %ylabel(c1,'Depth [m]')
    colormap jet
    
elseif strcmp(ptype,'2Dcontour')

    % 2D Contour plot
    contour(lon,lat,bath.')
    %c1 = colorbar;
    %ylabel(c1,'Depth [m]')
    colormap jet

elseif strcmp(ptype,'3Dsurf')
    
    % 3D Surface plot
    surf(lon,lat,bath.','LineStyle','none')
    %c1 = colorbar;
    %ylabel(c1,'Depth [m]')
    colormap jet
    light('Position',[-1 0 0],'Style','local')
    
else 
    disp('Check spelling of plot type');
end

hold off
end