
function argo_profiles(argo,variable,annotate)
% argo_profiles plots vertical profiles in struct argo
% 
%% Syntax
% 
%  argo_profiles(argo,variable) 
%  argo_profiles(argo,variable,annotate)
% 
%% Description 
% 
% argo_profiles(argo,variable) plots vertical profiles of the specified variable
% in struct argo as a function of depth (PRES_ADJUSTED); where argo is a struct 
% created by argo_build and variable is a field name.
%  
% argo_profiles(argo,variable,annotate) adds number annotations to the 
% markers by default annotate=0. set annotate=1 to turn on annotation. The 
% annotations of profiles correspond to those of argo_profiles_map called
% on the same struct.
% 
%% Example 1
% Plot temperature vertical profiles in argo:
% 
% variable = 'TEMP_ADJUSTED';
% annotate = 1; 
% argo_profiles(argo,variable,annotate) % annotate optional,  1=on 0=off
%
%% Citation Info 
% github.com/lnferris/ocean_data_tools
% Jun 2020; Last revision: 16-Jun-2020
% 
% See also argo_build and argo_profiles_map.

cvar = eval(['argo.',variable]);

if nanmean(argo.PRES_ADJUSTED,'all') > 0
    
    argo.PRES_ADJUSTED = -argo.PRES_ADJUSTED;
end

figure
hold on

for prof = 1:length(argo.stn) 
    
        scatter(cvar(:,prof),argo.PRES_ADJUSTED(:,prof),'.');  
        
        if nargin == 3 && annotate ==1
            text(cvar(1,prof),argo.PRES_ADJUSTED(1,prof),string(argo.stn(prof)),'FontSize',10)
        end
        
end

    if nargin == 3 && annotate ==1
        legend(strcat(cellstr(num2str(argo.stn(:))),' (',cellstr(num2str(argo.id(:))),')')) % Make legend.
    end

    title([variable,' by profile'], 'Interpreter', 'none')
    ylabel('PRES_ADJUSTED')

end
