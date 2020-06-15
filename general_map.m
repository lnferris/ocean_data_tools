%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 15-Jun-2020
%  Distributed under the terms of the MIT License

function general_map(object,bathymetry_dir,ptype)

    figure
    grid on; grid minor
    plot(object.LON, object.LAT,'.','MarkerSize',14)
    axis([min(object.LON)-5 max(object.LON)+5 min(object.LAT)-5 max(object.LAT)+5])
    

    if nargin >= 2

        default_type = '2Dcontour';

        if nargin >= 3
            default_type = ptype;
        end

        bathymetry_plot(bathymetry_dir,bathymetry_region(object),default_type)

     end

end   
