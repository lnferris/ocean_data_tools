%%                  INFORMATION

%  Author: Lauren Newell Ferris
%  Institute: Virginia Institute of Marine Science
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  March 2019; Last revision: 24-March-2019
%  Distributed under the terms of the MIT License

%% Function to geometrically subset stations from a data table
function [Smalltable] = shapeSubset(Datatable)
figure
plot(Datatable.LON,Datatable.LAT,'.','MarkerSize',14)
poly_x = [-145 -149 -150 -151 -153 -152 -145]; % x coordinates of vertices
poly_y = [57 56 54 56 50 42 57]; % y coordinates of vertices
in = inpolygon(Datatable.LON,Datatable.LAT,poly_x,poly_y); % Get indices of data in polygon.
hold on
plot(poly_x,poly_y,'LineWidth',1) % % Plot polygon
plot(Datatable.LON(in),Datatable.LAT(in),'r+') % Plot points inside polygon
Smalltable = Datatable(in,:); % Create new datable of only flagged profiles.
end
