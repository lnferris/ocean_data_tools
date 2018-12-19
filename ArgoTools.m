%%                  INFORMATION

%  Author: Lauren Newell Ferris
%  Institute: Virginia Institute of Marine Science
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jul 2018; Last revision: 28-Jul-2018
%  Distributed under the terms of the MIT License
%  Dependencies: borders.m by Chad Greene for map_datatable(), SSbathymetry() optional

%%                 EXAMPLE SCRIPT

SearchLimits = [-65.0 -40.0 150.0 175.0]; %  S N W E [-90 90 -180, 180]
StartDate = ArgoDate(2016,1,1); % YYYY, M, D
EndDate = ArgoDate(2016,1,5);
full_path = '/Users/lnferris/Desktop/ArgoData/*profiles*.nc'; % Data directory.
FillValue = 99999; % From Argo manual.
BasemapLimits = [-70 -35.0 140.0 185.0]; % Dimensions of lat/lon map.

% Get list of relevant netcdf files. Write matching profiles to datatable.
[ncfiles,Argo_DataTable] = getProfiles(full_path,SearchLimits,StartDate,EndDate,FillValue);

% Map profiles in datatable.
map_datatable(Argo_DataTable,BasemapLimits)
SSbathymetry('/Users/lnferris/Desktop/topo_18.1.img',SearchLimits,'2Dcontour') % Add bathymetry (optional).

% Map profiles, this time coloring by Argo platform.
map_platformcolor(Argo_DataTable,BasemapLimits)
SSbathymetry('/Users/lnferris/Desktop/topo_18.1.img',SearchLimits,'2Dcontour') % Add bathymetry (optional).

% Access and plot vertical profile data.
vertical_profile(Argo_DataTable,FillValue)

% Subset datatable based on platform,day,etc. (see definition).
Small_Table = subset_datatable(Argo_DataTable);

%%                    FUNCTIONS

% ArgoDate() converts calendar date to Argo date (days since 1950-01-01).
function [argo_date] = ArgoDate(year,month,day)
argo_date = datenum(year,month,day)-datenum(1950,1,1);
end

function [matching_file_list,Argo_DataTable] = getProfiles(full_path,SearchLimits,StartDate,EndDate,FillValue)

s_lim = SearchLimits(1); n_lim = SearchLimits(2);  % Unpack SearchLimits.
w_lim = SearchLimits(3); e_lim = SearchLimits(4);

matching_file_list = []; % Make an empty list to hold filenames.
Argo_DataTable = cell2table(cell(0,7)); % Make an empty table to hold profile data.
Argo_DataTable.Properties.VariableNames = {'ID' 'JULD' 'LAT' 'LON' 'PRES' 'PSAL' 'TEMPR'};

full_path = dir(full_path);
for i = 1:length(full_path) % For each file in full_path...
    filename = full_path(i).name;
        nc = netcdf.open(filename, 'NOWRITE'); % Open the file as a netcdf datasource.
        try % Try to read the file.
            LAT = netcdf.getVar(nc,netcdf.inqVarID(nc,'LATITUDE'));
            LON = netcdf.getVar(nc,netcdf.inqVarID(nc,'LONGITUDE'));
            JULD = netcdf.getVar(nc,netcdf.inqVarID(nc,'JULD'));
            
             % See which profiles have the correct lat,lon,date.
             LAT_good_loci =  (LAT >= s_lim & LAT <= n_lim);
             LON_good_loci = (LON >= w_lim & LON <= e_lim);
             JULD_good_loci = (JULD >= StartDate & JULD < (EndDate +1)); % (The "+1" is to include the EndDate.)
             loci_of_good_profiles = ((LAT_good_loci & LON_good_loci & JULD_good_loci) == 1);
             
                 if any(loci_of_good_profiles) % If there is at least one good profile in this file...
                    matching_file_list = [matching_file_list; string(filename)]; % Record filename to list.
                    TEMPR = netcdf.getVar(nc,netcdf.inqVarID(nc,'TEMP_ADJUSTED')); % Read all profiles in the file.
                    PSAL = netcdf.getVar(nc,netcdf.inqVarID(nc,'PSAL_ADJUSTED'));
                    PRES = netcdf.getVar(nc,netcdf.inqVarID(nc,'PRES_ADJUSTED'));
                    ID = str2num(netcdf.getVar(nc,netcdf.inqVarID(nc,'PLATFORM_NUMBER')).');
                    
                    loci_indices = find(loci_of_good_profiles == 1);
                    for j = 1:length(loci_indices) % Write each good profile into temporary cell array...
                        locus = loci_indices(j);
                        if ~all(PRES(:,locus) == FillValue) % As long is profile is not just fill values.
                            ProfileData = {ID(locus),JULD(locus),LAT(locus),LON(locus),PRES(:,locus),PSAL(:,locus),TEMPR(:,locus)};
                            Argo_DataTable = [Argo_DataTable;ProfileData]; % Combine temporary cell array with general datatable.
                        end
                    end
                 end

         catch ME % Throw an exception if unable to read file.
            ME
         end    
    netcdf.close(nc); % Close the file.
end
end

% map_datatable() plots latitude vs. longitude of profiles over basemap.
function map_datatable(Argo_DataTable,BasemapLimits)
figure
south = BasemapLimits(1); north = BasemapLimits(2);  % Unpack BasemapLimits.
west = BasemapLimits(3); east = BasemapLimits(4);
borders('countries','facecolor','k','nomap')
axis([west east south north])
grid on; grid minor
plot(Argo_DataTable.LON, Argo_DataTable.LAT,'.','MarkerSize',14)
end    

% map_platformcolor() is the same as map_datatable, but profiles are colored by the platform that produced them.
function map_platformcolor(Argo_DataTable,BasemapLimits)
figure
hold on
south = BasemapLimits(1); north = BasemapLimits(2);  % Unpack BasemapLimits.
west = BasemapLimits(3); east = BasemapLimits(4);
platformIDs = unique(Argo_DataTable.ID); % Get IDs of the platforms.
x = 1:length(platformIDs); % Make vector of short 1..2..3.. labels.
% For each unique platform:
for i = 1:length(unique(Argo_DataTable.ID)) 
    % Plot lat/lon for all profiles.
    plot(Argo_DataTable.LON(Argo_DataTable.ID==platformIDs(i)),Argo_DataTable.LAT(Argo_DataTable.ID==platformIDs(i)),'.','MarkerSize',14)
    text(Argo_DataTable.LON(Argo_DataTable.ID==platformIDs(i)),Argo_DataTable.LAT(Argo_DataTable.ID==platformIDs(i)),string(x(i)),'FontSize',6)
end
borders('countries','facecolor','k','nomap')
axis([west east south north])
grid on; grid minor
number_labels = cellstr(num2str(x(:))); % Make legend.
platform_labels = cellstr(num2str(platformIDs(:)));
legend(strcat(number_labels,' (',platform_labels,')'))
end

% Example of how plot salinity vs. depth for each profile in datatable.
function vertical_profile(Argo_DataTable,FillValue)
figure 
hold on
for row = 1:height(Argo_DataTable)    
    psal = cell2mat(Argo_DataTable.PSAL(row,:));
    pres = cell2mat(Argo_DataTable.PRES(row,:));
    psal(psal==FillValue) = NaN;
    pres(pres==FillValue) = NaN;
    plot(psal,-1*pres,'.');
end  
end

% Example of how to subset dataframe based on values in a column.
function [Small_Table] = subset_datatable(Argo_DataTable)
rows = Argo_DataTable.ID==5904598;
Small_Table = Argo_DataTable(rows,:);
end
