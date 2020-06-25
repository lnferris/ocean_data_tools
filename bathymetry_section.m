%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 21-Jun-2020
%  Distributed under the terms of the MIT License

% bathymetry_dir = '/Users/lnferris/Documents/data/bathymetry/topo_20.1.nc'; % Path to Smith & Sandwell database 

function bathymetry_section(bathymetry_dir,xcoords,ycoords,xref,filled)

if nargin < 5
    filled = 0;
end

% Auto-select region.
region = [min(ycoords)-1 max(ycoords)+1 min(xcoords)-1 max(xcoords)+1];

% Load bathymetry data.
[bath,lat,lon] = bathymetry_extract(bathymetry_dir,region);

bathymetry_section = NaN(1,length(xcoords));
for i = 1:length(xcoords)
    [lon_ind,~] = near(lon,xcoords(i));
    [lat_ind,~] = near(lat,ycoords(i));
    bathymetry_section(i) = bath(lon_ind,lat_ind);
end


if strcmp(xref,'lon')
    xvar = xcoords;   
elseif strcmp(xref,'lat')
    xvar = ycoords;   
else
    disp('Check spelling of reference axis');  
end

% order bathymetry data by xref.
[xvar,xvar_inds] = sort(xvar);
bathymetry_section = bathymetry_section(xvar_inds);

hold on
plot(xvar,bathymetry_section,'k','LineWidth',4)

if filled ==1
    basevalue = min(bathymetry_section);
    area(xvar,bathymetry_section,basevalue,'FaceColor','k')
    ylim([min(bathymetry_section) 10])
end

hold off
end