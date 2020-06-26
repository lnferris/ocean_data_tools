%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 26-Jun-2020
%  Distributed under the terms of the MIT License

function [wod] = wod_build(wod_dir,variable_list)

    base_list = {'lon','lat','date','z'}; % Variables automatically included.
    variable_list(ismember(variable_list, base_list )) = []; % remove redundant vars
    variable_list = [base_list variable_list];
    nvar = length(variable_list);
    
    wod_table = cell2table(cell(0,nvar)); % Make an empty table to hold profile data.
    wod_table.Properties.VariableNames = variable_list;  
    full_path = dir(wod_dir);
    
    for i = 1:length(full_path) % For each file in full_path...
        filename = [full_path(i).folder '/' full_path(i).name];
        nc = netcdf.open(filename, 'NOWRITE'); % Open the file as a netcdf datasource.
        
        try % Try to read the file.
            cast_table = cell(1,nvar);
            
            for var = 1:nvar
                if strcmp(variable_list{var},'date')
                    cast_table{var}  = datenum(num2str(netcdf.getVar(nc,netcdf.inqVarID(nc,variable_list{var}))),'yyyymmdd');   
                else
                    cast_table{var} = netcdf.getVar(nc,netcdf.inqVarID(nc,variable_list{var}));
                end
            end

            wod_table = [wod_table;cast_table]; % Combine CTDTMPorary cell array with general datatable.
        catch ME % Throw an exception if unable to read file.
            ME;
        end    
        netcdf.close(nc); % Close the file.  

    end
   
% find necessary array dimensions
prof_dim = height(wod_table);
var_dim = width(wod_table);
z_dim = 0;
is_matrix = zeros(1,var_dim);
for prof = 1:height(wod_table)   
    for var = 1:var_dim
        try
            if length(wod_table.(var){prof,:}) > z_dim
                z_dim = length(wod_table.(var){prof,:});
            end
            is_matrix(var) = 1;
        catch
            is_matrix(var) = 0;
        end
    end
end

% build structured array
wod.stn = NaN(1,prof_dim);
for var = 1:length(variable_list)  
    variable = variable_list{var};
    
    if is_matrix(var)
        wod.(variable) = NaN(z_dim,prof_dim);
    else
        wod.(variable) = NaN(1,prof_dim);
    end
    
end

% load data into structured array

for prof = 1:prof_dim
    
    wod.stn(prof) = prof;
    ind_last = length(wod_table.z{prof,:});
    
    for var = 1:length(variable_list)  
        variable = variable_list{var};
        
        if is_matrix(var)
            wod.(variable)(1:ind_last,prof) = wod_table.(variable){prof,:};
        else
            wod.(variable)(prof) = wod_table.(variable)(prof);
        end
    end
    
end

% rename the depth variable depth
wod.depth = wod.z;
wod = rmfield(wod,'z');

end