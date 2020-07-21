
function bathymetry_plot(bathymetry_dir,region,ptype)
% bathymetry_plot adds global seafloor topography (Smith & Sandwell, 1997)
% to an existing 2D plot  or 3D plot
% 
%% Syntax
% 
% bathymetry_plot(bathymetry_dir,region,ptype)
% 
%% Description 
% 
% bathymetry_plot(bathymetry_dir,region,ptype) extracts
% Smith & Sandwell Global Topography in path bathymetry_dir for use with a
% 2D (latitude vs. longitude) or 3D (latitude vs. longitude vs. depth)
% plot. The region extracted is given by region, maximum latitudes and
% longitudes are given by [-80.738 80.738 -180 180], and should be in order 
% [S N W E]. type = '2Dscatter' or '2Dcontour' or '3Dsurf' specifies the plot type.
%
%% Example 1
% Make a contour plot of bathymetry in the North Pacific:
%
% region = [-5.0, 45.0 ,120, -150];      % [-90 90 -180 180]
% ptype = '2Dcontour'; % '2Dscatter' '2Dcontour' '3Dsurf'
% figure
% bathymetry_plot(bathymetry_dir,region,ptype)
%
%% Example 2
% Add a bathymetry surface to a 3D plot of model data:
%
% variable = 'velocity';  % thetao' 'so' 'uo' 'vo' 'velocity'
% model_domain_plot(model,source,date,variable,region) % 3D plot of model data
% bathymetry_plot(bathymetry_dir,region,'3Dsurf')
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 30-Jun-2020
% 
% See also general_map and bathymetry_section.


% Load bathymetry data.
[bath,lat,lon] = bathymetry_extract(bathymetry_dir,region);

% deal with inputs other than [-90 90 -180 180] e.g  [-90 90 20 200] 
region(region>180) = region(region>180)- 360;
region(region<-180) = region(region<-180)+360;

if region(3) > region(4) && region(3) < 0 && region(4)+360>180    
    lon(lon>360) = lon(lon>360)-360;
    [lon,lon_inds] = sort(lon);
    bath = bath(lon_inds,:);  
end

hold on

if strcmp(ptype,'2Dscatter')
    
    % 2D Scatter Plot
    nlon = length(lon);
    nlat = length(lat);
    lon = lon.*ones(1,nlat);
    lat = (ones(1,nlon).*lat).';
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
    surf(lon,lat,bath.','LineStyle','none','FaceColor',[0.5 0.5 0.5])
    %ylabel(c1,'Depth [m]')
    light('Position',[-1 0 0],'Style','local')
    
else 
    disp('Check spelling of plot type');
end

hold off
end