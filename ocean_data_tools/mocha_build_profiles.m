%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 28-Jun-2020
%  Distributed under the terms of the MIT License
%  Dependencies: nctoolbox

function [mocha] = mocha_build_profiles(month,xcoords,ycoords)

variable_list = {'temperature','salinity'};
n = length(variable_list);

url = 'http://tds.marine.rutgers.edu/thredds/dodsC/other/climatology/mocha/MOCHA_v3.nc';
nc = ncgeodataset(url); % Assign a ncgeodataset handle.
nc.variables % Print list of available variables. 


for i = 1
    
    variable = variable_list{i};
    sv = nc{variable}; % Assign ncgeovariable handle: 'climatology_bounds' 'temperature' 'salinity' 'time' 'latitude' 'longitude' 'depth'
    sv.attributes % Print ncgeovariable attributes. % Print ncgeovariable attributes.
    svg = sv.grid_interop(:,:,:,:); % Get standardized (lat,lon,dep,time) coordinates for the ncgeovariable.

    data = squeeze(double(sv.data(month,:,:,:)));

    % densify depth levels
    hdepth(:) = svg.z(1):-1:svg.z(end);

    % create additional arrays
    hstn = NaN(1,length(xcoords));
    hlat = NaN(1,length(xcoords));
    hlon = NaN(1,length(xcoords));
    hvariable = NaN(length(hdepth),length(xcoords));

    for cast = 1:length(xcoords)

        error = sqrt((svg.lon-xcoords(cast)).^2 + (svg.lat-ycoords(cast)).^2);
        mindiff = min(min(error));

        [row,col] = find(error==mindiff);

        % interpolate cast
        hstn(cast) = cast;
        hlon(cast) = svg.lon(row,col);
        hlat(cast) = svg.lat(row,col);
        hvariable(:,cast) = interp1(svg.z(:),data(:,row,col),hdepth,'linear');

    end

    mocha = struct('stn', hstn, 'lon', hlon,'lat', hlat,'depth',hdepth.', variable, hvariable);
    
end
% pickup additonal variables

if n > 1     
    for i = 2:n
    
        variable = variable_list{i};
        sv = nc{variable}; % Assign ncgeovariable handle
        svg = sv.grid_interop(:,:,:,:); % Get standardized (time,z,lat,lon) coordinates for the ncgeovariable.
        data = squeeze(double(sv.data(month,:,:,:)));
        
        hvariable = NaN(length(hdepth),length(xcoords));
        for cast = 1:length(xcoords)

            error = sqrt((svg.lon-xcoords(cast)).^2 + (svg.lat-ycoords(cast)).^2);
            mindiff = min(min(error));

            [row,col] = find(error==mindiff);

            % interpolate cast
            hstn(cast) = cast;
            hlon(cast) = svg.lon(row,col);
            hlat(cast) = svg.lat(row,col);
            hvariable(:,cast) = interp1(svg.z(:),data(:,row,col),hdepth,'linear');

        end

        mocha.(variable) =  hvariable;
        
    end  
end

end

