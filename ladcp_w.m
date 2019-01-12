%  Author: Lauren Newell Ferris
%  Institute: Virginia Institute of Marine Science
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Aug 2018; Last revision: 11-Jan-2019
%  Distributed under the terms of the MIT License

%%                 EXAMPLE SCRIPT

data_directory = '/Users/lnferris/Desktop/processed_w_20181230/'; % Data directory.
extension = '*wprof.nc';

% Get list of relevant netcdf files. Write matching profiles to datatable.
[Hydro_DataTable] = getStations(data_directory,extension);

% Access and plot vertical profile data.
vertical_profile(Hydro_DataTable)

% Subset datatable based on station, etc. (see definition).
Small_Table = subset_datatable(Hydro_DataTable);


%%                    FUNCTIONS


function [Hydro_DataTable] = getStations(data_directory,extension)

Hydro_DataTable = cell2table(cell(0,6)); % Make an empty table to hold profile data.
Hydro_DataTable.Properties.VariableNames = {'STN' 'DEP' 'HAB' 'DC_EL' 'DC_W' 'UC_W'};  
full_path = dir([data_directory extension]);
for i = 1:length(full_path) % For each file in full_path...
    filename = full_path(i).name;
    nc = netcdf.open([data_directory filename], 'NOWRITE'); % Open the file as a netcdf datasource.
        try % Try to read the file.
        
        STN = str2num(filename(1:3));    
        DEP = netcdf.getVar(nc,netcdf.inqVarID(nc,'depth')); % Depth m
        HAB = netcdf.getVar(nc,netcdf.inqVarID(nc,'hab')); % Height Above Seabed m
        DC_EL = netcdf.getVar(nc,netcdf.inqVarID(nc,'dc_elapsed'));% Downcast Elapsed Time
        DC_W = netcdf.getVar(nc,netcdf.inqVarID(nc,'dc_w')); % Downcast Vertical Ocean Velocity m/s
        % Downcast Mean Absolute Deviation in Bin
        % Downcast Number of Samples in Bin
        % Upcast Elapsed Time
        UC_W = netcdf.getVar(nc,netcdf.inqVarID(nc,'uc_w')); % Upcast Vertical Ocean Velocity, m/s, uc_w(depth)
        % Upcast Mean Absolute Deviation in Bin, uc_w.mad(depth)
        % Upcast Number of Samples in Bin, uc_w.nsamp(depth)
            
        Station_DataTable = {STN, DEP, HAB, DC_EL, DC_W, UC_W};
        Hydro_DataTable = [Hydro_DataTable;Station_DataTable]; % Combine temporary cell array with general datatable.
       
        catch ME % Throw an exception if unable to read file.
        ME
        end    
    netcdf.close(nc); % Close the file.  

end
end


% Example of how plot salinity vs. depth for each profile in datatable.
function vertical_profile(Hydro_DataTable)
figure 
hold on
for row = 1:height(Hydro_DataTable)    
    tracer = cell2mat(Hydro_DataTable.UC_W(row,:));
    pres = cell2mat(Hydro_DataTable.DEP(row,:));
    plot(tracer,-1*pres,'.');
end  
end

% Example of how to subset dataframe based on values in a column.
function [Small_Table] = subset_datatable(Hydro_DataTable)
rows = Hydro_DataTable.STN <= 10;
Small_Table = Hydro_DataTable(rows,:);
end
