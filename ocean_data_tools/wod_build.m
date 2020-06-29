%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 27-Jun-2020
%  Distributed under the terms of the MIT License

function [wod] = wod_build(wod_dir,variable_list)

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