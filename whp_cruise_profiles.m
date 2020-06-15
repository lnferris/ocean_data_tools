%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 15-Jun-2020
%  Distributed under the terms of the MIT License

function whp_cruise_profiles(cruise,variable)

    if strcmp(variable,'CTDSAL') || strcmp(variable,'CTDTMP') || strcmp(variable,'CTDOXY')
        
        vertvar = 'CTDPRS';
    
    elseif  strcmp(variable,'U') || strcmp(variable,'V')
        
        vertvar = 'Z';    
    
    elseif  strcmp(variable,'DC_W')
        
        vertvar = 'WDEP';
        
    elseif  strcmp(variable,'P0') || strcmp(variable,'EPS')
        
        vertvar = 'VKEDEP';
        
    end
         
    
    cvar = eval(['cruise.',variable]);
    zvar = eval(['cruise.',vertvar]);
    
    figure
    hold on
    for i = 1:height(cruise) 
        scatter(cell2mat(cvar(i,:)),-cell2mat(zvar(i,:)),'k','.');  
    end
    hold off

    if strcmp(variable,'EPS')
        title('epsilon')
        set(gca,'XScale','log')
        
    elseif strcmp(variable,'P0')
        title('Normalized VKE Density, W/kg')
        set(gca,'XScale','log')
        
    end

end
