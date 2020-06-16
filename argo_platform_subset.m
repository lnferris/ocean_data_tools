%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 16-Jun-2020
%  Distributed under the terms of the MIT License

function [subargo] = argo_platform_subset(argo,platform_id)

    float_inds = find(argo.ID==platform_id);

    subargo.ID = argo.ID(float_inds);
    subargo.LON = argo.LON(float_inds);
    subargo.LAT = argo.LAT(float_inds);
    subargo.STN = argo.STN(float_inds);
    subargo.date = argo.date(float_inds);
    subargo.depth = argo.depth(:,float_inds);
    subargo.salinity = argo.salinity(:,float_inds);
    subargo.temperature= argo.temperature(:,float_inds);

end

