%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 16-Jun-2020
%  Distributed under the terms of the MIT License

function  general_section(object,variable,xref)

cvar = eval(['object.',variable]);

if nanmean(object.depth,'all') > 0
    
    object.depth = -object.depth;
end

figure
hold on

for prof = 1:length(object.STN)

    if strcmp(xref,'LON')
        xvar = object.LON;

    elseif strcmp(xref,'LAT')
        xvar = object.LAT;

    elseif strcmp(xref,'STN')
        xvar = object.STN;
       
    else
        disp('Check spelling of reference axis');  
    end
    
    if isvector(object.depth)
    
        scatter(xvar(prof)*ones(length(object.depth),1),object.depth,[],cvar(:,prof))
    
    else
        
        scatter(xvar(prof)*ones(length(object.depth),1),object.depth(:,prof),[],cvar(:,prof))
        
    end
   
end

    colorbar
    title(variable)
    xlabel(xref)
    ylabel('DEPTH')

end