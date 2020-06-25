%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 21-Jun-2020
%  Distributed under the terms of the MIT License

function whp_cruise_section(cruise,variable,xref,interpolate,contours)

    if nargin <5
        contours = 0;
        if nargin<4
            interpolate = 0;
        end
    end

   cvar = eval(['cruise.',variable]);
    
    if strcmp(xref,'lon')
        xvar = cruise.lon;
    elseif strcmp(xref,'lat')
        xvar = cruise.lat;
    elseif strcmp(xref,'stn')
        xvar = cruise.stn;
    else
        disp('Check spelling of reference axis');  
    end
    
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

    if interpolate==0
        for prof = 1:length(cruise.stn)
            scatter(xvar(prof)*ones(length(zvar(:,prof)),1),zvar(:,prof),[],cvar(:,prof),'.')
        end
        
    elseif interpolate ==1
    
        [xvar,xvar_inds] = sort(xvar);
        zvar = zvar(:,xvar_inds);
        cvar = cvar(:,xvar_inds);
        
        X = xvar.*ones(size(zvar,1),1);
        Y = -zvar;
        V = cvar;
        
        pcolor(X,-Y,V)
        shading interp

        if contours ==1
            contour(X,-Y,V,'k','ShowText','on')
        end

    end
    
    colorbar
    title(variable)
    xlabel(xref)
    ylabel('depth')

    if strcmp(variable,'EPS')
        title('epsilon')
        set(gca,'ColorScale','log')
        
    elseif strcmp(variable,'P0')
        title('Normalized VKE Density, W/kg')
        set(gca,'ColorScale','log')
        
    end
end
