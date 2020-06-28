%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 28-Jun-2020
%  Distributed under the terms of the MIT License

function [cruise] = whp_cruise_build(ctdo_dir,uv_dir,wvke_dir,variable_list)

% load data
[ctdo] = whp_cruise_ctdo(ctdo_dir,variable_list);
[uv,uv_meta] = whp_cruise_uv(uv_dir);   
[w,w_meta] = whp_cruise_w(wvke_dir);
[vke] = whp_cruise_vke(wvke_dir);

% merge data
tables = {ctdo, uv, w, vke};
marker = 0;
for i = 1:length(tables)
  if height(tables{i})~=0
    cruise = tables{i};
    marker = i;
    break
  end
end
for i = marker+1:length(tables)
  if height(tables{i})~=0
    cruise = outerjoin(cruise,tables{i},'MergeKeys',true);  
  end
end

% use ladcp metadata if ctdo was unavailable
if height(ctdo)==0  
    if height(uv)~=0
        cruise = outerjoin(cruise,uv_meta,'MergeKeys',true);     
    elseif height(w)~=0
        cruise = outerjoin(cruise,w_meta,'MergeKeys',true); 
    end
end

% rename fields for compatability with general_ functions
cruise.Properties.VariableNames{'station'} = 'stn';
try 
    cruise.Properties.VariableNames{'longitude'} = 'lon';
    cruise.Properties.VariableNames{'latitude'} = 'lat';
catch
end

% convert to cell
names = cruise.Properties.VariableNames;
cruise_cell = table2cell(cruise);
clear cruise

% find necessary array dimensions
[sz1,~] = cellfun(@size,cruise_cell);
z_dims = max(sz1,[],1);
prof_dim = size(cruise_cell,1);
var_dim = size(cruise_cell,2);
is_matrix = sz1(1,:)~=1;

% load data into structured array
for var = 1:var_dim
    variable = names{var};
    if is_matrix(var)
        cruise.(variable) = NaN(z_dims(var),prof_dim);
    else
        cruise.(variable) = NaN(1,prof_dim);
    end 

    for prof = 1:prof_dim
        ind_last = sz1(prof,var);  
        dat = cruise_cell(prof,var);
        if is_matrix(var)
            cruise.(variable)(1:ind_last,prof) = dat{:};
        else
            cruise.(variable)(prof) = dat{:};
        end 
    end
end

% if working near dateline wrap to 0/360
if min(cruise.lon) < -170 && max(cruise.lon)>170  
    cruise.lon(cruise.lon < 0) = cruise.lon(cruise.lon < 0)+360; 
end  

end
