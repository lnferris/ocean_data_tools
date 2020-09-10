function [region] = bounding_region(object,xcoords,ycoords)
% bounding_region finds the rectangular region around struct object
%
%% Syntax
% 
% [region] = bounding_region(object)
% [region] = bounding_region(object,xcoords,ycoords)
% [region] = bounding_region([],xcoords,ycoords)
% 
%% Description 
% 
% [region] = bounding_region(object) finds a rectangular region = [S N W E] 
% around a struct object; where object is a struct created by any of 
% the _build functions in ocean_data_tools (e.g. argo, cruise, hycom, mercator,
% woa, wod). 
%
% [region] = bounding_region(object,xcoords,ycoords) ensures that the region 
% bounding the above struct also ecompasses the points specified  by xcoords 
% (longitude) and ycoords (latitude). This is useful for extracting
% bathymetry only once before using bathymetry_plot and a bathymetry_section.
%
% [region] = bounding_region([],xcoords,ycoords) finds a rectangular 
% region  = [S N W E] around the points specified  by xcoords 
% (longitude) and ycoords (latitude).
%
%% Example 1
% Find a the region around struct argo (to be later used with bathymetry_plot):
%
% region = bounding_region(argo);
%
%% Example 2
% Find the region around a list of coordinates (to be later used with bathymetry_section):
%
% xcoords = -75:1/48:-74;
% ycoords = 65:1/48:66;
% region = bounding_region([],xcoords,ycoords);
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 09-Sep-2020
% 
% See also bathymetry_extract and bathymetry_plot.

if isstruct(object)
    region = [min(object.lat)-1 max(object.lat)+1 min(object.lon)-1 max(object.lon)+1];
else
    region = NaN(1,4);
end

if nargin > 1
    xyreg = [min(ycoords)-1 max(ycoords)+1 min(xcoords)-1 max(xcoords)+1];
    region = [min([region(1) xyreg(1)]) max([region(2) xyreg(2)]) min([region(3) xyreg(3)]) max([region(4) xyreg(4)])];
end

end