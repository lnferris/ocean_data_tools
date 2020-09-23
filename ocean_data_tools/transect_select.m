function [xcoords,ycoords] = transect_select(scheme,value)
% transect_select creates a list of x and y coordinates (which represent a 
% transect) selected by clicking stations on a plot
% 
%% Syntax
% 
%  [xcoords,ycoords] = transect_select() 
%  [xcoords,ycoords] = transect_select(scheme,value)
% 
%% Description 
% 
% [xcoords,ycoords] = transect_select() creates a list of x and y coordinates selected by
% clicking stations on an existing (latitude vs. longitude) plot, returning them as xcoords and ycoords
%
% [xcoords,ycoords] = transect_select(scheme,value) auto-generates additional
% stations with based on the scheme chosen. scheme = 'densify' auto-generates 
% additional stations with the multiplier value; value=10 would fill in 10
% stations for every station clicked using linear interpolation of complex
% coordinates. scheme = 'spacing' auto-generates additional stations with
% the specified spacing value, where value is the longitude or latitude 
% spacing in degrees; value=0.5 would fill in stations such that stations 
% are 0.5 degrees apart. 
%
% If scheme = 'densify', value (no units) should be an integer. If it is not an integer 
% it will be rounded to an integer.
%
% If scheme = 'spacing', value (in degrees) should be single, double, or integer and 
% represents the prescribed grid spacing between auto-generated stations in 
% degrees. The spacing criterion is applied to each dimension separately and 
% is not the diagonal displacement.
%
% xcoords and ycoords are vectors of coordinates representing a polygonal chain.
% -180/180 or 0/360 notation will match that of the existing plot.
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
% [xcoords,ycoords] = transect_select('spacing',0.5); % click desired transect on the figure, densify selection to 0.5 degree spacing
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 22-Sep-2020
% 
% See also region_select.


if nargin >= 1
    
    if nargin ==1
                disp('Error: Missing second argument.')
        return
    end
        
    if strcmp(scheme,'densify')
        
        assert(isnumeric(value) & length(value)==1,'Error: value must be an integer.');
        waitfor(msgbox(['Click points to draw a transect. Double-click to end the transect. The selected points will be interpolated such that ',num2str(value),' interspersed stations will be created for every 1 point selected.']));
    
    elseif strcmp(scheme,'spacing')
        
        assert(isnumeric(value) & length(value)==1,'Error: value must be a number.');
        waitfor(msgbox(['Click points to draw a transect. Double-click to end the transect. The selected points will be interpolated to a station spacing of ',num2str(value),' degrees.']));
    
    else
        
        disp('Check spelling of scheme: ''densify'' or ''spacing''.')
        return
    
    end
else
    waitfor(msgbox('Click to create stations. Double click to end the transect.'));
end

roi = drawpolyline;
xcoords = roi.Position(:,1);
ycoords = roi.Position(:,2);

if nargin >= 2
    
    if strcmp(scheme,'densify')

        xy_coords = xcoords + ycoords*1j; % z = x+iy
        v = xy_coords;
        xq  = linspace(1,length(xy_coords),length(xy_coords)*round(value));
        xxyy_coords = interp1(v,xq);
        xcoords = real(xxyy_coords); 
        ycoords = imag(xxyy_coords);
        
   elseif strcmp(scheme,'spacing')
       
        [ycoords, xcoords] = interpm(ycoords, xcoords, value);   
        
    end
end
    
end
