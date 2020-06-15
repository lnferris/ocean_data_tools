function [xcoords,ycoords] = transect_select(densify)

if nargin >= 1

waitfor(msgbox(['Click to create stations. Double click to end. Note ',num2str(densify),' stations will be interspersed for every 1 selected.']));
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
