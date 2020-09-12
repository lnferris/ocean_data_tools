
function [w,w_meta] = whp_cruise_w(wvke_dir)
% This loads velocity-related vertical LADCP data for whp_cruise_build
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 14-Jul-2020
% See also whp_cruise_build.

    base_list = {'station','depth','dc_w'}; 
    meta_list = {'station','latitude','longitude','date'};
    nvar = length(base_list);
    nmeta = length(meta_list);

    full_path = dir([wvke_dir '*wprof.nc']);
    if isempty(full_path)
        disp([newline, 'Warning: No matching LADCP W files in path ',wvke_dir, newline])
    end

    w = cell2table(cell(0,nvar)); % Make an empty table to hold profile data.
    w_meta = cell2table(cell(0,nmeta)); % Make an empty table to hold profile data.
    w.Properties.VariableNames = base_list; 
    w_meta.Properties.VariableNames =  meta_list; 
    
    for i = 1:length(full_path) % For each file in full_path...
        filename = [full_path(i).folder '/' full_path(i).name];
        nc = netcdf.open(filename, 'NOWRITE'); % Open the file as a netcdf datasource. 
        try
            cast_cell = cell(1,nvar);
            for var = 1:nvar
                if strcmp(base_list{var},'station')
                    cast_cell{var}  =  str2double(filename(end-11:end-9)); % get station from filename 
                else
                    cast_cell{var} = netcdf.getVar(nc,netcdf.inqVarID(nc,base_list{var}));
                end
            end
            w = [w;cast_cell]; % Combine CTDTMPorary cell array with general datatable.
            
            meta_cell = cell(1,nmeta);
            for var = 1:nmeta
                if strcmp(meta_list{var},'station')
                    meta_cell{var}  =  str2double(filename(end-11:end-9)); % get station from filename 
                elseif strcmp(meta_list{var},'date')
                    meta_cell{var} = datenum(ncreadatt(filename,'/',meta_list{var}),'yyyy/mm/dd');
                else
                    meta_cell{var} = ncreadatt(filename,'/',meta_list{var});
                end
            end
            w_meta = [w_meta;meta_cell]; % Combine temporary cell array with general datatable.

        
       catch
            disp(['Cannot read ', full_path(i).name])
       end
        netcdf.close(nc); % Close the file.  
    end

end
