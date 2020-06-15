%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 15-Jun-2020
%  Distributed under the terms of the MIT License

function [cruise] = whp_cruise_load(ctdo_dir,uv_dir,wvke_dir)

% get ctdo stations

[ctdo] = whp_cruise_ctdo(ctdo_dir);

if nargin >= 2

        % get ladcp uv if available    

        [uv] = whp_cruise_uv(uv_dir);

    if nargin == 3

        % also get ladcp w and vke if available   

        [w] = whp_cruise_w(wvke_dir);

        [vke] = whp_cruise_vke(wvke_dir);

    end

end

% merge tables

ctdo.STN = str2double(ctdo.STN);

if exist('uv','var') == 1
    uv.STN = str2double(uv.STN);
    cruise = outerjoin(ctdo,uv,'MergeKeys',true);
    
    if exist('w','var') == 1
        w.STN = str2double(w.STN);
        vke.STN = str2double(vke.STN);
        cruise = outerjoin(cruise,w,'MergeKeys',true);  
        cruise = outerjoin(cruise,vke,'MergeKeys',true);  
    end
end


cruise.LON = cell2mat(cruise.LON);
cruise.LAT = cell2mat(cruise.LAT);

if min(cruise.LON) < -170 && max(cruise.LON)>170  % if working near dateline wrap to 0/360
    cruise.LON(cruise.LON < 0) = cruise.LON(cruise.LON < 0)+360; 
end   

end