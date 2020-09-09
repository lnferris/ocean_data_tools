
function  general_section(object,variable,xref,zref,interpolate,contours)
% general_section makes a section plot of a variable in the struct object
% 
%% Syntax
% 
% general_section(object,variable,xref,zref)
% general_section(object,variable,xref,zref,interpolate)
% general_section(object,variable,xref,zref,interpolate,contours)
% 
%% Description 
% 
% general_section(object,variable,xref,zref) creates a 
% section plot from object; where object is a struct created by any of 
% the _build functions in ocean_data_tools (e.g. argo, cruise, hycom, mercator,
% woa, wod). The color field is specified by variable. xref and zref
% specify fields to use for the x-axis and z-axis.
%
% general_section(object,variable,xref,zref,interpolate) interpolates the
% plot using the shading function. interpolate=1 for on, interpolate=0 for off.
%
% general_section(object,variable,xref,zref,interpolate,contours) adds
% contours to the section plot. contours=1 for on, contours=0 for off.
%
%% Example 1
% Plot a temperature section from a hycom struct:
% 
% object = hycom; % argo, cruise, hycom, mercator, woa, wod
% variable = 'water_temp';
% xref = 'stn'; 
% zref = 'depth'; 
% interpolate = 1; % 1=on 0=off
% contours = 1; % 1=on 0=off
% general_section(object,variable,xref,zref,interpolate,contours)
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 06-Sep-2020
% 
% See also shading and general_profiles.

    if nargin <6
        contours = 0;
        if nargin<5
            interpolate = 0;
        end
    end

    cvar = object.(variable); 
    xvar = object.(xref); 
    zvar = object.(zref);

    if nanmean(zvar,'all') > 0
        zvar = -zvar;
    end
    
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
    xlabel(xref, 'Interpreter', 'none')
    ylabel(zref, 'Interpreter', 'none')
    
    % handle logarithmic whp_cruise variables
    if strcmp(variable,'eps_VKE')
        title('epsilon')
        set(gca,'ColorScale','log') 
    elseif strcmp(variable,'p0')
        title('Normalized VKE Density, W/kg')
        set(gca,'ColorScale','log')    
    end

    hold off
    
end
    