function [w] = whp_cruise_w(wvke_dir)

    full_path = dir([wvke_dir '*wprof.nc']);
    w = cell2table(cell(length(full_path),5)); % Make an empty table to hold profile data.
    w.Properties.VariableNames = {'STN','WDEP','WHAB','DC_W','UC_W'};  
    for i = 1:length(full_path) % For each file in full_path...
        filename = [full_path(i).folder '/' full_path(i).name];
        try
            nc = netcdf.open(filename, 'NOWRITE'); % Open the file as a netcdf datasource. 
            STN = filename(end-11:end-9); 
            WDEP = netcdf.getVar(nc,netcdf.inqVarID(nc,'depth')); % Depth m
            WHAB = netcdf.getVar(nc,netcdf.inqVarID(nc,'hab')); % Height Above Seabed m
            DC_W = netcdf.getVar(nc,netcdf.inqVarID(nc,'dc_w')); % Downcast Vertical Ocean Velocity m/s
            UC_W = netcdf.getVar(nc,netcdf.inqVarID(nc,'uc_w')); % Upcast Vertical Ocean Velocity, m/s, uc_w(depth)
            w{i,:} = {STN, WDEP, WHAB, DC_W, UC_W};
            netcdf.close(nc); % Close the file.  
        catch
            disp(['Cannot read ', full_path(i).name])
        end
    end
    
    % deal with null directory
    if height(w)==0     
        w = cell2table(cell(1,5)); % Make an empty table to hold profile data.
        w.Properties.VariableNames = {'STN','WDEP','WHAB','DC_W','UC_W'};  
        w{1,:} = {'1', NaN, NaN, NaN,NaN};
    end  

end