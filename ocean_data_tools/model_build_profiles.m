
function [model] =  model_build_profiles(source,date,variable_list,xcoords,ycoords,zgrid)
% model_build_profiles builds a struct of profiles from HYCOM or Operational Mercator
% GLOBAL_ANALYSIS_FORECAST_PHY_001_024
% 
%% Dependencies
%
% nctoolbox
% 
%% Syntax
% 
% [model] = model_build_profiles(source,date,variable_list,xcoords,ycoords)
% [model] =  model_build_profiles(source,date,variable_list,xcoords,ycoords,zgrid)
%
%% Description 
% 
% [model] = model_build_profiles(source,date,variable_list,xcoords,ycoords) 
% builds a struct of profiles from HYCOM or Operational Mercator
% GLOBAL_ANALYSIS_FORECAST_PHY_001_024, pulling profiles nearest to coordinates
% specified by xcoords and ycoords. Profiles are loaded into the struct
% array model with all variables specified in variable_list.
%
% [model] =  model_build_profiles(source,date,variable_list,xcoords,ycoords,zgrid)
% depth-interpolates the profiles to a vertical grid of zgrid, in meters. zgrid=2 would
% produce profiles interpolated to 2 meter vertical grid.
%
%% Example 1
% Build a struct out of a transect through HYCOM, including temperature and salinity:
% 
% model = 'hycom'; % 'hycom' 'mercator'
% source = 'http://tds.hycom.org/thredds/dodsC/GLBv0.08/expt_57.7'; % url or local .nc 
% date = '28-Aug-2017 00:00:00';  
% xcoords = [-71.2, -71.4, -71.5, -71.7, -71.9]
% ycoords = [35.9, 36.2, 36.4, 36.6, 36.8];
% variable_list = {'water_temp','salinity'}; % 'water_u' 'water_v' 'water_temp' 'salinity'
% zgrid = 1; % vertical grid for linear interpolation in meters
% [hycom] =  model_build_profiles(source,date,variable_list,xcoords,ycoords,zgrid); % zgrid optional, no interpolation if unspecified
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 12-Jul-2020
% 
% See also model_simple_plot and model_domain_plot.


ncoords = length(xcoords);

n = length(variable_list);
nc = ncgeodataset(source); % Assign a ncgeodataset handle.
nc.variables            % Print list of available variables.

for i = 1

    variable = variable_list{i};
    sv = nc{variable}; % Assign ncgeovariable handle
    sv.attributes % Print ncgeovariable attributes.
    datestr(sv.timeextent(),29) % Print date range of the ncgeovariable.
    svg = sv.grid_interop(:,:,:,:); % Get standardized (time,z,lat,lon) coordinates for the ncgeovariable.
    
    model360 = all(svg.lon>=0); 
    linecross = 0;
    if model360
        if max(xcoords)>360
            xcoords(xcoords>360) = xcoords(xcoords>360)-360;
            linecross = 1;
        end
    else
        if max(xcoords>180)
            xcoords(xcoords>180) = xcoords(xcoords>180)-360;
            linecross = 1;
        end
    end

    % densify depth levels
    interpolation = 0;
    if nargin > 5   
        hdepth(:) = svg.z(1):-zgrid:svg.z(end);
        interpolation = 1;
    else
        hdepth(:) = svg.z(:);
    end

    % create additional arrays
    hstn = NaN(1,ncoords);
    hdate = NaN(1,ncoords);
    hlat = NaN(1,ncoords);
    hlon = NaN(1,ncoords);
    hvariable = NaN(length(hdepth),ncoords);

    [tin,~] = near(svg.time,datenum(date,'dd-mmm-yyyy HH:MM:SS'));  % Find time index near date of interest.

    for cast = 1:ncoords
        disp([variable,' profile ',num2str(cast),' of ',num2str(ncoords)])

        % get cast
        [lon_ind,~] = near(svg.lon,xcoords(cast));
        [lat_ind,~] = near(svg.lat,ycoords(cast));

        % interpolate cast
        hstn(cast) = cast;
        hdate(cast) = svg.time(tin);
        hlon(cast) = svg.lon(lon_ind);
        hlat(cast) = svg.lat(lat_ind);
        
        if interpolation
            hvariable(:,cast) = interp1(svg.z(:),sv.data(tin,:,lat_ind,lon_ind),hdepth,'linear');
        else
            hvariable(:,cast) = sv.data(tin,:,lat_ind,lon_ind);
        end
            
    end

    model = struct('stn', hstn, 'date', hdate, 'lon', hlon,'lat', hlat,'depth',hdepth.', variable, hvariable);

end  
    
% pickup additonal variables

if n > 1     
    for i = 2:n
    
        variable = variable_list{i};
        sv = nc{variable}; % Assign ncgeovariable handle
        svg = sv.grid_interop(:,:,:,:); % Get standardized (time,z,lat,lon) coordinates for the ncgeovariable.
        
        if  tin ~= near(svg.time,datenum(date,'dd-mmm-yyyy HH:MM:SS'))
            disp('A variable is missing timestep. Please remove from variable_list.')
            return
        end

        hvariable = NaN(length(hdepth),ncoords);
        for cast = 1:ncoords
            disp([variable,' profile ',num2str(cast),' of ',num2str(ncoords)])
            [lon_ind,~] = near(svg.lon,xcoords(cast));
            [lat_ind,~] = near(svg.lat,ycoords(cast));
            hvariable(:,cast) = interp1(svg.z(:),sv.data(tin,:,lat_ind,lon_ind),model.depth,'linear');
        end

        model.(variable) =  hvariable;
        
    end  
end


if ~model360 && linecross
    model.lon(model.lon<0) = model.lon(model.lon<0)+360;
end

if  all(model.lon>180) && all(model.lon<360)
    model.lon = model.lon - 360;
end

end
