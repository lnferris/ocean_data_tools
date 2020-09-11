
function bathymetry_plot(bathy,ptype)
% bathymetry_plot adds global seafloor topography (Smith & Sandwell, 1997)
% to an existing 2D plot  or 3D plot
% 
%% Syntax
% 
% bathymetry_plot(bathy,ptype)
% 
%% Description 
% 
% bathymetry_plot(bathy,ptype) makes a 2D (latitude vs. longitude) or 3D 
% (latitude vs. longitude vs. depth) plot from bathy, where bathy is a struct
% of Smith & Sandwell Global Topography created using bathymetry_extract. 
% type = '2Dscatter' or '2Dcontour' or '3Dsurf' specifies the plot type.
%
%% Example 1
% Make a contour plot of bathymetry in the North Pacific:
%
% region = [-5.0, 45.0 ,120, -150];      % [-90 90 -180 180]
% [bathy] = bathymetry_extract(bathymetry_dir,region);
% ptype = '2Dcontour'; % '2Dscatter' '2Dcontour' '3Dsurf'
% figure
% bathymetry_plot(bathy,ptype)
%
%% Example 2
% Add a bathymetry surface to a 3D plot of model data:
%
% variable = 'velocity';  % thetao' 'so' 'uo' 'vo' 'velocity'
% model_domain_plot(model_type,source,date,variable,region) % 3D plot of model data
% bathymetry_plot(bathy,'3Dsurf')
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 09-Sep-2020
% 
% See also general_map and bathymetry_section.

% Load bathymetry data.
bath = bathy.z;
lat = bathy.lat;
lon = bathy.lon;

hold on

if strcmp(ptype,'2Dscatter')
    
    % 2D Scatter Plot
    nlon = length(lon);
    nlat = length(lat);
    lon = lon.*ones(1,nlat);
    lat = (ones(1,nlon).*lat).';
    scatter(reshape(lon,[],1),reshape(lat,[],1),[],reshape(bath,[],1));
    %c1 = colorbar;
    %ylabel(c1,'Depth [m]')
    %colormap gray
    colorbar
    
elseif strcmp(ptype,'2Dcontour')

    % 2D Contour plot
    contour(lon,lat,bath.');
    %c1 = colorbar;
    %ylabel(c1,'Depth [m]')
    %colormap gray
    colorbar

elseif strcmp(ptype,'3Dsurf')
    
    % 3D Surface plot
    surf(lon,lat,bath.','LineStyle','none','FaceColor',[0.5 0.5 0.5]);
    %ylabel(c1,'Depth [m]')
    light('Position',[-1 0 0],'Style','local')
    
    
else 
    disp('Check spelling of plot type');
end

hold off
end