%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 16-Jun-2020
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
            wod = [wod;station_table]; % Combine CTDTMPorary cell array with general datatable.
            catch ME % Throw an exception if unable to read file.
            ME
            end    
        netcdf.close(nc); % Close the file.  

    end
    
% find necessary array dimensions
prof_dim = height(wod);
z_dim = 0;
for prof = 1:height(wod)   
    if length(wod.ALT{prof,:}) > z_dim
        z_dim = length(wod.ALT{prof,:});
    end
end

% load table data into arrays
wstn = NaN(1,prof_dim);
wlon = NaN(1,prof_dim);
wlat = NaN(1,prof_dim);
wdate = NaN(1,prof_dim);
wdepth = NaN(z_dim,prof_dim);
wsal = NaN(z_dim,prof_dim);
wtemp = NaN(z_dim,prof_dim);

for prof = 1:prof_dim
    
    ind_last = length(wod.ALT{prof,:});
    wstn(prof) = prof;
    wlon(prof) = wod.LON(prof);
    wlat(prof) = wod.LAT(prof);
    wdate(prof) = wod.DATE(prof);
    wdepth(1:ind_last,prof) = wod.ALT{prof,:};
    wsal(1:ind_last,prof) = wod.CTDSAL{prof,:};
    wtemp(1:ind_last,prof) = wod.CTDTMP{prof,:};
    
end

% output as struct
wod = struct('STN',wstn, 'date',wdate, 'LON',wlon,'LAT',wlat, 'depth',wdepth, 'salinity',wsal, 'temperature',wtemp);

end