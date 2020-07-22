
function netcdf_info(nc_dir)
% netcdf_info gets and information about the first file in path nc_dir
% and saves it to the working directory
% 
%% Syntax
% 
%  netcdf_info(nc_dir)
% 
%% Description 
% 
% netcdf_info(nc_dir) gets and information about the first file in path nc_dir
% and saves it to the working directory, creating or overwriting file
% "netcdf_info-ocean_data_tools"
% 
%% Example 1
% Get information about Argo netcdf files:
% 
% argo_dir = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/argo/*profiles*.nc'; % included
% netcdf_info(argo_dir);
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 25-Jun-2020
% 
% See also ncdisp.


full_path = dir(nc_dir);

for i = 1:length(full_path) % For each file in full_path...
    
    try
        delete netcdf_info-ocean_data_tools
        diary netcdf_info-ocean_data_tools
        ncdisp([full_path(i).folder '/' full_path(i).name])
        diary off
        disp(['Info about ',full_path(i).name,' saved to ', pwd,'/netcdf_info-ocean_data_tools.'])
        break
    catch
    end

end

