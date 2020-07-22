
function [uv,uv_meta] = whp_cruise_uv(uv_dir)
% This loads horizontal LADCP data for whp_cruise_build
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 14-Jul-2020
% See also whp_cruise_build.

    base_list = {'station','z','ctd_s','ctd_t','p','u','v'}; 
    meta_list = {'station','lat','lon','date'};
    nvar = length(base_list);
    nmeta = length(meta_list);

    full_path = dir(uv_dir);
    
    uv = cell2table(cell(0,nvar)); % Make an empty table to hold profile data.
    uv_meta = cell2table(cell(0,nmeta)); % Make an empty table to hold profile data.
    uv.Properties.VariableNames =  base_list;  
    uv_meta.Properties.VariableNames =  meta_list; 
    
    for i = 1:length(full_path) % For each file in full_path...
        filename = [full_path(i).folder '/' full_path(i).name];
        nc = netcdf.open(filename, 'NOWRITE'); % Open the file as a netcdf datasource. 
        try
            
            cast_cell = cell(1,nvar);
            for var = 1:nvar
                if strcmp(base_list{var},'station')
                    cast_cell{var}  =  str2double(filename(end-5:end-3));  % get station from filename 
                else
                    cast_cell{var} = netcdf.getVar(nc,netcdf.inqVarID(nc,base_list{var}));
                end
            end
            uv = [uv;cast_cell]; % Combine temporary cell array with general datatable.
            
            meta_cell = cell(1,nmeta);
            for var = 1:nmeta
                if strcmp(meta_list{var},'station')
                   meta_cell{var} = str2double(filename(end-5:end-3));  % get station from filename 
                elseif strcmp(meta_list{var},'date')
                    meta_cell{var}  =  datenum(double(reshape(netcdf.getVar(nc,netcdf.inqVarID(nc,meta_list{var})),1,[])));
                else
                    meta_cell{var} = netcdf.getVar(nc,netcdf.inqVarID(nc,meta_list{var}));
                end
            end
            uv_meta = [uv_meta;meta_cell]; % Combine temporary cell array with general datatable.

        catch
            disp(['Cannot read ', full_path(i).name])
        end
        netcdf.close(nc); % Close the file.  
    end

end
