%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 17-Jun-2020
%  Distributed under the terms of the MIT License

function whp_cruise_section(cruise,variable,xref)

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

        if strcmp(xref,'LON')
            xvar = cruise.LON;
        elseif strcmp(xref,'LAT')
            xvar = cruise.LAT;
        elseif strcmp(xref,'STN')
            xvar = cruise.STN;
        else
            disp('Check spelling of reference axis');  
        end

        scatter(xvar(prof)*ones(length(zvar(:,prof)),1),zvar(:,prof),[],cvar(:,prof))

    end
    
    colorbar
    title(variable)
    xlabel(xref)
    ylabel('DEPTH')

    if strcmp(variable,'EPS')
        title('epsilon')
        set(gca,'ColorScale','log')
        
    elseif strcmp(variable,'P0')
        title('Normalized VKE Density, W/kg')
        set(gca,'ColorScale','log')
        
    end

end








