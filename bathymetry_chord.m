%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 15-Jun-2020
%  Distributed under the terms of the MIT License

% inputs: 
    % ss_path= '/Users/lnferris/Desktop/topo_18.1.img'; % Path to Smith & Sandwell database
    % xref = 'lat' 'lon'
    % width = 1/60; % Approximate width of chord in degrees

function bathymetry_chord(ss_path,lon1,lat1,lon2,lat2,xref,width)

if nargin <= 6 
    width = 1/60; % default 
end

% Auto-select region.
region = [min([lat1 lat2]) max([lat1 lat2]) min([lon1 lon2]) max([lon1 lon2])];

% Remap region from SNWE to WESN.
region = [region(3) region(4) region(1) region(2)];

% Load bathymetry data.
[bath,vlat,vlon] = extract1m_modified(region,ss_path);

% Remap to -180/180 if not crossing dateline.
if min(vlon) > 180
    vlon = vlon-360;
    if lon1 > 180
        lon1 = lon1-360;
    end
     if lon2 > 180
        lon2 = lon2-360;
     end        
end   

poly_x = [lon1+width/2 lon1-width/2 lon2-width/2 lon2+width/2 lon1+width/2];
poly_y = [lat1+width/2 lat1-width/2 lat2-width/2 lat2+width/2 lat1+width/2];

[lon_mesh,lat_mesh] = meshgrid(vlon,vlat);  % Create coordinate mesh from lons/lats/deps.
lon_arr1D = reshape(lon_mesh,[],1); 
lat_arr1D = reshape(lat_mesh,[],1); 
dep_arr1D = reshape(bath,[],1);

in = inpolygon(lon_arr1D,lat_arr1D,poly_x,poly_y); % Get indices of data in polygon.

hold on

if strcmp(xref,'LON')
    plot(lon_arr1D(in),dep_arr1D(in),'k','LineWidth',4)
    
elseif strcmp(xref,'LAT')
    plot(lat_arr1D(in),dep_arr1D(in),'k','LineWidth',4)
    
else
    disp('Check spelling of reference axis');  
    
end

hold off

end
