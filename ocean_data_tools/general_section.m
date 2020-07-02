%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 02-Jul-2020
%  Distributed under the terms of the MIT License

function  general_section(object,variable,xref,zref,interpolate,contours)

    if nargin <6
        contours = 0;
        if nargin<5
            interpolate = 0;
        end
    end

    cvar = eval(['object.',variable]);
    xvar = eval(['object.',xref]);
    zvar = eval(['object.',zref]);
    
    if nanmean(zvar,'all') > 0
        zvar = -zvar;
    end
    
    figure
    hold on

    if interpolate==0
        for prof = 1:length(object.stn)

            if isvector(zvar)
                scatter(xvar(prof)*ones(length(zvar),1),zvar,[],cvar(:,prof),'.')  
            else 
                scatter(xvar(prof)*ones(length(zvar(:,prof)),1),zvar(:,prof),[],cvar(:,prof),'.')
            end
        end

    elseif interpolate ==1
        
        if isvector(zvar)

            [xvar,xvar_inds] = sort(xvar);
            cvar = cvar(:,xvar_inds); 
            X = xvar.*ones(length(zvar),1);
            Y = ones(1,length(xvar)).*-zvar;
            V = cvar; 
        else
            
            [xvar,xvar_inds] = sort(xvar);
            zvar = zvar(:,xvar_inds);
            cvar = cvar(:,xvar_inds);
            X = xvar.*ones(size(zvar,1),1);
            Y = -zvar;
            V = cvar;
        
        end
        
        pcolor(X,-Y,V)
        shading interp

        if contours ==1
            contour(X,-Y,V,'k','ShowText','on')
        end

    end
    
    colorbar
    title(variable, 'Interpreter', 'none')
    xlabel(xref)
    ylabel(zref)
    
    % handle logarithmic whp_cruise variables
    if strcmp(variable,'eps_VKE')
        title('epsilon')
        set(gca,'ColorScale','log') 
    elseif strcmp(variable,'p0')
        title('Normalized VKE Density, W/kg')
        set(gca,'ColorScale','log')    
    end

end
    