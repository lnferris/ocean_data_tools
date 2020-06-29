function [xcoords,ycoords] = region_select()
waitfor(msgbox('Click to select region. Double click to close selection.'));
roi = drawpolygon;
xcoords = roi.Position(:,1);
ycoords = roi.Position(:,2);
end