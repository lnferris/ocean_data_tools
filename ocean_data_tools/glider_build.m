             
function [glider] = glider_build(glider_dir,variable_list)
% glider_build loads data (a single netcdf file downloaded from gliders.ioos.us/erddap)
% from glider_dir into uniform struct glider
%
%% Syntax
% 
% [glider] = glider_build(glider_dir)
% [glider] = glider_build(glider_dir,variable_list)
%
%% Description 
% 
% [glider] = glider_build(glider_dir,variable_list) loads data from glider_dir
% into struct array glider. Glider profiles are loaded into the struct with all
% variables specified in variable_list. 
%
% The only required argument is glider_dir. The default state is to load the following
% science variables:
% 
% 'profile_id'
% 'time'
% 'latitude'
% 'longitude'
% 'precise_time'
% 'depth'
% 'pressure'
% 'temperature'
% 'conductivity'
% 'salinity'
% 'density'
% 'precise_lat'
% 'precise_lon'
% 'time_uv'
% 'lat_uv',
% 'lon_uv'
% 'u'
% 'v' 
%
% This default list can be overridden by passing a user-defined
% variable_list, a cell array where each element is the
% string name of a variable.
%
% glider_dir is a character array search path to a single netcdf file 
% downloaded from gliders.ioos.us/erddap). The path
% should be the path to the netcdf file itself, not its directory. 
%
%% Example 1
%
% Get variable information:
% 
% glider_dir = '/Users/lnferris/Desktop/ce_311-20170725T1930.nc';  % included
% ncdisp(glider_dir) % Peek at netCDF header info to inform choice of variable_list.
% 
% Load glider data:
%              
% [glider] = glider_build(glider_dir);    
% 
% Plot profiles:
% 
% figure
% general_map(glider,bathymetry_dir)
% 
% figure
% general_section(glider,'salinity','km','depth')
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Sep 2020; Last revision: 23-Sep-2020
% 
% See also general_section and general_region_subset.

if nargin < 2
    
    variable_list = {'profile_id','time','latitude','longitude','precise_time',...
                    'depth','pressure','temperature','conductivity','salinity',...
                    'density','precise_lat','precise_lon','time_uv','lat_uv',...
                    'lon_uv','u','v'};     
end
                         
for var = 1:length(variable_list)
    variable = variable_list{var};
    glider_data.(variable) = ncread(glider_dir,variable);
end

nvar = length(variable_list);
glider_cell = cell(0,nvar);
profile_tags = unique(glider_data.profile_id);

for tag = 1:length(profile_tags)   
    profile_cell= cell(1,nvar);
    for var = 1:nvar
        variable = variable_list{var};
        profile_cell{var} = glider_data.(variable)(glider_data.profile_id==profile_tags(tag));
    end  
    glider_cell = [glider_cell;profile_cell];
end

% find necessary array dimensions
[sz1,sz2] = cellfun(@size,glider_cell);
z_dim = max(max([sz1,sz2]));
prof_dim = size(glider_cell,1);
var_dim = size(glider_cell,2);
is_matrix = sz1(1,:)~=1;

% load data into structured array
glider.stn = 1:prof_dim;
for var = 1:var_dim
    variable = variable_list{var};
    if is_matrix(var)
        glider.(variable) = NaN(z_dim,prof_dim);
    else
        glider.(variable) = NaN(1,prof_dim);
    end 

    for prof = 1:prof_dim
        ind_last = sz1(prof,var);  
        dat = glider_cell(prof,var);
        if is_matrix(var)
            glider.(variable)(1:ind_last,prof) = dat{:};
        else
            glider.(variable)(prof) = dat{:};
        end 
    end
end

% collapse field if single value
fns = fieldnames(glider);
for field = 1:var_dim 
    collapse = 1;
    for prof = 1:prof_dim    
        if ~all(glider.(fns{field})(:,prof)==glider.(fns{field})(1,prof) | isnan(glider.(fns{field})(:,prof)))
            collapse = 0;
            break
        end 
    end
    if collapse==1
        glider.(fns{field}) = glider.(fns{field})(1,:);
    end
end


% rename variables to work with general_ functions
glider.lon = glider.longitude;
glider.lat = glider.latitude;
glider = rmfield(glider,{'longitude','latitude'});

end
