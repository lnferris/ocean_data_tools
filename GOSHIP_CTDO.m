%  Author: Lauren Newell Ferris
%  Institute: Virginia Institute of Marine Science
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Aug 2018; Last revision: 10-Jan-2019
%  Distributed under the terms of the MIT License
%  Dependencies: borders.m (C. Greene) for map_datatable(), SSbathymetry() optional

%%                 EXAMPLE SCRIPT

data_directory = '/Users/lnferris/Desktop/33RO20150525/'; % Data directory.
extension = '*.nc';
BasemapLimits = [40.0, 65.0, -155.0, -125.0]; % Dimensions of lat/lon map.

% Get list of relevant netcdf files. Write matching profiles to datatable.
[Hydro_DataTable] = getStations(data_directory,extension);

% Map profiles in datatable.
map_datatable(Hydro_DataTable,BasemapLimits)
SSbathymetry('/Users/lnferris/Desktop/topo_18.1.img',BasemapLimits,'2Dcontour') % Add bathymetry (optional).

% Access and plot vertical profile data.
vertical_profile(Hydro_DataTable)

% Subset datatable based on platform,day,etc. (see definition).
Small_Table = subset_datatable(Hydro_DataTable);

% Map profiles in datatable.
map_datatable(Small_Table,BasemapLimits)
SSbathymetry('/Users/lnferris/Desktop/topo_18.1.img',BasemapLimits,'2Dcontour') % Add bathymetry (optional).

%%                    FUNCTIONS


function [Hydro_DataTable] = getStations(data_directory,extension)

Hydro_DataTable = cell2table(cell(0,7)); % Make an empty table to hold profile data.
Hydro_DataTable.Properties.VariableNames = {'CTDPRS' 'CTDSAL' 'CTDTMP' 'CTDOXY' 'LAT' 'LON' 'UTC'};  
full_path = dir([data_directory extension]);
for i = 1:length(full_path) % For each file in full_path...
    filename = full_path(i).name;
    nc = netcdf.open([data_directory filename], 'NOWRITE'); % Open the file as a netcdf datasource.
        try % Try to read the file.
        LAT = netcdf.getVar(nc,netcdf.inqVarID(nc,'latitude'));
        LON = netcdf.getVar(nc,netcdf.inqVarID(nc,'longitude'));
        CTDTMP = netcdf.getVar(nc,netcdf.inqVarID(nc,'temperature'));
        CTDSAL = netcdf.getVar(nc,netcdf.inqVarID(nc,'salinity'));
        CTDPRS = netcdf.getVar(nc,netcdf.inqVarID(nc,'pressure'));
        CTDOXY = netcdf.getVar(nc,netcdf.inqVarID(nc,'oxygen'));
        UTC = netcdf.getVar(nc,netcdf.inqVarID(nc,'woce_date'));
        
        Station_DataTable = {CTDPRS, CTDSAL, CTDTMP, CTDOXY, LAT, LON, UTC};
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
borders('countries','facecolor','k','nomap')
axis([west east south north])
grid on; grid minor
plot(Hydro_DataTable.LON, Hydro_DataTable.LAT,'.','MarkerSize',14)
end 

% Example of how plot salinity vs. depth for each profile in datatable.
function vertical_profile(Hydro_DataTable)
figure 
hold on
for row = 1:height(Hydro_DataTable)    
    psal = cell2mat(Hydro_DataTable.CTDSAL(row,:));
    pres = cell2mat(Hydro_DataTable.CTDPRS(row,:));
    plot(psal,-1*pres,'.');
end  
end

% Example of how to subset dataframe based on values in a column.
function [Small_Table] = subset_datatable(Hydro_DataTable)
rows = Hydro_DataTable.LAT >= 50;
Small_Table = Hydro_DataTable(rows,:);
end
