%  Author: Lauren Newell Ferris
%  Institute: Virginia Institute of Marine Science
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  May 2019; Last revision: 26-Jul-2019
%  Distributed under the terms of the MIT License
%  Dependencies: borders.m (C. Greene) for map_datatable(), SSbathymetry() optional


%%                 EXAMPLE SCRIPT
data_directory = '/Users/lnferris/Documents/data/WOD_IndianCTD/'; % Data directory.
extension = '*O.nc';
BasemapLimits = [5.0, 20.0, 40.0, 100.0]; % Dimensions of lat/lon map.


% Get list of relevant netcdf files. Write matching profiles to datatable.
[Hydro_DataTable] = getStations(data_directory,extension);

% Map profiles in datatable.
map_datatable(Hydro_DataTable,BasemapLimits)

% Subset datatable based on platform,day,etc. (see definition).
Small_Table = subset_datatable(Hydro_DataTable);

% Map profiles in datatable.
map_datatable(Small_Table,BasemapLimits)

% Access and plot vertical profile data.
vertical_profile(Small_Table)

%%                    FUNCTIONS

function [Hydro_DataTable] = getStations(data_directory,extension)

Hydro_DataTable = cell2table(cell(0,6)); % Make an empty table to hold profile data.
Hydro_DataTable.Properties.VariableNames = {'ALT' 'CTDSAL' 'CTDTMP' 'LAT' 'LON' 'DATE'};  
full_path = dir([data_directory extension]);
for i = 1:length(full_path) % For each file in full_path...
    filename = full_path(i).name;
    nc = netcdf.open([data_directory filename], 'NOWRITE'); % Open the file as a netcdf datasource.
        try % Try to read the file.
        LAT = netcdf.getVar(nc,netcdf.inqVarID(nc,'lat'));
        LON = netcdf.getVar(nc,netcdf.inqVarID(nc,'lon'));
        CTDTMP = netcdf.getVar(nc,netcdf.inqVarID(nc,'Temperature'));
        CTDSAL = netcdf.getVar(nc,netcdf.inqVarID(nc,'Salinity'));
        ALT = netcdf.getVar(nc,netcdf.inqVarID(nc,'z'));
        DATE = netcdf.getVar(nc,netcdf.inqVarID(nc,'date'));
        
        Station_DataTable = {ALT, CTDSAL, CTDTMP, LAT, LON, DATE};
        Hydro_DataTable = [Hydro_DataTable;Station_DataTable]; % Combine temporary cell array with general datatable.
        catch ME % Throw an exception if unable to read file.
        ME
        end    
    netcdf.close(nc); % Close the file.  

end
end

% map_datatable() plots latitude vs. longitude of profiles over basemap.
function map_datatable(Hydro_DataTable,BasemapLimits)
figure
south = BasemapLimits(1); north = BasemapLimits(2);  % Unpack BasemapLimits.
west = BasemapLimits(3); east = BasemapLimits(4);
borders('countries','facecolor','k')
axis([west east south north])
grid on; grid minor
plot(Hydro_DataTable.LON, Hydro_DataTable.LAT,'.','MarkerSize',14)
end 

% Example of how to subset dataframe based on values in a column.
function [Small_Table] = subset_datatable(Hydro_DataTable)
%rows = (Hydro_DataTable.LON > 92.5 & Hydro_DataTable.LON < 93.1 & Hydro_DataTable.LAT > 13.9 & Hydro_DataTable.LAT < 14.6);
rows = (Hydro_DataTable.DATE > 20180101 & Hydro_DataTable.LAT > 9.5 & Hydro_DataTable.LAT < 10.6);
Small_Table = Hydro_DataTable(rows,:);
end

% Example of how plot salinity vs. depth for each profile in datatable.
function vertical_profile(Hydro_DataTable)
figure 
hold on
for row = 1:height(Hydro_DataTable)    
    psal = cell2mat(Hydro_DataTable.CTDSAL(row,:));
    z = cell2mat(Hydro_DataTable.ALT(row,:));
    plot(psal,-1*z,'.');
end  
figure 
hold on
for row = 1:height(Hydro_DataTable)    
    temp = cell2mat(Hydro_DataTable.CTDTMP(row,:));
    z = cell2mat(Hydro_DataTable.ALT(row,:));
    plot(temp,-1*z,'.');
end 

end
