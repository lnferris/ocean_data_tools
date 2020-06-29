
function [ctdo] = whp_cruise_ctdo(ctdo_dir,variable_list)

    base_list = {'station','woce_date','longitude','latitude','pressure'}; % Variables automatically included.
    variable_list(ismember(variable_list, base_list )) = []; % remove redundant vars
    variable_list = [base_list variable_list];
    nvar = length(variable_list);

    full_path = dir(ctdo_dir);
    ctdo = cell2table(cell(0,nvar)); % Make an empty table to hold profile data.
    ctdo.Properties.VariableNames = variable_list;  

    for i = 1:length(full_path) % For each file in full_path...
        filename = [full_path(i).folder '/' full_path(i).name]; 
        nc = netcdf.open(filename, 'NOWRITE'); % Open the file as a netcdf datasource.
        try
            cast_cell = cell(1,nvar);
            
            for var = 1:nvar
                if strcmp(variable_list{var},'woce_date')
                    cast_cell{var}  = datenum(num2str(netcdf.getVar(nc,netcdf.inqVarID(nc,variable_list{var}))),'yyyymmdd'); 
                else
                    cast_cell{var} = netcdf.getVar(nc,netcdf.inqVarID(nc,variable_list{var}));
                    if strcmp(variable_list{var},'station')
                        cast_cell{var} = str2double(cast_cell{var});
                    end
                end
            end
            
            ctdo = [ctdo;cast_cell]; % Combine CTDTMPorary cell array with general datatable.
        catch ME % Throw an exception if unable to read file.
            disp(['Cannot read ', full_path(i).name])
        end    
        netcdf.close(nc); % Close the file.  
    end
          
end