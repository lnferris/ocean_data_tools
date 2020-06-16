%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 16-Jun-2020
%  Distributed under the terms of the MIT License

function  general_section(object,variable,xref)

cvar = eval(['object.',variable]);

figure
hold on

for i = 1:length(object.STN)

    if strcmp(xref,'LON')
        xvar = object.LON;

    elseif strcmp(xref,'LAT')
        xvar = object.LAT;

    elseif strcmp(xref,'STN')
        xvar = object.STN;
       
    else
        disp('Check spelling of reference axis');  
    end
    
    scatter(xvar(i)*ones(length(object.depth),1),object.depth,[],cvar(:,i))
   
end

    colorbar
    title(variable)
    xlabel(xref)
    ylabel('DEPTH')

end