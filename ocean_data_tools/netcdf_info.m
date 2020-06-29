%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 25-Jun-2020
%  Distributed under the terms of the MIT License

function netcdf_info(nc_dir)

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

