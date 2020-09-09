
function argo_profiles_map(argo,annotate)
% argo_profiles_map plots locations of Argo profiles in struct argo,
% coloring markers by profile.
% 
%% Syntax
% 
%  argo_profiles_map(argo)
%  argo_profiles_map(argo,annotate)
% 
%% Description 
%  
% argo_profiles_map(argo) plots locations of Argo profiles in struct argo,
% coloring markers by profile; where argo is a struct created by argo_build.
% The colors of profiles corresponds to those of argo_profiles called on the
% same struct.
%
% argo_profiles_map(argo,annotate) adds number annotations to the markers. by default annotate=0.
% set annotate=1 to turn on annotation. The annotations of profiles correspond to
% those of argo_profiles called on the same struct.
% 
%% Example 1
% Plot locations of the profiles in struct argo:
% 
% annotate = 1; 
% argo_profiles_map(argo,annotate) % annotate optional,  1=on 0=off
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 16-Jun-2020
% 
% See also argo_build and argo_profiles.

    hold on

    % For each unique platform:
    for prof = 1:length(argo.stn) 
        % Plot lat/lon for all profiles.
        h(prof) = plot(argo.lon(prof),argo.lat(prof),'.','MarkerSize',14);
        if nargin == 2 && annotate ==1
            text(argo.lon(prof),argo.lat(prof),string(argo.stn(prof)),'FontSize',10)
        end
    end

    axis([min(argo.lon)-5 max(argo.lon)+5 min(argo.lat)-5 max(argo.lat)+5])
    grid on; grid minor

    title('By Profile');
    if nargin == 2 && annotate ==1
        legend(h,strcat(cellstr(num2str(argo.stn(:))),' (',cellstr(num2str(argo.id(:))),')')) % Make legend.
    end
    
    hold off
end
