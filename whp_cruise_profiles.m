%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 17-Jun-2020
%  Distributed under the terms of the MIT License

function whp_cruise_profiles(cruise,variable)

    cvar = eval(['cruise.',variable]);

    if strcmp(variable,'CTDSAL') || strcmp(variable,'CTDTMP') || strcmp(variable,'CTDOXY')    
        zvar = eval(['cruise.','CTDPRS']);   
    elseif  strcmp(variable,'U') || strcmp(variable,'V')    
        zvar = eval(['cruise.','Z']);
    elseif  strcmp(variable,'DC_W')    
        zvar = eval(['cruise.','WDEP']);    
    elseif  strcmp(variable,'P0') || strcmp(variable,'EPS')    
        zvar = eval(['cruise.','VKEDEP']);     
    end
    
    if nanmean(zvar,'all') > 0
        zvar = -zvar;
    end
    
    
    figure
    hold on
    for prof = 1:length(cruise.STN) 
        scatter(cvar(:,prof),zvar(:,prof),'.');  
    end
    hold off
    
    title(variable)

    if strcmp(variable,'EPS')
        title('epsilon')
        set(gca,'XScale','log')
        
    elseif strcmp(variable,'P0')
        title('Normalized VKE Density, W/kg')
        set(gca,'XScale','log')
        
    end

end
