
function [wod] = wod_build(wod_dir,variable_list)
% wod_build searches path wod_dir for relevant profiles and loads them
% into struct wod
% 
%% Syntax
% 
% [wod] = wod_build(wod_dir,variable_list)
% 
%% Description 
% 
% wod_build(wod_dir,variable_list) loads profiles in path wod_dir into the struct
% wod with all variables specified in variable_list. Variables lon, lat, date, z
% are included automatically.
% 
% wod_dir is a character array search path with wildcards. The search path
% should be the path to the netcdf files themselves, not their directory. 
%
% wod is a uniform struct containing data from profiles in the path.
% Some data is included automatically while some 
% must be specified. The variables lon, lat, date, and z are included 
% automatically. Additional variables must be specified in variable_list, 
% a cell array where each element is the string name of a variable.
%
%% Example 1
% Load World Ocean Database data:
% 
% wod_dir = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/wod/*.nc'; % included
% listing = dir(wod_dir); % Peek at netCDF header info to inform choice of variable_list.
 %ncdisp([listing(1).folder '/' listing(1).name])
% variable_list = {'Temperature','Salinity'}; % Variables to read (besides lon, lat, date, z).
% [wod] = wod_build(wod_dir,variable_list);
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 27-Jun-2020
% 
% See also general_profiles and general_region_subset.

    base_list = {'lon','lat','date','z'}; % Variables automatically included.
    variable_list(ismember(variable_list, base_list )) = []; % remove redundant vars
    variable_list = [base_list variable_list];
    nvar = length(variable_list);
    
    wod_cell = cell(0,nvar); % Make an empty table to hold profile data.
    full_path = dir(wod_dir);
    
    for i = 1:length(full_path) % For each file in full_path...
        filename = [full_path(i).folder '/' full_path(i).name];
        nc = netcdf.open(filename, 'NOWRITE'); % Open the file as a netcdf datasource.
        
        try % Try to read the file.
            cast_cell = cell(1,nvar);
            
            for var = 1:nvar
                if strcmp(variable_list{var},'date')
                    cast_cell{var}  = datenum(num2str(netcdf.getVar(nc,netcdf.inqVarID(nc,variable_list{var}))),'yyyymmdd');   
                else
                    cast_cell{var} = netcdf.getVar(nc,netcdf.inqVarID(nc,variable_list{var}));
                end
            end

            wod_cell = [wod_cell;cast_cell]; % Combine CTDTMPorary cell array with general datatable.
        catch ME % Throw an exception if unable to read file.
            ME;
        end    
        netcdf.close(nc); % Close the file.  

    end
    
    % find necessary array dimensions
    [sz1,sz2] = cellfun(@size,wod_cell);
    z_dim = max(max([sz1,sz2]));
    prof_dim = size(wod_cell,1);
    var_dim = size(wod_cell,2);
    is_matrix = sz1(1,:)~=1;

    % load data into structured array
    wod.stn = NaN(1,prof_dim);
    for var = 1:var_dim
        variable = variable_list{var};
        if is_matrix(var)
            wod.(variable) = NaN(z_dim,prof_dim);
        else
            wod.(variable) = NaN(1,prof_dim);
        end 

        for prof = 1:prof_dim
            ind_last = sz1(prof,var);  
            dat = wod_cell(prof,var);
            if is_matrix(var)
                wod.(variable)(1:ind_last,prof) = dat{:};
            else
                wod.(variable)(prof) = dat{:};
            end 
        end
    end
    
    % rename the depth variable depth
    wod.depth = wod.z;
    wod = rmfield(wod,'z');
    
    % if working near dateline wrap to 0/360
    if min(wod.lon) < -170 && max(wod.lon)>170  
        wod.lon(wod.lon < 0) = wod.lon(wod.lon < 0)+360; 
    end  

end
