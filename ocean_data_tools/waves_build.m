
function [waves] =  waves_build(source,xcoords,ycoords,dates)
% waves_builds builds a struct of timeseries from CMEMS Global Ocean Waves 
% Multi Year product (GLOBAL_REANALYSIS_WAV_001_032)
%% Syntax
% 
% [waves] =  waves_build(source,xcoords,ycoords,dates)
%
%% Description 
% 
% [waves] =  waves_build(source,xcoords,ycoords,dates)
% builds a struct of timeseries from CMEMS Global Ocean Waves 
% Multi Year product (GLOBAL_REANALYSIS_WAV_001_032), pulling points
% nearest to coordinates specified by xcoords and ycoords and times 
% specificed by dates. Profiles are loaded into the struct
% array waves with all avaialble variables.
%
% source (a character array) is the path to a local netcdf file
%
% xcoords and ycoords are vectors of coordinates. Rows or columns are
% fine, and both -180/180 or 0/360 notation are fine.
%
% dates is vector of serial date numbers (days since January 0, 0000) of
% type numeric. Must have length(xcoords).
%
%% Example 1
% Build a time-varying transect from the CMEMS Global Ocean Waves Multi Year product:
% 
% source = '/Users/lnferris/Data/global-reanalysis-wav-001-032_1598893873726.nc'; % local .nc 
% dates = [737015.1, 737016.9, 737017.3, 737018.0, 737019.2]
% xcoords = [-71.2, -71.4, -71.5, -71.7, -71.9]
% ycoords = [35.9, 36.2, 36.4, 36.6, 36.8];
% [waves] =  waves_build(source,xcoords,ycoords,dates)
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Nov 2020; Last revision: 19-Nov-2020
% 
% See also general_remove_duplicates and general_map.


ncoords = length(xcoords);
nc = ncgeodataset(source); 
variable_list = nc.variables;
n = length(variable_list);

% deal with xcoords spanning dateline
east_inds = find(xcoords>180);  
xcoords(east_inds) = xcoords(east_inds)-360;

for i = 1
    
    variable = variable_list{i};
    sv = nc{variable}; % Assign ncgeovariable handle.
    sv.attributes % Print ncgeovariable attributes.
    datestr(sv.timeextent(),29) % Print date range of the ncgeovariable.
    svg = sv.grid_interop(:,:,:,:); % Get standardized (time,z,lat,lon) coordinates for the ncgeovariable.

    % create additional arrays
    w_stn = NaN(1,ncoords);
    w_date = NaN(1,ncoords);
    w_lat = NaN(1,ncoords);
    w_lon = NaN(1,ncoords);
    w_variable = NaN(1,ncoords);

    for cast = 1:ncoords
        disp([variable,' point ',num2str(cast),' of ',num2str(ncoords)])

        [lon_ind,~] = near(svg.lon,xcoords(cast));
        [lat_ind,~] = near(svg.lat,ycoords(cast));
        [tin,~] = near(svg.time,dates(cast));

        w_stn(cast) = cast;
        w_date(cast) = svg.time(tin);
        w_lon(cast) = svg.lon(lon_ind);
        w_lat(cast) = svg.lat(lat_ind);
        w_variable(cast) = sv.data(tin,lat_ind,lon_ind);

        if ismember(cast,east_inds)
            w_lon(cast) = wlon(cast)+360; 
        end

    end  

    waves = struct('stn',w_stn,'date', w_date, 'lon', w_lon,'lat', w_lat, variable, w_variable);

end

    % pickup additonal variables

    if n > 1     
        for i = 2:n
            
            variable = variable_list{i};
            if ~(strcmp(variable,'longitude') || strcmp(variable,'latitude') || strcmp(variable,'time')) 
                sv = nc{variable}; % Assign ncgeovariable handle
                svg = sv.grid_interop(:,:,:,:); % Get standardized (time,z,lat,lon) coordinates for the ncgeovariable.

                w_variable = NaN(1,ncoords);
                for cast = 1:ncoords
                    disp([variable,' profile ',num2str(cast),' of ',num2str(ncoords)])
                    [lon_ind,~] = near(svg.lon,xcoords(cast));
                    [lat_ind,~] = near(svg.lat,ycoords(cast));
                    [tin,~] = near(svg.time,dates(cast));
                    w_variable(cast) = sv.data(tin,lat_ind,lon_ind);
                end

                waves.(variable) =  w_variable;
            end
        end  
    end

end