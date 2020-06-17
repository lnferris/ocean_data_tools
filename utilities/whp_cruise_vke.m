function [vke] = whp_cruise_vke(wvke_dir)

    full_path = dir([wvke_dir '*VKEprof.nc']);
    vke = cell2table(cell(length(full_path),5)); % Make an empty table to hold profile data.
    vke.Properties.VariableNames = {'STN','VKEDEP','VKEHAB','P0','EPS'}; 
    for i = 1:length(full_path) % For each file in full_path...
        filename = [full_path(i).folder '/' full_path(i).name];
        try
            nc = netcdf.open(filename, 'NOWRITE'); % Open the file as a netcdf datasource.
            STN = num2str(str2double(filename(end-13:end-11)));  
            VKEDEP = netcdf.getVar(nc,netcdf.inqVarID(nc,'depth')); % Window Center Depth, m
            VKEHAB = netcdf.getVar(nc,netcdf.inqVarID(nc,'hab')); % Window Center Height Above Seabed
            P0 = netcdf.getVar(nc,netcdf.inqVarID(nc,'p0')); % Normalized VKE Density, W/kg
            EPS = netcdf.getVar(nc,netcdf.inqVarID(nc,'eps.VKE')); % Turbulent Kinetic Energy Dissipation from Finescale VKE Parameterization
            vke{i,:} = {STN, VKEDEP, VKEHAB, P0, EPS};
            netcdf.close(nc); % Close the file.  
        catch
            disp(['Cannot read ', full_path(i).name])
        end
    end
    
    % deal with null directory
    if height(vke)==0     
        vke = cell2table(cell(1,5)); % Make an empty table to hold profile data.
        vke.Properties.VariableNames = {'STN','VKEDEP','VKEHAB','P0','EPS'};  
        vke{1,:} = {'1', NaN, NaN, NaN,NaN};
    end     
end