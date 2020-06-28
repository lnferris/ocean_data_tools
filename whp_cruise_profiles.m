%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 28-Jun-2020
%  Distributed under the terms of the MIT License

function whp_cruise_profiles(cruise,variable,zref)

    cvar = eval(['cruise.',variable]);
    zvar = eval(['cruise.',zref]);
    
    if nanmean(zvar,'all') > 0
        zvar = -zvar;
    end
    
    figure
    hold on
    for prof = 1:length(cruise.stn) 
        scatter(cvar(:,prof),zvar(:,prof),'.');  
    end
    hold off
    
    title(variable)
    ylabel(zref)

    if strcmp(variable,'eps_VKE')
        title('epsilon')
        set(gca,'XScale','log')
        
    elseif strcmp(variable,'p0')
        title('Normalized VKE Density, W/kg')
        set(gca,'XScale','log')
        
    end

end
