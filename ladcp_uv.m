%  Author: Lauren Newell Ferris
%  Institute: Virginia Institute of Marine Science
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Aug 2018; Last revision: 11-Jan-2019
%  Distributed under the terms of the MIT License

%%                 EXAMPLE SCRIPT

data_directory = '/Users/lnferris/Desktop/processed_uv_20181105/'; % Data directory.
extension = '*.mat';

% Get list of relevant netcdf files. Write matching profiles to datatable.
[Hydro_DataTable] = getStations(data_directory,extension);

% Access and plot vertical profile data.
vertical_profile(Hydro_DataTable)

% Subset datatable based on station, etc. (see definition).
Small_Table = subset_datatable(Hydro_DataTable);

%%                    FUNCTIONS

function [Hydro_DataTable] = getStations(data_directory,extension)

Hydro_DataTable = cell2table(cell(0,7)); % Make an empty table to hold profile data.
Hydro_DataTable.Properties.VariableNames = {'STN' 'DAT' 'LAT' 'LON' 'Z' 'U' 'V'};  
full_path = dir([data_directory extension]);
for i = 1:length(full_path) % For each file in full_path...
    filename = full_path(i).name; 
    load([data_directory filename],'-mat')
        
        STN  = str2num(filename(1:3)); 
        DAT = datenum(dr.date);
        LAT = dr.lat;
        LON = dr.lon;
        Z = dr.z;
        U = dr.u;
        V = dr.v;
    
        Station_DataTable = {STN, DAT, LAT, LON, Z, U, V};
        Hydro_DataTable = [Hydro_DataTable;Station_DataTable]; % Combine temporary cell array with general datatable.
end
end


% Example of how plot salinity vs. depth for each profile in datatable.
function vertical_profile(Hydro_DataTable)
figure 
hold on
for row = 1:height(Hydro_DataTable)    
    tracer = cell2mat(Hydro_DataTable.U(row,:));
    depth = cell2mat(Hydro_DataTable.Z(row,:));
    plot(tracer,-1*depth,'.');
end  
end

% Example of how to subset dataframe based on values in a column.
function [Small_Table] = subset_datatable(Hydro_DataTable)
rows = Hydro_DataTable.STN <= 10;
Small_Table = Hydro_DataTable(rows,:);
end
