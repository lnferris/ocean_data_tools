
function [bath_section,lon_section,lat_section] = bathymetry_section(bathymetry_dir,xcoords,ycoords,xref,filled)
% bathymetry_section adds global seafloor topography (Smith & Sandwell, 1997) to an existing section
% plot from points nearest to specified coordinates
% 
%% Syntax
% 
%  [bath_section,lon_section,lat_section] = bathymetry_section(bathymetry_dir,xcoords,ycoords,xref)
%  [bath_section,lon_section,lat_section] = bathymetry_section(bathymetry_dir,xcoords,ycoords,xref,filled)
% 
%% Description 
% 
% [bath_section,lon_section,lat_section] =
% bathymetry_section(bathymetry_dir,xcoords,ycoords,xref) extracts
% Smith & Sandwell Global Topography in path bathymetry_dir for use with a
% section plot. Points are extracted nearest to each coordinate specified
% by xcoords (longitude) and ycoords (latitude). The bathymetry section is
% plotted with xref = 'lon' or xref = 'lat' as the x-axis variable. The
% extracted data is output bath_section, lon_section, and lat_section.
%  
% [bath_section,lon_section,lat_section] =
% bathymetry_section(bathymetry_dir,xcoords,ycoords,xref,filled) allows the
% bathymetry to be filled in black down to the x-axis (instead of a simple line).
% Set filled=1 to turn on, filled=0 to turn off.
% 
%% Example 1
% Add bathymetry to a temperature section plot from the list of coordinates
% stored in struct cruise, filling in bathymetry. Use longitude as the x-axis:
% 
% xref = 'lon'; % 'lon' 'lat'
% general_section(cruise,'temperature',xref,'pressure') % plot temperature section
% xcoords = cruise.lon; 
% ycoords = cruise.lat;
% filled = 1;
% bathymetry_section(bathymetry_dir,xcoords,ycoords,xref,filled)
%
%% Example 2
% Plot bathymetry nearest to a list of coordinates. Use latitude as the x-axis:
% 
% xref = 'lat'; 
% xcoords = [60 60.1 60.4 60.2 59.9]; 
% ycoords = [10 20.1 15.0 16.1 13.7]; 
% figure
% bathymetry_section(bathymetry_dir,xcoords,ycoords,xref)
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 30-Jun-2020
% 
% See also general_section and bathymetry_chord.


if nargin < 5
    filled = 0;
end

% Auto-select region.
region = [min(ycoords)-1 max(ycoords)+1 min(xcoords)-1 max(xcoords)+1];

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

bath_section = NaN(1,length(xcoords));
lon_section = NaN(1,length(xcoords));
lat_section = NaN(1,length(xcoords));
for i = 1:length(xcoords)
    [lon_ind,~] = near(lon,xcoords(i));
    [lat_ind,~] = near(lat,ycoords(i));
    bath_section(i) = bath(lon_ind,lat_ind);
    lon_section(i) = lon(lon_ind);
    lat_section(i) = lat(lat_ind);
end

if strcmp(xref,'lon')
    xvar = lon_section;   
elseif strcmp(xref,'lat')
    xvar = lat_section;   
else
    disp('Check spelling of reference axis');  
end

% order bathymetry data by xref.
[xvar,xvar_inds] = sort(xvar);
bath_section = bath_section(xvar_inds);

hold on
plot(xvar,bath_section,'k','LineWidth',4)

if filled ==1
    basevalue = min(bath_section);
    area(xvar,bath_section,basevalue,'FaceColor','k')
    ylim([min(bath_section) 10])
end

hold off
end