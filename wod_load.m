%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 15-Jun-2020
%  Distributed under the terms of the MIT License

function [wod] = wod_load(wod_dir)

    wod = cell2table(cell(0,6)); % Make an empty table to hold profile data.
    wod.Properties.VariableNames = {'ALT' 'CTDSAL' 'CTDTMP' 'LAT' 'LON' 'DATE'};  
    full_path = dir(wod_dir);
    for i = 1:length(full_path) % For each file in full_path...
         filename = [full_path(i).folder '/' full_path(i).name];
        nc = netcdf.open(filename, 'NOWRITE'); % Open the file as a netcdf datasource.
            try % Try to read the file.
            LAT = netcdf.getVar(nc,netcdf.inqVarID(nc,'lat'));
            LON = netcdf.getVar(nc,netcdf.inqVarID(nc,'lon'));
            CTDTMP = netcdf.getVar(nc,netcdf.inqVarID(nc,'Temperature'));
            CTDSAL = netcdf.getVar(nc,netcdf.inqVarID(nc,'Salinity'));
            ALT = netcdf.getVar(nc,netcdf.inqVarID(nc,'z'));
            DATE = netcdf.getVar(nc,netcdf.inqVarID(nc,'date'));

            station_table = {ALT, CTDSAL, CTDTMP, LAT, LON, DATE};
            wod = [wod;station_table]; % Combine temporary cell array with general datatable.
            catch ME % Throw an exception if unable to read file.
            ME
            end    
        netcdf.close(nc); % Close the file.  

    end

end