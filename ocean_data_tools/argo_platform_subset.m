%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 21-Jun-2020
%  Distributed under the terms of the MIT License

function [subargo] = argo_platform_subset(argo,platform_id)

    in = find(argo.id==platform_id);
    
    prof_dim = length(argo.stn);              
    names = fieldnames(argo);   
    for i = 1:length(names)  
        if isvector(argo.(names{i}))

            if length(argo.(names{i}))==prof_dim
                subargo.(names{i}) = argo.(names{i})(in); 
            else
                subargo.(names{i}) = argo.(names{i});  
            end

        else
            subargo.(names{i}) = argo.(names{i})(:,in);
        end
    end

    
end

