
function [xcoords,ycoords] = region_select()
% region_select creates a list of x and y coordinates (which represent 
% vertices of a polygon) selected by clicking stations on a plot
% 
%% Syntax
% 
% [xcoords,ycoords] = region_select()
% 
%% Description 
% 
% [xcoords,ycoords] = region_select() creates a list of x and y coordinates selected by
% clicking stations on an existing (latitude vs. longitude) plot, returning them as xcoords and ycoords.
% 
%% Example 1
% Choose a polygon region around some Argo profiles and subset to this region:
% 
% general_map(argo)
% [xcoords,ycoords] = region_select(); % click desired  region on the figure
% [object_sub] = general_region_subset(object,xcoords,ycoords); 
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 20-Jul-2020
% 
% See also transect_select and general_region_subset.


waitfor(msgbox('Click to select region. Double click to close selection.'));
roi = drawpolygon;
xcoords = roi.Position(:,1);
ycoords = roi.Position(:,2);
end