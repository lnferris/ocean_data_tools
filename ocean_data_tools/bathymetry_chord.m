%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 21-Jun-2020
%  Distributed under the terms of the MIT License

% inputs: 
    % bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc'; % Path to Smith & Sandwell database 
    % xref = 'lat' 'lon'
    % width = 1/60; % Approximate width of chord in degrees

function bathymetry_chord(bathymetry_dir,lon1,lat1,lon2,lat2,xref,width,filled)

if nargin < 7 
    width = 1/60; % default 
end

if nargin < 8
    filled = 0;
end

% Auto-select region.
region = [min([lat1 lat2]) max([lat1 lat2]) min([lon1 lon2]) max([lon1 lon2])];

% Load bathymetry data.
[bath,lat,lon] = bathymetry_extract(bathymetry_dir,region);

poly_x = [lon1+width/2 lon1-width/2 lon2-width/2 lon2+width/2 lon1+width/2];
poly_y = [lat1+width/2 lat1-width/2 lat2-width/2 lat2+width/2 lat1+width/2];

nlon = length(lon);
nlat = length(lat);
lon = lon.*ones(1,nlat); 
lat = (ones(1,nlon).*lat).'; 

in = inpolygon(lon,lat,poly_x,poly_y); % Get indices of data in polygon.
bathymetry_section = bath(in);
if strcmp(xref,'lon')
    xvar = lon(in);
elseif strcmp(xref,'lat')
    xvar = lat(in);
else
    disp('Check spelling of reference axis');     
end

hold on
plot(xvar,bathymetry_section,'k','LineWidth',4)

if filled ==1

    basevalue = min(bathymetry_section);
    area(xvar,bathymetry_section,basevalue,'FaceColor','k')
    ylim([min(bathymetry_section) 10])
end

hold off

end
