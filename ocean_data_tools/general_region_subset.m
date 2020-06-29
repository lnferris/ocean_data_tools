%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 25-Jun-2020
%  Distributed under the terms of the MIT License

function [subobject] = general_region_subset(object,xcoords,ycoords)
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

