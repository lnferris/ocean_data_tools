%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 21-Jun-2020
%  Distributed under the terms of the MIT License

function  general_section(object,variable,xref,interpolate,contours)

    if nargin <5
        contours = 0;
        if nargin<4
            interpolate = 0;
        end
    end

    cvar = eval(['object.',variable]);
    zvar = object.depth;
    if nanmean(zvar,'all') > 0
        zvar = -zvar;
    end

    if strcmp(xref,'LON')
        xvar = object.LON;
    elseif strcmp(xref,'LAT')
        xvar = object.LAT;
    elseif strcmp(xref,'STN')
        xvar = object.STN;   
    else
        disp('Check spelling of reference axis');  
    end
    
    figure
    hold on

    if interpolate==0
        for prof = 1:length(object.STN)

            if isvector(zvar)
                scatter(xvar(prof)*ones(length(zvar),1),zvar,[],cvar(:,prof),'.')  
            else 
                scatter(xvar(prof)*ones(length(zvar),1),zvar(:,prof),[],cvar(:,prof),'.')    
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
    title(variable)
    xlabel(xref)
    ylabel('DEPTH')

end
    