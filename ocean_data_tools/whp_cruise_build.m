
function [cruise] = whp_cruise_build(ctdo_dir,uv_dir,wvke_dir,variable_list)
% whp_cruise_build searches paths ctdo_dir, uv_dir, wvke_dir for relevant profiles and loads them
% into struct cruise
% 
%% Syntax
% 
%  [cruise] = whp_cruise_build(ctdo_dir,uv_dir,wvke_dir,variable_list)
% 
%% Description 
% 
% [cruise] = whp_cruise_build(ctdo_dir,uv_dir,wvke_dir,variable_list)
% searches pathways ctdo_dir, uv_dir, wvke_dir for CTD+ data, horizontal LADCP data,
% and vertical LACDP data respectively. Variable lists for LADCP are fixed,
% while the CTD+ variable list is specified using variable_list (station,woce_date,longitude,
% latitude, and pressure are included automatically.) Lat/lon information (metadata) is
% pulled from the CTD+ files by default. If CTD+ is not found, metadata from LACDP
% files are used instead.
%
% The paths used as arguments should point to data from the
% *same oceanographic cruise*.
%
% ctdo_dir is a character array search path with wildcards. The search path
% should be the path to the CTD netcdf files (in whp_netcdf format) themselves,
% not their directory.
%
% variable_list is a cell array where each element is the
% string name of a variable to be included from CTD files.
%
% uv_dir is a character array search path with wildcards. The search path
% should be the path to the horizontal LADCP data netcdf files themselves, not their directory.
%
% wvke_dir is a character array path to all files in the directory. 
%
% Example paths: 
% ctdo_dir = '/Users/lnferris/Documents/S14/ctd/*.nc'; 
% uv_dir = '/Users/lnferris/Documents/S14/whp_cruise/uv/*.nc';
% wvke_dir = '/Users/lnferris/Documents/S14/whp_cruise/wvke/';
%
% 
%% Example 1
% Load some cuise data from S04P:
%
% ctdo_dir = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/whp_cruise/ctd/*.nc';
% uv_dir = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/whp_cruise/uv/*.nc';
% wvke_dir = '/Users/lnferris/Documents/GitHub/ocean_data_tools/data/whp_cruise/wvke/';
% 
% listing = dir(ctdo_dir); % Peek at netCDF header info to inform choice of variable_list.
% ncdisp([listing(1).folder '/' listing(1).name])
% variable_list = {'salinity','temperature','oxygen'};
% [cruise] = whp_cruise_build(ctdo_dir,uv_dir,wvke_dir,variable_list); % Use a dummy path (e.g. uv_dir ='null') if missing data. 
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 14-Jul-2020
% 
% See also general_section and general_profiles.


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
if abs(max(cruise.lon) - min(cruise.lon)) > 320 % no cruise is 320 degrees, requires a crossing  
    cruise.lon(cruise.lon < 0) = cruise.lon(cruise.lon < 0)+360; 
end  

end
