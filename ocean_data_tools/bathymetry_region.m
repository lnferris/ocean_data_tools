function [region] = bathymetry_region(object)
% bathymetry_region finds the rectangular region around struct object
%
%% Syntax
% 
% [region] = bathymetry_region(object)
% 
%% Description 
% 
% [region] = bathymetry_region(object) finds a rectangular region = [S N W E] 
% around a struct object; where object is a struct created by any of 
% the _build functions in ocean_data_tools (e.g. argo, cruise, hycom, mercator,
% woa, wod). 
%
%% Example 1
% Find a the bathymetry region around struct argo:
%
% region = bathymetry_region(argo);
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 30-Jun-2020
% 
% See also bathymetry_extract and bathymetry_plot.

region = [min(object.lat)-5 max(object.lat)+5 min(object.lon)-5 max(object.lon)+5];
end
