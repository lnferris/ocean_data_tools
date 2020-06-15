%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 15-Jun-2020
%  Distributed under the terms of the MIT License
%  Dependencies: nctoolbox

% inputs: 
    % ss_path= '/Users/lnferris/Desktop/topo_18.1.img'; % Path to Smith & Sandwell database
    % xref = 'lat' 'lon'

function bathymetry_section_whp(ss_path,cruise,xref)

% Auto-select region.
region = [min(cruise.LAT)-1 max(cruise.LAT)+1 min(cruise.LON)-1 max(cruise.LON)+1];

% Remap region from SNWE to WESN.
region = [region(3) region(4) region(1) region(2)];

% Load bathymetry data.
[bath,vlat,vlon] = extract1m_modified(region,ss_path);

% Remap to -180/180 if not crossing dateline.
if min(vlon) > 180
    vlon = vlon-360;    
end   

bathymetry_section = NaN(1,height(cruise));
for i = 1:height(cruise)
    [lon_ind,~] = near(vlon,cruise.LON(i));
    [lat_ind,~] = near(vlat,cruise.LAT(i));
    bathymetry_section(i) = bath(lat_ind,lon_ind);
end

hold on

xvar = eval(['cruise.',xref]);

% Order bathymetry data by xref.
[xvar,xvar_inds] = sort(xvar);
bathymetry_section = bathymetry_section(xvar_inds);

plot(xvar,bathymetry_section,'k','LineWidth',4)



hold off

end
