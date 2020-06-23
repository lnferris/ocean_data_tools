%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 22-Jun-2020
%  Distributed under the terms of the MIT License
%  Dependencies: nctoolbox

function [model] =  model_build_profiles(source,date,variable_list,xcoords,ycoords)

east_inds = find(xcoords>180);  % deal with xcoords spanning dateline
xcoords(east_inds) = xcoords(east_inds)-360;

n = length(variable_list);
nc = ncgeodataset(source); % Assign a ncgeodataset handle.
nc.variables            % Print list of available variables.

for i = 1

    variable = variable_list{i};
    sv = nc{variable}; % Assign ncgeovariable handle
    sv.attributes % Print ncgeovariable attributes.
    datestr(sv.timeextent(),29) % Print date range of the ncgeovariable.
    svg = sv.grid_interop(:,:,:,:); % Get standardized (time,z,lat,lon) coordinates for the ncgeovariable.

    % densify depth levels
    hdepth(:) = svg.z(1):-1:svg.z(end);

    % create additional arrays
    hdate = NaN(1,length(xcoords));
    hlat = NaN(1,length(xcoords));
    hlon = NaN(1,length(xcoords));
    hvariable = NaN(length(hdepth),length(xcoords));

    [tin,~] = near(svg.time,datenum(date,'dd-mmm-yyyy HH:MM:SS'));  % Find time index near date of interest.

    for cast = 1:length(xcoords)

        % get cast
        [lon_ind,~] = near(svg.lon,xcoords(cast));
        [lat_ind,~] = near(svg.lat,ycoords(cast));

        % interpolate cast
        hstn(cast) = cast;
        hdate(cast) = svg.time(tin);
        hlon(cast) = svg.lon(lon_ind);
        hlat(cast) = svg.lat(lat_ind);
        hvariable(:,cast) = interp1(svg.z(:),sv.data(tin,:,lat_ind,lon_ind),hdepth,'linear');

        if ismember(cast,east_inds)
            hlon(cast) = hlon(cast)+360; 
        end

    end

    model = struct('STN', hstn, 'DATE', hdate, 'LON', hlon,'LAT', hlat,'depth',hdepth.', variable, hvariable);

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

        hvariable = NaN(length(hdepth),length(xcoords));
        for cast = 1:length(xcoords)
            [lon_ind,~] = near(svg.lon,xcoords(cast));
            [lat_ind,~] = near(svg.lat,ycoords(cast));
            hvariable(:,cast) = interp1(svg.z(:),sv.data(tin,:,lat_ind,lon_ind),model.depth,'linear');
        end

        model.(variable) =  hvariable;
        
    end  
end
end