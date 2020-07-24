
function [bath_chord,lon_chord,lat_chord] = bathymetry_chord(bathymetry_dir,lon1,lat1,lon2,lat2,xref,filled,width)
% bathymetry_chord adds global seafloor topography (Smith & Sandwell, 1997) to an existing section
% plot from a bathymetry chord of 1/60-degree width. It is less exact than
% bathymetry_section; a practical application is to capture seamounts that
% might have been nearby but not exactly beneath in a transect.
% 
%% Syntax
% 
% [bath_chord,lon_chord,lat_chord] = bathymetry_chord(bathymetry_dir,lon1,lat1,lon2,lat2,xref)
% [bath_chord,lon_chord,lat_chord] = bathymetry_chord(bathymetry_dir,lon1,lat1,lon2,lat2,xref,filled)
% [bath_chord,lon_chord,lat_chord] = bathymetry_chord(bathymetry_dir,lon1,lat1,lon2,lat2,xref,filled,width)
% 
%% Description 
% 
% [bath_chord,lon_chord,lat_chord] = bathymetry_chord(bathymetry_dir,lon1,lat1,lon2,lat2,xref) extracts
% Smith & Sandwell Global Topography in path bathymetry_dir for use with a
% section plot. Points lying within a narrow chord-like region of width 1/60-degrees 
% are extracted, with lon1 and lat1 marking the beginning of the chord and
% lon2 and lat2 marking the end of the chord. The bathymetry section is
% plotted with xref = 'lon' or xref = 'lat' as the x-axis variable. The
% extracted data is output bath_chord, lon_chord, and lat_chord. 
%  
% [bath_chord,lon_chord,lat_chord] = bathymetry_chord(bathymetry_dir,lon1,lat1,lon2,lat2,xref,filled) allows the
% bathymetry to be filled in black down to the x-axis (instead of a simple line).
% Set filled=1 to turn on, filled=0 to turn off.
% 
% [bath_chord,lon_chord,lat_chord] =
% bathymetry_chord(bathymetry_dir,lon1,lat1,lon2,lat2,xref,filled,width) allows
% the user to change the width of the chord-like region of extraction from
% the default 1/60 degrees.
%
%% Example 1
% Add bathymetry from 67S,160E to 66.5S,80W to a temperature section plot.
% Use longitude as the x-axis:
%
% xref = 'lon'; % 'lon' 'lat'
% general_section(cruise,'temperature',xref,'pressure')  % plot temperature section
% lon1 = 160;
% lat1 = -67;
% lon2 = 280; 
% lat2 = -66.5;
% bathymetry_chord(bathymetry_dir,lon1,lat1,lon2,lat2,xref)
% 
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 21-Jul-2020
% 
% See also general_section and bathymetry_section.


if nargin < 7 
    filled = 0;
end

if nargin < 8
    width = 1/60; % default 
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
