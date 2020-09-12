
function general_profiles(object,variable,zref)
% general_profiles plots vertical profiles in struct object
% 
%% Syntax
% 
%  general_profiles(object,variable,zref)
% 
%% Description 
% 
% general_profiles(object,variable,zref) plots vertical profiles of the 
% specified variable in struct object as a function of the depth field
% specified by zref; where object is a struct created by any of 
% the _build functions in ocean_data_tools (e.g. argo, cruise, hycom, mercator,
% woa, wod) and variable is a field name.
%
% variable is the string name of the field (of object) to be plotted as the 
% x-variable of the vertical profile
%
% zref is the string name of the field (of object) to be plotted as the 
% depth variable of the vertical profile
% 
%% Example 1
% Plot temperature vertical profiles in argo:
% 
% object = argo;
% variable = 'TEMP_ADJUSTED';
% zref = 'depth';
% general_profiles(object,variable,zref)
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 06-Sep-2020
% 
% See also argo_profiles and general_section.

assert(isstruct(object),'Error: object must be a structure array created by an ocean_data_tools _build function.');
assert(isa(variable,'char'),'Error: variable must be a field name (string or character array)');
assert(isa(zref,'char'),'Error: zref must be a field name (string or character array)');

cvar = object.(variable);
zvar = object.(zref);

if nanmean(zvar,'all') > 0
    zvar = -zvar;
end

hold on

for prof = 1:length(object.stn) 
    
    if isvector(zvar)
    
        scatter(cvar(:,prof),zvar,'.');  
        
    else
        
        scatter(cvar(:,prof),zvar(:,prof),'.');  
        
    end
end

hold off

title(variable, 'Interpreter', 'none')
ylabel(zref, 'Interpreter', 'none')


% handle logarithmic whp_cruise variables
if strcmp(variable,'eps_VKE')
    title('epsilon')
    set(gca,'XScale','log')

elseif strcmp(variable,'p0')
    title('Normalized VKE Density, W/kg')
    set(gca,'XScale','log')

end

end

