function [subobject] = general_remove_duplicates(object,var3)
% general_remove_duplicates removes spatially non-unique profiles in an object
% created using any _build function
% 
%% Syntax
% 
% [subobject] = general_remove_duplicates(object)
% [subobject] = general_remove_duplicates(object,var3)
% 
%% Description 
% 
% [subobject] = general_remove_duplicates(object) removes profiles without
% unique coordinate locations; where object is a struct created by any of 
% the _build functions in ocean_data_tools (e.g. argo, cruise, hycom, mercator,
% woa, wod).  This function can be used to remove duplicates when the user
% built an object using a coordinate list (xcoords, ycoords) that exceeded the
% spatial resolution of the model or other raw data source itself.
%
% [subobject] = general_remove_duplicates(object,var3) uses a third field
% var3 as a uniqueness criterion, usually date. This avoids removing profiles
% with the same coordinate location but unique dates. var3 should be the fieldname
% used to filter the data e.g. var3='date'
% 
% subobject is a struct which is structurally identical to object but contains
% data only spatially-unique (or also var3-unique) profiles

%% Example 1
% Build a struct out of a transect through HYCOM, including temperature and
% salinity. Remove duplicate profiles.
% 
% source = 'http://tds.hycom.org/thredds/dodsC/GLBv0.08/expt_57.7';
% date = '28-Aug-2017 00:00:00'
% xcoords = -75:1/48:-74;
% ycoords = 65:1/48:66;
% variable_list = {'water_temp','salinity'}; 
% [hycom] = model_build_profiles(source,date,variable_list,xcoords,ycoords);
% object = hycom;
% [subobject] = general_remove_duplicates(object);
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jul 2020; Last revision: 06-Sep-2020
% 
% See also transect_select, general_region_subset, and general_depth_subset.

assert(isstruct(object),'Error: object must be a structure array created by an ocean_data_tools _build function.');

[~,inds_lon,~] = unique(object.lon);
[~,inds_lat,~] = unique(object.lat);
good_inds = union(inds_lon,inds_lat); 

if nargin > 1   
    var3 = object.(var3);
    [~,inds_var3,~] = unique(var3);    
    good_inds = union(good_inds,inds_var3); 
end

prof_dim = length(object.stn);              
names = fieldnames(object);   
for i = 1:length(names)  
    if isvector(object.(names{i}))
        
        if length(object.(names{i}))==prof_dim
            subobject.(names{i}) = object.(names{i})(good_inds); 
        else
            subobject.(names{i}) = object.(names{i});  
        end
        
    else
        subobject.(names{i}) = object.(names{i})(:,good_inds);
    end
end

end
