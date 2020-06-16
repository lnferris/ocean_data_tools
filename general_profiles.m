%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 16-Jun-2020
%  Distributed under the terms of the MIT License
%  Dependencies: nctoolbox

function general_profiles(object,variable)

cvar = eval(['object.',variable]);

figure
hold on

for i = 1:length(object.STN) 
    scatter(cvar(:,i),object.depth,'k','.');  
end

end

