%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 16-Jun-2020
%  Distributed under the terms of the MIT License

function argo_profiles_plot(argo,variable,annotate)

more_colors()

cvar = eval(['argo.',variable]);

if nanmean(argo.depth,'all') > 0
    
    argo.depth = -argo.depth;
end

figure
hold on

for prof = 1:length(argo.stn) 
    
        scatter(cvar(:,prof),argo.depth(:,prof),'.');  
        
        if nargin == 3 && annotate ==1
            text(cvar(1,prof),argo.depth(1,prof),string(argo.stn(prof)),'FontSize',8)
        end
        
end

    if nargin == 3 && annotate ==1
        legend(strcat(cellstr(num2str(argo.stn(:))),' (',cellstr(num2str(argo.id(:))),')')) % Make legend.
    end

    title([variable,' by profile'], 'Interpreter', 'none')

end
