%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 21-Jun-2020
%  Distributed under the terms of the MIT License

function [subargo] = argo_platform_subset(argo,platform_id)

    float_inds = find(argo.id==platform_id);

    subargo.id = argo.id(float_inds);
    subargo.lon = argo.lon(float_inds);
    subargo.lat = argo.lat(float_inds);
    subargo.stn = argo.stn(float_inds);
    subargo.date = argo.date(float_inds);
    subargo.depth = argo.depth(:,float_inds);
    subargo.salinity = argo.salinity(:,float_inds);
    subargo.temperature= argo.temperature(:,float_inds);

end

