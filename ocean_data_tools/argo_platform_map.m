%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 16-Jun-2020
%  Distributed under the terms of the MIT License

function argo_platform_map(argo,annotate)

    more_colors()

    figure
    hold on

    platformids = unique(argo.id); % Get ids of the platforms.
    x = 1:length(platformids); % Make vector of short 1..2..3.. labels.

    % For each unique platform:
    for i = 1:length(unique(argo.id)) 

        % Plot lat/lon for all profiles.
        plot(argo.lon(argo.id==platformids(i)),argo.lat(argo.id==platformids(i)),'.','MarkerSize',14)

        if nargin == 2 && annotate ==1
            text(argo.lon(argo.id==platformids(i)),argo.lat(argo.id==platformids(i)),string(x(i)),'FontSize',6)
        end

    end

    axis([min(argo.lon)-5 max(argo.lon)+5 min(argo.lat)-5 max(argo.lat)+5])
    grid on; grid minor
    title('By platform')
    if nargin == 2 && annotate ==1
        legend(strcat(cellstr(num2str(x(:))),' (',cellstr(num2str(platformids(:))),')')) % Make legend.
    end
    
end