%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 15-Jun-2020
%  Distributed under the terms of the MIT License
%  Dependencies: nctoolbox

function hycom_profiles(hycom,variable)

cvar = eval(['hycom.',variable]);

figure
hold on

for i = 1:length(hycom.STN) 
    scatter(cvar(:,i),hycom.depth,'k','.');  
end

end

