%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 15-Jun-2020
%  Distributed under the terms of the MIT License

function whp_cruise_section(cruise,variable,xref)

    if strcmp(variable,'CTDSAL') || strcmp(variable,'CTDTMP') || strcmp(variable,'CTDOXY')
        
        vertvar = 'CTDPRS';
    
    elseif  strcmp(variable,'U') || strcmp(variable,'V')
        
        vertvar = 'Z';    
    
    elseif  strcmp(variable,'DC_W')
        
        vertvar = 'WDEP';
        
    elseif  strcmp(variable,'P0') || strcmp(variable,'EPS')
        
        vertvar = 'VKEDEP';
        
    end
         
    t_var = eval(['cruise.',variable]);
    z_var = eval(['cruise.',vertvar]);
    x_var = eval(['cruise.',xref]);
    
    c = []; 
    z = []; 
    x = [];
    for station = 1:height(cruise) 
        z_temp = cell2mat(z_var(station,:));
        x_temp = x_var(station)*ones(length(z_temp),1);
        c_temp = cell2mat(t_var(station,:));
        c = [c; c_temp];
        z = [z;  z_temp ];
        x = [x; x_temp];
    end 
    
    figure
    scatter(x,-z,[],c);
    xlim([min(x_var)-5 max(x_var)+5])
    colorbar;
    title(variable)
    xlabel(xref)
    ylabel(vertvar)
    colorbar
    
    if strcmp(variable,'EPS')
        title('epsilon')
        set(gca,'ColorScale','log')
        
    elseif strcmp(variable,'P0')
        title('Normalized VKE Density, W/kg')
        set(gca,'ColorScale','log')
        
    end

end
