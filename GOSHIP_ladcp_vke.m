%  Author: Lauren Newell Ferris
%  Institute: Virginia Institute of Marine Science
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Aug 2018; Last revision: 11-Jan-2019
%  Distributed under the terms of the MIT License

%%                 EXAMPLE SCRIPT

data_directory = '/Users/lnferris/Desktop/processed_w_20181230/'; % Data directory.
extension = '*VKEprof.nc';

% Get list of relevant netcdf files. Write matching profiles to datatable.
[Hydro_DataTable] = getStations(data_directory,extension);

% Access and plot vertical profile data.
vertical_profile(Hydro_DataTable)

% Subset datatable based on station, etc. (see definition).
Small_Table = subset_datatable(Hydro_DataTable);


%%                    FUNCTIONS

function [Hydro_DataTable] = getStations(data_directory,extension)

Hydro_DataTable = cell2table(cell(0,5)); % Make an empty table to hold profile data.
Hydro_DataTable.Properties.VariableNames = {'STN' 'DEP' 'HAB' 'P0' 'EPS'};  
full_path = dir([data_directory extension]);
for i = 1:length(full_path) % For each file in full_path...
    filename = full_path(i).name;
    nc = netcdf.open([data_directory filename], 'NOWRITE'); % Open the file as a netcdf datasource.
        try % Try to read the file.
        
        STN = str2num(filename(1:3));  
        %'widx'% Window Index, m
        DEP = netcdf.getVar(nc,netcdf.inqVarID(nc,'depth')); % Window Center Depth, m
        %'depth.min'% Window Min Depth, m
        %'depth.max'% Window Max Depth, m
        HAB = netcdf.getVar(nc,netcdf.inqVarID(nc,'hab')); % Window Center Height Above Seabed
        %'nspec'% Number of Input Spectra in Window
        P0 = netcdf.getVar(nc,netcdf.inqVarID(nc,'p0')); % Normalized VKE Density, W/kg
        %'p0fit.rms'% RMS Errror from Power-Law VKE Fit
        %'p0fit.r'% Correlation Coefficient from Power-Law VKE Fit
        %'p0fit.slope'% Slope from Power-Law VKE Fit
        %'p0fit.slope.sig '% Slope Uncertainty (Standard Deviation) from Power-Law VKE Fit
        EPS = netcdf.getVar(nc,netcdf.inqVarID(nc,'eps.VKE')); % Turbulent Kinetic Energy Dissipation from Finescale VKE Parameterization
     
            
        Station_DataTable = {STN, DEP, HAB, P0, EPS};
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
    tracer = cell2mat(Hydro_DataTable.EPS(row,:));
    pres = cell2mat(Hydro_DataTable.DEP(row,:));
    plot(tracer,-1*pres,'.');
    set(gca, 'XScale', 'log')
end  
end

% Example of how to subset dataframe based on values in a column.
function [Small_Table] = subset_datatable(Hydro_DataTable)
rows = Hydro_DataTable.STN <= 10;
Small_Table = Hydro_DataTable(rows,:);
end
