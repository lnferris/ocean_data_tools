%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 20-Jun-2020
%  Distributed under the terms of the MIT License

function whp_cruise_profiles(cruise,variable)

    cvar = eval(['cruise.',variable]);
    
    ctd_vars = {'CTDSAL','CTDTMP','CTDOXY'};
    uv_vars  = {'U','V'};
    w_vars   = {'DC_W'};
    vke_vars = {'P0','EPS'};
    
    if any(strcmp(ctd_vars,variable))
        zvar = eval(['cruise.','CTDPRS']);   
        
    elseif  any(strcmp(uv_vars,variable))  
        zvar = eval(['cruise.','Z']);
        
    elseif  any(strcmp(w_vars,variable))   
        zvar = eval(['cruise.','WDEP']);    
        
    elseif  any(strcmp(vke_vars,variable))   
        zvar = eval(['cruise.','VKE_DEP']);     
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
