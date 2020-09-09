
function argo_platform_map(argo,annotate)
% argo_platform_map plots locations of Argo profiles in struct argo, coloring markers by platform
% 
%% Syntax
% 
%  argo_platform_map(argo)
%  argo_platform_map(argo,annotate)
% 
%% Description 
% 
% argo_platform_map(argo) plots locations of Argo profiles in argo,
% coloring markers by Argo platform; where argo is a struct created by argo_build.
%  
% argo_platform_map(argo,annotate) adds number annotations to the markers. by default annotate=0.
% set annotate=1 to turn on annotation.
% 
%% Example 1
% Plot locations of the profiles in struct argo:
% 
% annotate = 1; % 1=on 0=off
% argo_platform_map(argo,annotate)
%
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 20-Jul-2020
% 
% See also argo_build and argo_platform_subset.

    hold on

    platformids = unique(argo.id); % Get ids of the platforms.
    x = 1:length(platformids); % Make vector of short 1..2..3.. labels.

    % For each unique platform:
    for i = 1:length(unique(argo.id)) 

        % Plot lat/lon for all profiles.
        h(i) = plot(argo.lon(argo.id==platformids(i)),argo.lat(argo.id==platformids(i)),'.','MarkerSize',14);

        if nargin == 2 && annotate ==1
            text(argo.lon(argo.id==platformids(i)),argo.lat(argo.id==platformids(i)),string(x(i)),'FontSize',10)
        end

    end

    axis([min(argo.lon)-5 max(argo.lon)+5 min(argo.lat)-5 max(argo.lat)+5])
    grid on; grid minor
    title('By platform')
    if nargin == 2 && annotate ==1
        legend(h,strcat(cellstr(num2str(x(:))),' (',cellstr(num2str(platformids(:))),')'))
    end
    
    hold off
end