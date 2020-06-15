function [uv] = whp_cruise_uv(uv_dir)

    full_path = dir(uv_dir);
    uv = cell2table(cell(length(full_path),4)); % Make an empty table to hold profile data.
    uv.Properties.VariableNames = {'STN','Z','U','V'};  
    for i = 1:length(full_path) % For each file in full_path...
        filename = [full_path(i).folder '/' full_path(i).name];
        try
            if strcmp(filename(end-2:end),'mat')                   % handle .mat files
                STN  = num2str(str2double(filename(end-6:end-4))); 
                load(filename,'-mat');
                Z = dr.z;
                U = dr.u;
                V = dr.v;
            elseif strcmp(filename(end-2:end),'.nc')               % handle .nc files
                STN  = num2str(str2double(filename(end-5:end-3))); 
                nc = netcdf.open(filename, 'NOWRITE'); % Open the file as a netcdf datasource.
                Z = netcdf.getVar(nc,netcdf.inqVarID(nc,'z')); % Depth m
                U = netcdf.getVar(nc,netcdf.inqVarID(nc,'u')); % Depth m
                V = netcdf.getVar(nc,netcdf.inqVarID(nc,'v')); % Depth m
                netcdf.close(nc); % Close the file.
            end
            uv{i,:} = {STN, Z, U, V}; 
        catch
            disp(['Cannot read ', full_path(i).name])
        end
    end
end