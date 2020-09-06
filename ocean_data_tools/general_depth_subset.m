
function [subobject] =  general_depth_subset(object,zrange,depth_list)
% general_depth_subset subsets object by depth
% 
%% Syntax
% 
% general_depth_subset(object,zrange)
% general_depth_subset(object,zrange,depth_list)
% 
%% Description 
% 
% [subobject] =  general_depth_subset(object,zrange) subsets
% object by depth-range zrange; where object is a struct 
% created by any of the _build functions in ocean_data_tools (e.g. argo, cruise,
% hycom, mercator, woa, wod). Th default depth-variable 'depth' is used to
% subset. zrange is a 2-element vector e.g. zrange=[0 200] in meters or
% dbar. Order and sign of zrange does not matter.
%
% [subobject] =  general_depth_subset(object,zrange,depth_list) enables the
% user to specify one or more depth variables (instead of using default 'depth')
% e.g. depth_list = {'pressure'} or depth_list = {'pressure','z','depth','depth_vke'};
% 
%% Example 1
% Build a struct out of a transect through HYCOM, including temperature and
% salinity. Subset to include the upper 450 meters:
% 
% source = 'http://tds.hycom.org/thredds/dodsC/GLBv0.08/expt_57.7';
% date = '28-Aug-2017 00:00:00'
% region = [60.0, 70.0 ,-80, -60];  
% depth = -0;    
% model_simple_plot('hycom',source,date,'salinity',region,depth)
% [xcoords,ycoords] = transect_select(100);
% variable_list = {'water_temp','salinity'}; 
% [hycom] = model_build_profiles(source,date,variable_list,xcoords,ycoords);
% object = hycom;
% zrange = [350 150];
% [subobject] =  general_depth_subset(object,zrange);
%
%% Example 2
% Subset all cruise data to include only 150-300 meters:
% 
% variable_list = {'salinity','temperature','oxygen'};
% [cruise] = whp_cruise_build(ctdo_dir,uv_dir,wvke_dir,variable_list); % Use a dummy path (e.g. uv_dir ='null') if missing data. 
% depth_list = {'pressure','z','depth','depth_vke'};
% object = cruise;
% zrange = [350 150];
% [subobject] =  general_depth_subset(object,zrange,depth_list);
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jul 2020; Last revision: 06-Sep-2020
% 
% See also general_region_subset and general_remove_duplicates.

if nargin < 3
    
    depth_list = {'depth'}; % if none, use default depth variable
    
end

        
zmin = min(abs(zrange));
zmax = max(abs(zrange));
prof_dim = length(object.stn);         

% copy struct before overwriting variables of interest

subobject = object;
names = fieldnames(subobject); 
   
% for each depth variable

for var = 1:length(depth_list)
    zvar = object.(depth_list{var});
    sz = size(zvar);
    z_dim = sz(sz~=1&sz~=prof_dim);

    if isvector(zvar)  

        % process uniform depth grid objects (hycom ,mercator, mocha, woa)

        good_row = find(abs(zvar) >= zmin & abs(zvar) <= zmax);   
        for i = 1:length(names) 
            if isvector(subobject.(names{i}))
                if length(subobject.(names{i}))==z_dim 
                    subobject.(names{i}) = subobject.(names{i})(good_row); 
                end
            else
                if size(subobject.(names{i}),1)==z_dim 
                    subobject.(names{i}) = subobject.(names{i})(good_row,:); 
                end
            end
        end

    else

        % process non-uniform depth grid objects (argo, cruise, wod)

        [good_row,~] = find((abs(zvar) >= zmin & abs(zvar) <= zmax));  
        for i = 1:length(names)  
            if size(subobject.(names{i}))==size(zvar)
                subobject.(names{i}) = subobject.(names{i})(min(good_row):max(good_row),:); % truncate
            end
        end
    end
end

end
