
function [bath_section,lon_section,lat_section,time_section] = bathymetry_section(bathy,xcoords,ycoords,xref,filled)
% bathymetry_section adds global seafloor topography (Smith & Sandwell, 1997) to an existing section
% plot using specified coordinates
% 
%% Syntax
% 
%  [bath_section,lon_section,lat_section,time_section] = bathymetry_section(bathy,xcoords,ycoords,xref)
%  [bath_section,lon_section,lat_section,time_section] = bathymetry_section(bathy,xcoords,ycoords,xref,filled)
% 
%% Description 
% 
% [bath_section,lon_section,lat_section] =
% bathymetry_section(bathy,xcoords,ycoords,xref) makes a section plot from 
% bathy, where bathy is a struct of Smith & Sandwell Global Topography created
% using bathymetry_extract. xcoords (longitude) and ycoords (latitude) are
% densified to a 1/60-deg grid before bathymetry is interpolated. The bathymetry section is
% plotted against xref; where xref = 'lon', 'lat','km', or a time vector of length(xcoords). The
% extracted data is output bath_section, lon_section, lat_section, and time_section; 
% output vectors are sorted by the selected reference axis (longitude,
% latitude, or time).
%  
% [bath_section,lon_section,lat_section] =
% bathymetry_section(bathy,xcoords,ycoords,xref,filled) allows the
% bathymetry to be filled in black down to the x-axis (instead of a simple line).
% Set filled=1 to turn on, filled=0 to turn off.
%
% xcoords and ycoords are vectors of coordinates. Rows or columns are
% fine, and both -180/180 or 0/360 notation are fine.
%
% When xref is a time vector, it must be of length(xcoords) and elements of
% the vector must be datenums. Otherwise set xref = 'lon' or  xref = 'lat'.
% Alteratively pass xref = 'km' to plot in along-track distance, assuming 
% spherical earth. 
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
% [bathy] = bathymetry_extract(bathymetry_dir,bounding_region(cruise));
% bathymetry_section(bathy,xcoords,ycoords,xref,filled)
%
%% Example 2
% Plot bathymetry nearest to a list of coordinates. Use latitude as the x-axis:
% 
% xref = 'lat'; 
% xcoords = [60 60.1 60.4 60.2 59.9]; 
% ycoords = [10 20.1 15.0 16.1 13.7]; 
% [bathy] = bathymetry_extract(bathymetry_dir,bounding_region([],xcoords,ycoords));
% figure
% bathymetry_section(bathy,xcoords,ycoords,xref)
%
%% Example 3
% Plot bathymetry nearest to a list of coordinates. Use a time as the x-axis:
% 
% xref = [737009 737010 737011 737012 737013]; 
% xcoords = [60 60.1 60.4 60.2 59.9]; 
% ycoords = [10 20.1 15.0 16.1 13.7]; 
% [bathy] = bathymetry_extract(bathymetry_dir,bounding_region([],xcoords,ycoords));
% figure
% bathymetry_section(bathy,xcoords,ycoords,xref)
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 08-Sep-2020
% 
% See also general_section, bathymetry_extract, and bounding_region.

if nargin < 5
    filled = 0;
end

assert(isstruct(bathy),'Error: bathy must be a structure array created using bathymetry_extract.');


% Load bathymetry data.
bath = bathy.z;
lat = bathy.lat;
lon = bathy.lon;

% % Auto-select region and load bathymetry data.
region = [min(ycoords)-1 max(ycoords)+1 min(xcoords)-1 max(xcoords)+1];

% Deal with inputs other than [-90 90 -180 180] e.g  [-90 90 20 200] 
region(region>180) = region(region>180)- 360;
region(region<-180) = region(region<-180)+360;

% Format bathymetry that crossed a line.
if region(3) > region(4) && region(3) < 0 && region(4)+360>180    
    lon(lon>360) = lon(lon>360)-360;
    [lon,lon_inds] = sort(lon);
    bath = bath(lon_inds,:);  
end

% Get interpolated bathymetry values.
[lat_section, lon_section] = interpm(ycoords, xcoords, 1/60);
bath_section = interp2(lon,lat,bath',lon_section,lat_section, 'nearest');

% Interpolate times if provided, or else just set lat/lon to be xvar.
if length(xref)== length(xcoords)
    F = scatteredInterpolant(xcoords,ycoords,xref);
    time_section = F(lon_section,lat_section);
    xvar = time_section;
else
    time_section = NaN(length(bath_section),1);
    if strcmp(xref,'lon')
        xvar = lon_section;   
    elseif strcmp(xref,'lat')
        xvar = lat_section;  
    elseif strcmp(xref,'km')
        
         % displacements between stations in degrees
        ddeg = zeros(size(lon_section));
        for prof = 1:length(lon_section)-1
            [ddeg(prof+1),~] = distance(lat_section(prof),lon_section(prof),lat_section(prof+1),lon_section(prof+1));
        end
        
        % convert degrees to kilometers
        dkm = deg2km(ddeg);
        
        % sum previous displacements at each station
        km = NaN(size(lon_section));
        for prof = 1:length(lon_section)
            km(prof) = sum(dkm(1:prof));
        end
        xvar = km;    
        
    else
        disp(['xref should be ''lon'', ''lat'',''km'', or a time vector of length ',num2str(length(xcoords))]);  
        return
    end
end

% Order bathymetry_section by xref.
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
hold off
end
