
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
% variable is the string name of the field (of object) to be plotted as the 
% color variable of the section plot
%
% zref is the string name of the field (of object) to be plotted as the 
% depth variable of the section plot
%
% xref is the string name of the field (of object) to be plotted as the 
% horizontal variable of the section plot, usually 'stn', 'lat', or 'lon'.
% Alteratively pass xref = 'km' to plot in along-track distance, assuming 
% spherical earth. If field object.km already exists, this will be used 
% instead of calculating along-track distance.
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
% Jun 2020; Last revision: 22-Sep-2020
% 
% See also shading and general_profiles.

    if nargin <6
        contours = 0;
        if nargin<5
            interpolate = 0;
        end
    end
    
    assert(isstruct(object),'Error: object must be a structure array created by an ocean_data_tools _build function.');
    assert(interpolate == 1 | interpolate == 0,'Error: interpolate=1 (on) or interpolate=0 (off)');
    assert(contours == 1 | contours == 0,'Error: contours=1 (on) or contours=0 (off)');
    assert(isa(variable,'char'),'Error: variable must be a field name (string or character array)');
    assert(isa(xref,'char'),'Error: xref must be a field name (string or character array)');
    assert(isa(zref,'char'),'Error: zref must be a field name (string or character array)');

   
    cvar = object.(variable); 
    zvar = object.(zref);

    if strcmp(xref,'km') && ~isfield(object,'km')
        
        % displacements between stations in degrees
        ddeg = zeros(size(object.stn));
        for prof = 1:length(object.stn)-1
            [ddeg(prof+1),~] = distance(object.lat(prof),object.lon(prof),object.lat(prof+1),object.lon(prof+1));
        end
        
        % convert degrees to kilometers
        dkm = deg2km(ddeg);
        
        % sum previous displacements at each station
        object.km = NaN(size(object.stn));
        for prof = 1:length(object.stn)
            object.km(prof) = sum(dkm(1:prof));
        end
        xvar = object.km;   
        
    else
         xvar = object.(xref);       
    end

    if nanmean(zvar,'all') > 0
        zvar = -zvar;
    end

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
    