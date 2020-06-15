%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 15-Jun-2020
%  Distributed under the terms of the MIT License

function argo_platform_map(argo,annotate)

    more_colors()

    figure
    hold on

    platformIDs = unique(argo.ID); % Get IDs of the platforms.
    x = 1:length(platformIDs); % Make vector of short 1..2..3.. labels.

    % For each unique platform:
    for i = 1:length(unique(argo.ID)) 

        % Plot lat/lon for all profiles.
        plot(argo.LON(argo.ID==platformIDs(i)),argo.LAT(argo.ID==platformIDs(i)),'.','MarkerSize',14)

        if nargin == 2 && annotate ==1
            text(argo.LON(argo.ID==platformIDs(i)),argo.LAT(argo.ID==platformIDs(i)),string(x(i)),'FontSize',6)
        end

    end

    axis([min(argo.LON)-5 max(argo.LON)+5 min(argo.LAT)-5 max(argo.LAT)+5])
    grid on; grid minor
    title('By platform')
    if nargin == 2 && annotate ==1
        legend(strcat(cellstr(num2str(x(:))),' (',cellstr(num2str(platformIDs(:))),')')) % Make legend.
    end
    
end