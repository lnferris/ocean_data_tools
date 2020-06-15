%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 15-Jun-2020
%  Distributed under the terms of the MIT License

function [subobject] = general_region_subset(object,xcoords,ycoords)
figure
plot(object.LON,object.LAT,'.','MarkerSize',14)
in = inpolygon(object.LON,object.LAT,xcoords,ycoords); % Get indices of data in polygon.
hold on
plot([xcoords; xcoords(1)],[ycoords; ycoords(1)],'LineWidth',1) % % Plot polygon
plot(object.LON(in),object.LAT(in),'r+') % Plot points inside polygon

if isa(object,'table')
    
    subobject = object(in,:); % Create new datable of only flagged profiles.
    
elseif isa(object,'struct')
    
    subobject.LON = object.LON(in);
    subobject.LAT = object.LAT(in);
    subobject.STN = object.STN(in);
    subobject.date = object.date(in);
    subobject.depth = object.depth;
    fns = fieldnames(object);
    subobject.(fns{6}) = object.(fns{6})(:,in);

end

legend('object','region','subobject')

end


