%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 15-Jun-2020
%  Distributed under the terms of the MIT License

function argo_profiles(argo,variable,annotate)

    FillValue = 99999; % From Argo manual.

    xvar = eval(['argo.',variable]);

    figure 
    hold on
    x = 1:height(argo); 
    for row = 1:height(argo)    
        tracer = cell2mat(xvar(row,:));
        pres = cell2mat(argo.PRES(row,:));
        tracer(tracer==FillValue) = NaN;
        pres(pres==FillValue) = NaN;
        plot(tracer,-1*pres,'.');
        if nargin == 3 && annotate ==1
            text(double(tracer(1)),5*row,string(x(row)),'FontSize',8)
        end
    end  
    if nargin == 3 && annotate ==1
        legend(strcat(cellstr(num2str(x(:))),' (',cellstr(num2str(argo.ID(:))),')')) % Make legend.
    end
    
    title([variable,' by profile'])
    
end


