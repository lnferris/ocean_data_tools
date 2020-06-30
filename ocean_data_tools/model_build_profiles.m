%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 30-Jun-2020
%  Distributed under the terms of the MIT License
%  Dependencies: nctoolbox

function [model] =  model_build_profiles(source,date,variable_list,xcoords,ycoords)

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
    hdepth(:) = svg.z(1):-1:svg.z(end);

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
        hvariable(:,cast) = interp1(svg.z(:),sv.data(tin,:,lat_ind,lon_ind),hdepth,'linear');
            
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

end