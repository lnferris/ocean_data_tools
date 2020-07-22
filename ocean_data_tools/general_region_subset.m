
function [subobject] = general_region_subset(object,xcoords,ycoords)
% general_region_subset subsets object into a polygon region
% 
%% Syntax
% 
%  [subobject] = general_region_subset(object,xcoords,ycoords)
% 
%% Description 
% 
% [subobject] = general_region_subset(object,xcoords,ycoords) subsets
% object into a polygon region specified by xcoords and ycoords (vertices
% of the polygon); where object is a struct created by any of 
% the _build functions in ocean_data_tools (e.g. argo, cruise, hycom, mercator,
% woa, wod). 
% 
%% Example 1
% Spatially subset the profiles in argo:
% 
% object = argo; % % argo, cruise, hycom, mercator, woa, wod
% xcoords = [155.9, 155.1, 161.5, 162.3, 158.8];
% ycoords = [-53.0, -55.4, -56.6, -54.2,-52.4];
% [object_sub] = general_region_subset(object,xcoords,ycoords); 
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 25-Jun-2020
% 
% See also region_select and general_remove_duplicates.


figure
plot(object.lon,object.lat,'.','MarkerSize',14)
in = inpolygon(object.lon,object.lat,xcoords,ycoords); % Get indices of data in polygon.
hold on
plot([xcoords; xcoords(1)],[ycoords; ycoords(1)],'LineWidth',1) % % Plot polygon
plot(object.lon(in),object.lat(in),'r+') % Plot points inside polygon

prof_dim = length(object.stn);              
names = fieldnames(object);   
for i = 1:length(names)  
    if isvector(object.(names{i}))
        
        if length(object.(names{i}))==prof_dim
            subobject.(names{i}) = object.(names{i})(in); 
        else
            subobject.(names{i}) = object.(names{i});  
        end
        
    else
        subobject.(names{i}) = object.(names{i})(:,in);
    end
end

legend('object','region','subobject')

end

