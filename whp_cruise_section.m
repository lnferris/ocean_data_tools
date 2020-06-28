%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 28-Jun-2020
%  Distributed under the terms of the MIT License

function whp_cruise_section(cruise,variable,xref,zref,interpolate,contours)

    if nargin <6
        contours = 0;
        if nargin<5
            interpolate = 0;
        end
    end

   cvar = eval(['cruise.',variable]);
   xvar = eval(['cruise.',xref]);
   zvar = eval(['cruise.',zref]);
    
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
    ylabel(zref)

    if strcmp(variable,'eps_VKE')
        title('epsilon')
        set(gca,'ColorScale','log')
        
    elseif strcmp(variable,'p0')
        title('Normalized VKE Density, W/kg')
        set(gca,'ColorScale','log')
        
    end
end
