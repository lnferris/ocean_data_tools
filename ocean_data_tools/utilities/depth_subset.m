%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jul 2020; Last revision: 07-Jul-2020
%  Distributed under the terms of the MIT License

% object = hycom; % hycom, mercator, mocha (depth-gridded structs only)
% zref = 'depth';
% zrange = [0 200];

function [subobject] =  depth_subset(object,zref,zrange)

zmin = min(abs(zrange));
zmax = max(abs(zrange));

prof_dim = length(object.stn);     

zvar = eval(['object.',zref]);
sz = size(zvar);
z_dim = sz(sz~=1&sz~=prof_dim);
if isvector(zvar)   
    row = find(abs(zvar) > zmin & abs(zvar) < zmax);   
else
    disp('Struct must contain uniform depth grid.')
    return
end

names = fieldnames(object);   
for i = 1:length(names) 
    if isvector(object.(names{i}))
        if length(object.(names{i}))==z_dim 
            subobject.(names{i}) = object.(names{i})(row); 
        else
            subobject.(names{i}) = object.(names{i});  
        end
    else
        if size(object.(names{i}),1)==z_dim 
            subobject.(names{i}) = object.(names{i})(row,:); 
        else
            subobject.(names{i}) = object.(names{i});
        end
    end
end

end
