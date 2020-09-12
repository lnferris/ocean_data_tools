
function [mocha] = mocha_build_profiles(month,xcoords,ycoords,zgrid)
% mocha_build_profiles builds a struct of profiles from the MOCHA Mid-Atlantic Bight climatology
% 
%% Syntax
% 
% [mocha] = mocha_build_profiles(month,xcoords,ycoords)
% [mocha] = mocha_build_profiles(month,xcoords,ycoords,zgrid)
%
%% Description 
% 
% [mocha] = mocha_build_profiles(month,xcoords,ycoords) builds a uniform
% struct, mocha, of profiles from the MOCHA Mid-Atlantic Bight climatology, pulling
% profiles nearest to coordinates specified by xcoords and ycoords. The
% calendar month is specified by month.
%
% [mocha] = mocha_build_profiles(month,xcoords,ycoords,zgrid) depth-interpolates
% the profiles to a vertical grid of zgrid, in meters. zgrid=2 would
% produce profiles interpolated to 2 meter vertical grid.
%
% xcoords and ycoords are vectors of coordinates. Rows or columns are
% fine, and both -180/180 or 0/360 notation are fine 
%
% month is an integer between 1 (January) and 12 (December).
%
%% Example 1
% Build a struct out of a transect through MOCHA climatology:
% 
% month = 10; % Month (1 through 12).
% xcoords = [-71.2, -71.4, -71.5, -71.7, -71.9];
% ycoords = [35.9, 36.2, 36.4, 36.6, 36.8];
% zgrid = 1; % vertical grid for linear interpolation in meters
% [mocha] = mocha_build_profiles(month,xcoords,ycoords,zgrid); % zgrid optional, no interpolation if unspecified
%
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 05-Jul-2020
% 
% See also mocha_simple_plot and mocha_domain_plot.

assert(isnumeric(month) & length(month)==1,'Error: month must be an integer corresponding to calendar month.');
assert(length(xcoords)==length(ycoords),'Error: xcoords and ycoords must be the same length.');

xcoords(xcoords>180) = xcoords(xcoords>180)- 360;
xcoords(xcoords<-180) = xcoords(xcoords<-180)+360;

variable_list = {'temperature','salinity'};
n = length(variable_list);
ncoords = length(xcoords);

url = 'http://tds.marine.rutgers.edu/thredds/dodsC/other/climatology/mocha/MOCHA_v3.nc';
nc = ncgeodataset(url); % Assign a ncgeodataset handle.
disp([ newline 'List of available variables:'])
nc.variables % Print list of available variables. 


for i = 1
    
    variable = variable_list{i};
    sv = nc{variable}; % Assign ncgeovariable handle: 'climatology_bounds' 'temperature' 'salinity' 'time' 'latitude' 'longitude' 'depth'
    disp([ newline 'List of variable attributes:'])
    sv.attributes % Print ncgeovariable attributes. % Print ncgeovariable attributes.
    svg = sv.grid_interop(:,:,:,:); % Get standardized (lat,lon,dep,time) coordinates for the ncgeovariable.
    data = squeeze(double(sv.data(month,:,:,:)));

    % densify depth levels
    interpolation = 0;
    if nargin > 3   
        hdepth(:) = svg.z(1):-zgrid:svg.z(end);
        interpolation = 1;
    else
        hdepth(:) = svg.z(:);
    end

    % create additional arrays
    hstn = NaN(1,ncoords);
    hlat = NaN(1,ncoords);
    hlon = NaN(1,ncoords);
    hvariable = NaN(length(hdepth),ncoords);

    for cast = 1:ncoords
        disp([variable,' profile ',num2str(cast),' of ',num2str(ncoords)])

        error = sqrt((svg.lon-xcoords(cast)).^2 + (svg.lat-ycoords(cast)).^2);
        mindiff = min(min(error));

        [row,col] = find(error==mindiff);

        % interpolate cast
        hstn(cast) = cast;
        hlon(cast) = svg.lon(row,col);
        hlat(cast) = svg.lat(row,col);
        
        if interpolation
            hvariable(:,cast) = interp1(svg.z(:),data(:,row,col),hdepth,'linear');
        else
            hvariable(:,cast) = data(:,row,col);
        end
        
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
        
        hvariable = NaN(length(hdepth),ncoords);
        for cast = 1:ncoords
            disp([variable,' profile ',num2str(cast),' of ',num2str(ncoords)])

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

