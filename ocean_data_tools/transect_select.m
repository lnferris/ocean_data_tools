function [xcoords,ycoords] = transect_select(densify)
% transect_select creates a list of x and y coordinates (which represent a 
% transect) selected by clicking stations on a plot
% 
%% Syntax
% 
%  [xcoords,ycoords] = transect_select() 
%  [xcoords,ycoords] = transect_select(densify)
% 
%% Description 
% 
% [xcoords,ycoords] = transect_select() creates a list of x and y coordinates selected by
% clicking stations on an existing (latitude vs. longitude) plot, returning them as xcoords and ycoords
%
% [xcoords,ycoords] = transect_select(densify) auto-generates additional
% stations with the multiplier densify. densify=10 would fill in 10
% stations for every station clicked using linear interpolation of complex
% coordinates
% 
%% Example 1
% Generate a list of coordinates by clicking a HYCOM velocity plot: 
% 
% model_type = 'hycom'; 
% source = 'http://tds.hycom.org/thredds/dodsC/GLBv0.08/expt_57.7';
% date = '28-Aug-2017 00:00:00';  
% variable = 'velocity';                
% region = [-5.0, 45.0 ,160,-150 ];      
% depth = -150;                                                   
% model_simple_plot(model_type,source,date,variable,region,depth);
% [xcoords,ycoords] = transect_select(10); % click desired transect on the figure, densify selection by 10x 
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 20-Jul-2020
% 
% See also region_select.


if nargin >= 1

waitfor(msgbox(['Click points to draw a transect. Double-click to end the transect. The selected points will be interpolated such that ',num2str(densify),' interspersed stations will be created for every 1 point selected.']));
else
    waitfor(msgbox('Click to create stations. Double click to end.'));
end

roi = drawpolyline;
xcoords = roi.Position(:,1);
ycoords = roi.Position(:,2);

if nargin >= 1
% interpolate complex coordinates
xy_coords = xcoords + ycoords*1j; % z = x+iy
v = xy_coords;
xq  = linspace(1,length(xy_coords),length(xy_coords)*densify);
xxyy_coords = interp1(v,xq);
xcoords = real(xxyy_coords); 
ycoords = imag(xxyy_coords);

end
