%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 17-Jun-2020
%  Distributed under the terms of the MIT License

function [subobject] = general_region_subset(object,xcoords,ycoords)
figure
plot(object.LON,object.LAT,'.','MarkerSize',14)
in = inpolygon(object.LON,object.LAT,xcoords,ycoords); % Get indices of data in polygon.
hold on
plot([xcoords; xcoords(1)],[ycoords; ycoords(1)],'LineWidth',1) % % Plot polygon
plot(object.LON(in),object.LAT(in),'r+') % Plot points inside polygon

subobject.STN = object.STN(in);
subobject.LON = object.LON(in);
subobject.LAT = object.LAT(in);
subobject.DATE = object.DATE(in);

% find fields that ate not these fields
    % decide if variable is vector or array
        % if vector, decide if it is a depth vector or metadata
        % subset variable
        
prof_dim = length(object.STN);        
        
names = fieldnames(object);   
var_inds = find(~(strcmp(names,'STN')|strcmp(names,'LON')|strcmp(names,'LAT')|strcmp(names,'DATE')));       

for i = 1:length(var_inds)  
    if isvector(object.(names{var_inds(i)}))
        
        if length(object.(names{var_inds(i)}))==prof_dim
            subobject.(names{var_inds(i)}) = object.(names{var_inds(i)})(in); 
        else
            subobject.(names{var_inds(i)}) = object.(names{var_inds(i)});  
        end
        
    else
        subobject.(names{var_inds(i)}) = object.(names{var_inds(i)})(:,in);
    end
end

legend('object','region','subobject')

end

