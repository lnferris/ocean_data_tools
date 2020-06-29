%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 16-Jun-2020
%  Distributed under the terms of the MIT License

function argo_profiles_map(argo,annotate)

    more_colors()

    figure
    hold on

    % For each unique platform:
    for prof = 1:length(argo.stn) 
        % Plot lat/lon for all profiles.
        plot(argo.lon(prof),argo.lat(prof),'.','MarkerSize',14)
        if nargin == 2 && annotate ==1
            text(argo.lon(prof),argo.lat(prof),string(argo.stn(prof)),'FontSize',6)
        end
    end

    axis([min(argo.lon)-5 max(argo.lon)+5 min(argo.lat)-5 max(argo.lat)+5])
    grid on; grid minor

    title('By Profile');
    if nargin == 2 && annotate ==1
        legend(strcat(cellstr(num2str(argo.stn(:))),' (',cellstr(num2str(argo.id(:))),')')) % Make legend.
    end
    
end
