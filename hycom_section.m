%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 15-Jun-2020
%  Distributed under the terms of the MIT License

function  hycom_section(hycom,variable,xref)

cvar = eval(['hycom.',variable]);

figure
hold on

for i = 1:length(hycom.STN)

    if strcmp(xref,'LON')
        xvar = hycom.LON;

    elseif strcmp(xref,'LAT')
        xvar = hycom.LAT;

    elseif strcmp(xref,'STN')
        xvar = hycom.STN;
       
    else
        disp('Check spelling of reference axis');  
    end
    
    scatter(xvar(i)*ones(length(hycom.depth),1),hycom.depth,[],cvar(:,i))
   
end

    colorbar
    title(variable)
    xlabel(xref)
    ylabel('DEPTH')

end
