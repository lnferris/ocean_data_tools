%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 15-Jun-2020
%  Distributed under the terms of the MIT License

% inputs: 
    % ss_path= '/Users/lnferris/Desktop/topo_18.1.img'; % Path to Smith & Sandwell database
    % xref = 'lat' 'lon'

function bathymetry_section(ss_path,xcoords,ycoords,xref)

% Auto-select region.
region = [min(ycoords)-1 max(ycoords)+1 min(xcoords)-1 max(xcoords)+1];

% Remap region from SNWE to WESN.
region = [region(3) region(4) region(1) region(2)];

% Load bathymetry data.
[bath,vlat,vlon] = extract1m_modified(region,ss_path);

% Remap to -180/180 if not crossing dateline.
if min(vlon) > 180
    vlon = vlon-360;    
end   

bathymetry_section = NaN(1,length(xcoords));
for i = 1:length(xcoords)
    [lon_ind,~] = near(vlon,xcoords(i));
    [lat_ind,~] = near(vlat,ycoords(i));
    bathymetry_section(i) = bath(lat_ind,lon_ind);
end


if strcmp(xref,'LON')
    xvar = xcoords;   
elseif strcmp(xref,'LAT')
    xvar = ycoords;   
else
    disp('Check spelling of reference axis');  
end

% order bathymetry data by xref.
[xvar,xvar_inds] = sort(xvar);
bathymetry_section = bathymetry_section(xvar_inds);

hold on
plot(xvar,bathymetry_section,'k','LineWidth',4)
hold off

end