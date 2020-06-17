function [ctdo] = whp_cruise_ctdo(ctdo_dir)

    full_path = dir(ctdo_dir);
    ctdo = cell2table(cell(length(full_path),8)); % Make an empty table to hold profile data.
    ctdo.Properties.VariableNames = {'STN','UTC','LON','LAT','CTDPRS','CTDSAL','CTDTMP','CTDOXY' };  

    for i = 1:length(full_path) % For each file in full_path...
        filename = [full_path(i).folder '/' full_path(i).name]; 
        try
            nc = netcdf.open(filename, 'NOWRITE'); % Open the file as a netcdf datasource.
            STN = netcdf.getVar(nc,netcdf.inqVarID(nc,'station')); 
            UTC = netcdf.getVar(nc,netcdf.inqVarID(nc,'woce_date'));
            LON = double(netcdf.getVar(nc,netcdf.inqVarID(nc,'longitude')));
            LAT = double(netcdf.getVar(nc,netcdf.inqVarID(nc,'latitude')));
            CTDPRS = netcdf.getVar(nc,netcdf.inqVarID(nc,'pressure'));
            CTDSAL = netcdf.getVar(nc,netcdf.inqVarID(nc,'salinity'));
            CTDTMP = netcdf.getVar(nc,netcdf.inqVarID(nc,'temperature'));
            CTDOXY = netcdf.getVar(nc,netcdf.inqVarID(nc,'oxygen')); 
            ctdo{i,:} = {STN, UTC, LON, LAT, CTDPRS, CTDSAL, CTDTMP, CTDOXY};
            netcdf.close(nc); % Close the file.  
        catch
            disp(['Cannot read ', full_path(i).name])
        end
    end


    % deal with null directory
    if height(ctdo)==0     
        ctdo = cell2table(cell(1,8)); % Make an empty table to hold profile data.
        ctdo.Properties.VariableNames = {'STN','UTC','LON','LAT','CTDPRS','CTDSAL','CTDTMP','CTDOXY' }; 
        ctdo{1,:} = {'1', NaN, NaN, NaN, NaN, NaN, NaN, NaN};
    end    

end