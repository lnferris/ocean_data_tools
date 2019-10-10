%%                  INFORMATION

%  Author: Lauren Newell Ferris
%  Institute: Virginia Institute of Marine Science
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  April 2019; Last revision: 26-July-2019
%  Distributed under the terms of the MIT License

%  Dependencies: Prior call to HYCOMTools2D.m, HYCOMTools3D.m, or HYCOM_slice.m 
%                to build ncgeovariable objects (sv, svg, tin).

% inputs: 
% sv and svg, ncgeovariable objects for the HYCOM dataset to be evaluated
% tin, time of interest for the HYCOM dataset to be evaluated
% query_LON, longitude of the Argo/WOD/GO-SHIP/etc. cast to be used for cast-cast comparison
%            or longitude of simulated point of interest            
% query_LAT, latitude of the Argo/WOD/GO-SHIP/etc. cast to be used for cast-cast comparison
%            or latitude of simulated point of interest 
% flag = 'cast_map' or 'cast_profile'

%%                    FUNCTION

function [hycom_tracer,hycom_z] = HYCOM_virtual_cast(query_LON,query_LAT,sv,svg,tin,flag)
% [hycom_tracer,hycom_z] = HYCOM_virtual_cast(50.1290,12.5900,sv,svg,tin,'cast_map');
       
[hycom_lonind,~] = near(svg.lon,query_LON);
[hycom_latind,~] = near(svg.lat,query_LAT);
hycom_tracer = sv.data(tin,:,hycom_latind,hycom_lonind);
hycom_z = svg.z(:);

if strcmp(flag,'cast_map')
   scatter(svg.lon(hycom_lonind),svg.lat(hycom_latind));
    
elseif strcmp(flag,'cast_profile')
   scatter(hycom_tracer,hycom_z)
   
else 
   disp('Check spelling of plot type');
end
