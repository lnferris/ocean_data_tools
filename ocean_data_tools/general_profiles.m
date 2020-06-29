%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 16-Jun-2020
%  Distributed under the terms of the MIT License

function general_profiles(object,variable)

cvar = eval(['object.',variable]);

if nanmean(object.depth,'all') > 0
    
    object.depth = -object.depth;
end

figure
hold on

for prof = 1:length(object.stn) 
    
    if isvector(object.depth)
    
        scatter(cvar(:,prof),object.depth,'.');  
        
    else
        
        scatter(cvar(:,prof),object.depth(:,prof),'.');  
        
    end
end

end

