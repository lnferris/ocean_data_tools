%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 17-Jun-2020
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
cruise.UTC = cell2mat(cruise.UTC);

if min(cruise.LON) < -170 && max(cruise.LON)>170  % if working near dateline wrap to 0/360
    cruise.LON(cruise.LON < 0) = cruise.LON(cruise.LON < 0)+360; 
end  


% find necessary array dimensions
prof_dim = height(cruise);
z_dim = 0;
for prof = 1:height(cruise)   
    new_dim =  max([length(cruise.CTDPRS{prof,:}) length(cruise.Z{prof,:}) length(cruise.WDEP{prof,:}) length(cruise.VKEDEP{prof,:})]);
    if new_dim > z_dim
        z_dim = new_dim;
    end
end

% load table data into arrays
STN = NaN(1,prof_dim);
UTC = NaN(1,prof_dim);
LON = NaN(1,prof_dim);
LAT = NaN(1,prof_dim);
CTDPRS = NaN(z_dim,prof_dim);
CTDTMP = NaN(z_dim,prof_dim);
CTDSAL = NaN(z_dim,prof_dim);
CTDOXY = NaN(z_dim,prof_dim);
Z = NaN(z_dim,prof_dim);
U = NaN(z_dim,prof_dim);
V = NaN(z_dim,prof_dim);
WDEP = NaN(z_dim,prof_dim);
WHAB = NaN(z_dim,prof_dim);
DC_W = NaN(z_dim,prof_dim);
UC_W = NaN(z_dim,prof_dim);
VKEDEP = NaN(z_dim,prof_dim);
VKEHAB = NaN(z_dim,prof_dim);
P0 = NaN(z_dim,prof_dim);
EPS = NaN(z_dim,prof_dim);

for prof = 1:prof_dim
    
    ind_last_ctdo = length(cruise.CTDPRS{prof,:});
    ind_last_uv = length(cruise.Z{prof,:});
    ind_last_w = length(cruise.WDEP{prof,:});
    ind_last_vke = length(cruise.VKEDEP{prof,:});
    
    STN(prof) = cruise.STN(prof);
    LON(prof) = cruise.LON(prof);
    LAT(prof) = cruise.LAT(prof);
    UTC(prof) = cruise.UTC(prof);
    CTDPRS(1:ind_last_ctdo,prof) = cruise.CTDPRS{prof,:};
    CTDTMP(1:ind_last_ctdo,prof) = cruise.CTDTMP{prof,:};
    CTDSAL(1:ind_last_ctdo,prof) = cruise.CTDSAL{prof,:};
    CTDOXY(1:ind_last_ctdo,prof) = cruise.CTDOXY{prof,:};
    Z(1:ind_last_uv ,prof) = cruise.Z{prof,:};
    U(1:ind_last_uv ,prof) = cruise.U{prof,:};
    V(1:ind_last_uv ,prof) = cruise.V{prof,:};
    WDEP(1:ind_last_w,prof) = cruise.WDEP{prof,:};
    WHAB(1:ind_last_w,prof) = cruise.WHAB{prof,:};
    DC_W(1:ind_last_w,prof) = cruise.DC_W{prof,:};
    UC_W(1:ind_last_w,prof) = cruise.UC_W{prof,:};
    VKEDEP(1:ind_last_vke,prof) = cruise.VKEDEP{prof,:};
    VKEHAB(1:ind_last_vke,prof) = cruise.VKEHAB{prof,:};
    P0(1:ind_last_vke,prof) = cruise.P0{prof,:};
    EPS(1:ind_last_vke,prof) = cruise.EPS{prof,:};

end

% output as struct
cruise = struct('STN',STN,'LON',LON,'LAT',LAT,'UTC',UTC,'CTDPRS',CTDPRS,'CTDTMP',CTDTMP,...
                'CTDSAL',CTDSAL,'CTDOXY',CTDOXY,'Z',Z,'U',U,'V',V,'WDEP',WDEP,'WHAB',WHAB,...
                'DC_W',DC_W,'UC_W',UC_W,'VKE_DEP',VKEDEP,'VKE_HAB',VKEHAB,'P0',P0,'EPS',EPS);

end
