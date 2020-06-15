
%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 15-Jun-2020
%  Distributed under the terms of the MIT License

function [argo,matching_files] = argo_load(argo_dir,search_region,start_date,end_date)

FillValue = 99999; % From Argo manual.

start_date = datenum(start_date,'dd-mmm-yyyy HH:MM:SS');
end_date = datenum(end_date,'dd-mmm-yyyy HH:MM:SS');

s_lim = search_region(1); n_lim = search_region(2);  % Unpack SearchLimits.
w_lim = search_region(3); e_lim = search_region(4);

matching_files = []; % Make an empty list to hold filenames.
argo = cell2table(cell(0,7)); % Make an empty table to hold profile data.
argo.Properties.VariableNames = {'ID' 'JULD' 'LAT' 'LON' 'PRES' 'PSAL' 'TEMP'};
full_path = dir(argo_dir);
for i = 1:length(full_path) % For each file in full_path...
    filename = [full_path(i).folder '/' full_path(i).name];
    
        nc = netcdf.open(filename, 'NOWRITE'); % Open the file as a netcdf datasource.
        try % Try to read the file.
            LAT = netcdf.getVar(nc,netcdf.inqVarID(nc,'LATITUDE'));
            LON = netcdf.getVar(nc,netcdf.inqVarID(nc,'LONGITUDE'));
            JULD = netcdf.getVar(nc,netcdf.inqVarID(nc,'JULD'))+ datenum(1950,1,1); %Argo date  is days since 1950-01-01.
            
             % See which profiles have the correct lat,lon,date.
             LAT_good_loci =  (LAT >= s_lim & LAT <= n_lim);
             LON_good_loci = (LON >= w_lim & LON <= e_lim);
             JULD_good_loci = (JULD >= start_date & JULD < (end_date +1)); % (The "+1" is to include the EndDate.)
             loci_of_good_profiles = ((LAT_good_loci & LON_good_loci & JULD_good_loci) == 1);
             
                 if any(loci_of_good_profiles) % If there is at least one good profile in this file...
                    matching_files = [matching_files; string(filename)]; % Record filename to list.
                    TEMP = netcdf.getVar(nc,netcdf.inqVarID(nc,'TEMP_ADJUSTED')); % Read all profiles in the file.
                    PSAL = netcdf.getVar(nc,netcdf.inqVarID(nc,'PSAL_ADJUSTED'));
                    PRES = netcdf.getVar(nc,netcdf.inqVarID(nc,'PRES_ADJUSTED'));
                    ID = str2num(netcdf.getVar(nc,netcdf.inqVarID(nc,'PLATFORM_NUMBER')).');
                    
                    loci_indices = find(loci_of_good_profiles == 1);
                    for j = 1:length(loci_indices) % Write each good profile into temporary cell array...
                        locus = loci_indices(j);
                        if ~all(PRES(:,locus) == FillValue) % As long is profile is not just fill values.
                            ProfileData = {ID(locus),JULD(locus),LAT(locus),LON(locus),PRES(:,locus),PSAL(:,locus),TEMP(:,locus)};
                            argo = [argo;ProfileData]; % Combine temporary cell array with general datatable.
                        end
                    end
                 end

         catch ME % Throw an exception if unable to read file.
            ME;
            disp(['Cannot read ',filename]);
         end    
    netcdf.close(nc); % Close the file.
end

if min(argo.LON) < -170 && max(argo.LON)>170  % if working near dateline wrap to 0/360
    argo.LON(argo.LON < 0) = argo.LON(argo.LON < 0)+360; 
end   
end