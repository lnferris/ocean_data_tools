
function general_map(object,bathymetry_dir,ptype)
% general_map plots coordinate locations in object 
% 
%% Syntax
% 
% general_map(object)
% general_map(object,bathymetry_dir)
% general_map(object,bathymetry_dir,ptype)
% 
%% Description 
% 
% general_map(object) plots coordinate locations 
% (object.lon and object.lat); where object is a struct created by any of 
% the _build functions in ocean_data_tools (e.g. argo, cruise, hycom, mercator,
% woa, wod). 
%
% general_map(object,bathymetry_dir) adds bathymetry contours from Smith & Sandwell Global
% Topography with path bathymetry_dir.
%
% general_map(object,bathymetry_dir,ptype) allows the user to modify plot
% type from the default contours e.g. ptype = '2Dscatter' or '2Dcontour'
% 
%% Example 1
% Plot locations of Argo profiles in struct argo over bathmetry contours:
% 
% ptype = '2Dcontour'; % '2Dscatter' '2Dcontour'
% object = argo; % argo, cruise, hycom, mercator, woa, wod
% general_map(object,bathymetry_dir,ptype)
%
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% un 2020; Last revision: 07-Sep-2020
% 
% See also bathymetry_plot and general_region_subset.

hold on

    if nargin >= 2

        default_type = '2Dcontour';

        if nargin >= 3
            default_type = ptype;
        end
        [bathy] = bathymetry_extract(bathymetry_dir,bounding_region(object));
        bathymetry_plot(bathy,default_type)

    end
     
hold on
    
    grid on; grid minor
    plot(object.lon, object.lat,'.','MarkerSize',14)
    axis([min(object.lon)-5 max(object.lon)+5 min(object.lat)-5 max(object.lat)+5])
    
hold off


end   
