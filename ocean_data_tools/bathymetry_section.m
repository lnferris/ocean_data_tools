%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 29-Jun-2020
%  Distributed under the terms of the MIT License

% bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc'; % Path to Smith & Sandwell database 

function [bath_section,lon_section,lat_section] = bathymetry_section(bathymetry_dir,xcoords,ycoords,xref,filled)

if nargin < 5
    filled = 0;
end

% Auto-select region.
region = [min(ycoords)-1 max(ycoords)+1 min(xcoords)-1 max(xcoords)+1];

% Load bathymetry data.
[bath,lat,lon] = bathymetry_extract(bathymetry_dir,region);

bath_section = NaN(1,length(xcoords));
lon_section = NaN(1,length(xcoords));
lat_section = NaN(1,length(xcoords));
for i = 1:length(xcoords)
    [lon_ind,~] = near(lon,xcoords(i));
    [lat_ind,~] = near(lat,ycoords(i));
    bath_section(i) = bath(lon_ind,lat_ind);
    lon_section(i) = lon(lon_ind);
    lat_section(i) = lat(lat_ind);
end

if strcmp(xref,'lon')
    xvar = lon_section;   
elseif strcmp(xref,'lat')
    xvar = lat_section;   
else
    disp('Check spelling of reference axis');  
end

% order bathymetry data by xref.
[xvar,xvar_inds] = sort(xvar);
bath_section = bath_section(xvar_inds);

hold on
plot(xvar,bath_section,'k','LineWidth',4)

if filled ==1
    basevalue = min(bath_section);
    area(xvar,bath_section,basevalue,'FaceColor','k')
    ylim([min(bath_section) 10])
end

hold off
end