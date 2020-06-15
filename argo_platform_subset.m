%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 15-Jun-2020
%  Distributed under the terms of the MIT License

function [sub_argo] = argo_platform_subset(argo,platform_id)
rows = argo.ID==platform_id;
sub_argo = argo(rows,:);
end
