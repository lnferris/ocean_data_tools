%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 29-Jun-2020
%  Distributed under the terms of the MIT License

% inputs: 
    % bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc'; % Path to Smith & Sandwell database 
    % xref = 'lat' 'lon'
    % width = 1/60; % Approximate width of chord in degrees

function [bath_chord,lon_chord,lat_chord] = bathymetry_chord(bathymetry_dir,lon1,lat1,lon2,lat2,xref,width,filled)

if nargin < 7 
    width = 1/60; % default 
end

if nargin < 8
    filled = 0;
end

% deal with inputs other than [-180 180] e.g  [20 200] 
if lon1 > 180
    lon1 = lon1-360;
elseif lon1 < -180
    lon1 = lon1+360;
end
if lon2 > 180
    lon2 = lon2-360;
elseif lon2 < -180
    lon2 = lon2+360;
end

% Auto-select region.
region = [min([lat1 lat2]) max([lat1 lat2]) lon1 lon2];

% Load bathymetry data.
[bath,lat,lon] = bathymetry_extract(bathymetry_dir,region);

% map query to [0 360] if crossing dateline
if lon1 > lon2
    if lon1 < 0 
        lon1 = lon1 + 360;
    end
    if lon2 < 0 
        lon2 = lon2 + 360;
    end
    
end

poly_x = [lon1+width/2 lon1-width/2 lon2-width/2 lon2+width/2 lon1+width/2];
poly_y = [lat1+width/2 lat1-width/2 lat2-width/2 lat2+width/2 lat1+width/2];

nlon = length(lon);
nlat = length(lat);
lon = lon.*ones(1,nlat); 
lat = (ones(1,nlon).*lat).'; 

in = inpolygon(lon,lat,poly_x,poly_y); % Get indices of data in polygon.
bath_chord = bath(in);
lon_chord = lon(in);
lat_chord = lat(in);
if strcmp(xref,'lon')
    xvar = lon_chord;
elseif strcmp(xref,'lat')
    xvar = lat_chord;
else
    disp('Check spelling of reference axis');     
end

hold on
plot(xvar,bath_chord,'k','LineWidth',4)

if filled ==1

    basevalue = min(bath_chord);
    area(xvar,bath_chord,basevalue,'FaceColor','k')
    ylim([min(bath_chord) 10])
end

hold off

end
