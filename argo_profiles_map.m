%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 15-Jun-2020
%  Distributed under the terms of the MIT License

function argo_profiles_map(argo,annotate)

    more_colors()

    figure
    hold on

    x = 1:height(argo); % Make vector of short 1..2..3.. labels.
    % For each unique platform:
    for row = 1:height(argo) 
        % Plot lat/lon for all profiles.
        plot(argo.LON(row),argo.LAT(row),'.','MarkerSize',14)
        if nargin == 2 && annotate ==1
            text(argo.LON(row),argo.LAT(row),string(x(row)),'FontSize',6)
        end
    end

    axis([min(argo.LON)-5 max(argo.LON)+5 min(argo.LAT)-5 max(argo.LAT)+5])
    grid on; grid minor

    title('By Profile');
    if nargin == 2 && annotate ==1
        legend(strcat(cellstr(num2str(x(:))),' (',cellstr(num2str(argo.ID(:))),')')) % Make legend.
    end
    
end
