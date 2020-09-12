
function [vke] = whp_cruise_vke(wvke_dir)
% This loads energy-related vertical LADCP data for whp_cruise_build
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 14-Jul-2020
% See also whp_cruise_build.

    base_list = {'station','depth','p0','eps_VKE'}; 
    nvar = length(base_list);

    full_path = dir([wvke_dir '*VKEprof.nc']);
    if isempty(full_path)
        disp([newline, 'Warning: No matching LADCP VKE files in path ',wvke_dir, newline])
    end
    vke = cell2table(cell(0,nvar)); % Make an empty table to hold profile data.
    vke.Properties.VariableNames = base_list; 
    for i = 1:length(full_path) % For each file in full_path...
        filename = [full_path(i).folder '/' full_path(i).name];
        nc = netcdf.open(filename, 'NOWRITE'); % Open the file as a netcdf datasource. 
        try
            cast_cell = cell(1,nvar);
            for var = 1:nvar
                if strcmp(base_list{var},'station')
                    cast_cell{var}  = str2double(filename(end-13:end-11)); % get station from filename 
                else
                    cast_cell{var} = netcdf.getVar(nc,netcdf.inqVarID(nc,strrep(base_list{var},'_','.')));
                end
            end
            vke = [vke;cast_cell]; % Combine CTDTMPorary cell array with general datatable.
        catch
            disp(['Cannot read ', full_path(i).name])
        end
        netcdf.close(nc); % Close the file.  
    end
    
    % rename to avoid conflict with w
    vke.Properties.VariableNames{'depth'} = 'depth_vke';

end
