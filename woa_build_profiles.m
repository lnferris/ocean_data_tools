%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 16-Jun-2020
%  Distributed under the terms of the MIT License
%  Dependencies: nctoolbox

function [woa] =  woa_build_profiles(variable,xcoords,ycoords)

if strcmp(variable,'temperature')
    
    % World Ocean Atlas 2018 0.25-degree Temperature (degrees Celsius)
    url = 'https://data.nodc.noaa.gov/thredds/dodsC/ncei/woa/temperature/decav/0.25/woa18_decav_t00_04.nc';
    nc = ncgeodataset(url); % Assign a ncgeodataset handle.
    nc.variables % Print list of available variables. 
    sv = nc{'t_an'}; % Assign ncgeovariable handle.
    
elseif strcmp(variable,'salinity')
    
    % World Ocean Atlas 2018 0.25-degree Salinity (psu)
    url = 'https://data.nodc.noaa.gov/thredds/dodsC/ncei/woa/salinity/decav/0.25/woa18_decav_s00_04.nc';
    nc = ncgeodataset(url);
    nc.variables
    sv = nc{'s_an'}; 
    
elseif strcmp(variable,'oxygen')

    % World Ocean Atlas 2018 1-degree Dissolved Oxygen (umol/kg)
    url = 'https://data.nodc.noaa.gov/thredds/dodsC/ncei/woa/oxygen/all/1.00/woa18_all_o00_01.nc';
    nc = ncgeodataset(url);
    nc.variables
    sv = nc{'o_an'}; 

else
    
    disp('Check spelling of variable.');
    
end

    % deal with xcoords spanning dateline
    east_inds = find(xcoords>180);  
    xcoords(east_inds) = xcoords(east_inds)-360;

    % create grid 
    sv.attributes % Print ncgeovariable attributes.
    datestr(sv.timeextent(),29) % Print date range of the ncgeovariable.
    svg = sv.grid_interop(:,:,:,:); % Get standardized (time,z,lat,lon) coordinates for the ncgeovariable.

    % densify depth levels
    wdepth(:) = svg.z(1):-1:svg.z(end);

    % create additional arrays
    wdate = NaN(1,length(xcoords));
    wlat = NaN(1,length(xcoords));
    wlon = NaN(1,length(xcoords));
    wvariable = NaN(round(max(abs(svg.z)))+1,length(xcoords));

    tin = 1; % there is no time dimension in woa climatology

    for cast = 1:length(xcoords)

        % get cast
        [lon_ind,~] = near(svg.lon,xcoords(cast));
        [lat_ind,~] = near(svg.lat,ycoords(cast));
        tracer = sv.data(tin,:,lat_ind,lon_ind);

        % interpolate cast
        wstn(cast) = cast;
        wdate(cast) = svg.time(tin);
        wlon(cast) = svg.lon(lon_ind);
        wlat(cast) = svg.lat(lat_ind);
        wvariable(:,cast) = interp1(svg.z(:),tracer,wdepth,'linear');
        
        if ismember(cast,east_inds)
            wlon(cast) = wlon(cast)+360; 
        end

    end
    
woa = struct('STN', wstn, 'date', wdate, 'LON', wlon,'LAT', wlat,'depth',wdepth.', variable, wvariable);
  
end
