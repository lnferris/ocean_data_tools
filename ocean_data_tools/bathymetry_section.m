
function [bath_section,lon_section,lat_section,time_section] = bathymetry_section(bathymetry_dir,xcoords,ycoords,xref,filled,maxdistance)
% bathymetry_section adds global seafloor topography (Smith & Sandwell, 1997) to an existing section
% plot from points nearest to specified coordinates
% 
%% Syntax
% 
%  [bath_section,lon_section,lat_section,time_section] = bathymetry_section(bathymetry_dir,xcoords,ycoords,xref)
%  [bath_section,lon_section,lat_section,time_section] = bathymetry_section(bathymetry_dir,xcoords,ycoords,xref,filled)
%  [bath_section,lon_section,lat_section,time_section] = bathymetry_section(bathymetry_dir,xcoords,ycoords,xref,filled,maxdistance)
% 
%% Description 
% 
% [bath_section,lon_section,lat_section] =
% bathymetry_section(bathymetry_dir,xcoords,ycoords,xref) extracts
% Smith & Sandwell Global Topography in path bathymetry_dir for use with a
% section plot. Points are extracted nearest to each coordinate specified
% by xcoords (longitude) and ycoords (latitude). The bathymetry section is
% plotted against xref; where xref = 'lon', 'lat', or a time vector of length(xcoords). The
% extracted data is output bath_section, lon_section, lat_section, and time_section; 
% output vectors are sorted by the selected reference axis (longitude,
% latitude, or time).
%  
% [bath_section,lon_section,lat_section] =
% bathymetry_section(bathymetry_dir,xcoords,ycoords,xref,filled) allows the
% bathymetry to be filled in black down to the x-axis (instead of a simple line).
% Set filled=1 to turn on, filled=0 to turn off.
%
% [bath_section,lon_section,lat_section] =
% bathymetry_section(bathymetry_dir,xcoords,ycoords,xref,filled,maxdistance)
% does not pull values where xcoords and ycoords are not within maxdistance (degrees) of a Global Topography
% value. maxdistance=0.05 would pull no bathymetry at times/places not within
% 0.05 diagonal degrees of an available Global Topography value.
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
%% Example 3
% Plot bathymetry nearest to a list of coordinates. Use a time as the x-axis:
% 
% xref = [737009 737010 737011 737012 737013]; 
% xcoords = [60 60.1 60.4 60.2 59.9]; 
% ycoords = [10 20.1 15.0 16.1 13.7]; 
% figure
% bathymetry_section(bathymetry_dir,xcoords,ycoords,xref)
%
%% Example 4
% Plot bathymetry nearest to a list of coordinates, using time as the
% x-axis and shading bathymetry. Only return bathymetry values for timesteps within 0.007 degrees
% of a bathymetry node:
% 
% xref = [737009 737010 737011 737012 737013]; 
% xcoords = [60 60.1 60.4 60.2 59.9]; 
% ycoords = [10 20.1 15.0 16.1 13.7]; 
% filled = 1;
% maxdistance = 0.007;
% figure
% bathymetry_section(bathymetry_dir,xcoords,ycoords,xref,filled,maxdistance)
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 26-Jul-2020
% 
% See also general_section and bathymetry_chord.

if nargin < 5
    filled = 0;
end

% Auto-select region and load bathymetry data.
region = [min(ycoords)-1 max(ycoords)+1 min(xcoords)-1 max(xcoords)+1];
[bath,lat,lon] = bathymetry_extract(bathymetry_dir,region);

% Deal with inputs other than [-90 90 -180 180] e.g  [-90 90 20 200] 
region(region>180) = region(region>180)- 360;
region(region<-180) = region(region<-180)+360;

% Format bathymetry that crossed a line.
if region(3) > region(4) && region(3) < 0 && region(4)+360>180    
    lon(lon>360) = lon(lon>360)-360;
    [lon,lon_inds] = sort(lon);
    bath = bath(lon_inds,:);  
end

% Get nearest bathymetry values.
N = length(xcoords);
if length(xref)==N 
    time_section = xref;
else
    time_section = NaN(1,N);
end
bath_section = NaN(1,N);
lon_section = NaN(1,N);
lat_section = NaN(1,N);
for i = 1:N
    [lon_ind,xdist] = near(lon,xcoords(i));
    [lat_ind,ydist] = near(lat,ycoords(i));
    if nargin < 6
        bath_section(i) = bath(lon_ind,lat_ind); % accept value if maxdistance not specified
        lon_section(i) = lon(lon_ind);
        lat_section(i) = lat(lat_ind);
    elseif sqrt(xdist^2+ydist^2) <= maxdistance % accept value if within maxdistance of available topography
        bath_section(i) = bath(lon_ind,lat_ind);
        lon_section(i) = lon(lon_ind);
        lat_section(i) = lat(lat_ind);
    else
        bath_section(i) = NaN; % reject if not within maxdistance of available topography
        lon_section(i) = NaN;
        lat_section(i) = NaN;
    end
end

% Create reference variable.
if strcmp(xref,'lon')
    xvar = lon_section;   
elseif strcmp(xref,'lat')
    xvar = lat_section;   
elseif any(~isnan(time_section))
    xvar = time_section;
else
    disp(['xref should be ''lon'' ''lat'' or a time vector of length ',num2str(N)]);  
    return
end

% Order bathymetry data by reference variable and plot.
[xvar,xvar_inds] = sort(xvar);
bath_section = bath_section(xvar_inds);
lon_section = lon_section(xvar_inds);
lat_section = lat_section(xvar_inds);
time_section = time_section(xvar_inds);

% Remove NaNs.
good_inds = find(~isnan(bath_section));
bath_section = bath_section(good_inds);
lon_section = lon_section(good_inds);
lat_section = lat_section(good_inds);
time_section = time_section(good_inds);
xvar = xvar(good_inds);

% Plot.
hold on
plot(xvar,bath_section,'k','LineWidth',4)
if filled ==1
    basevalue = min(bath_section);
    area(xvar,bath_section,basevalue,'FaceColor','k')
    ylim([min(bath_section) 10])
end
set(gca, 'Children',flipud(get(gca, 'Children'))) % send bathymetry to back
hold off
end