%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jul 2020; Last revision: 06-Jul-2020
%  Distributed under the terms of the MIT License

% var3 = 'date'; % var3 is optional, should be a fieldname
% allows consideration of date e.g. avoid removing collocated profiles from different timesteps

function [subobject] = remove_duplicate_profiles(object,var3)

[~,inds_lon,~] = unique(object.lon);
[~,inds_lat,~] = unique(object.lat);
good_inds = union(inds_lon,inds_lat); 

if nargin > 1 
    var3 = eval(['object.',var3]);
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
