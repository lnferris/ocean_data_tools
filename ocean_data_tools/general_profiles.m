%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 02-Jul-2020
%  Distributed under the terms of the MIT License

function general_profiles(object,variable,zref)

cvar = eval(['object.',variable]);
zvar = eval(['object.',zref]);

if nanmean(zvar,'all') > 0
    zvar = -zvar;
end

figure
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
ylabel(zref)


% handle logarithmic whp_cruise variables
if strcmp(variable,'eps_VKE')
    title('epsilon')
    set(gca,'XScale','log')

elseif strcmp(variable,'p0')
    title('Normalized VKE Density, W/kg')
    set(gca,'XScale','log')

end

end

