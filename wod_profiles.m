%  Author: Laur Ferris
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  Jun 2020; Last revision: 15-Jun-2020
%  Distributed under the terms of the MIT License

function wod_profiles(wod,variable)

xvar = eval(['wod.',variable]);

figure 
    hold on
    x = 1:height(wod); 
    for row = 1:height(wod)    
        tracer = cell2mat(xvar(row,:));
        pres = cell2mat(wod.ALT(row,:));
        plot(tracer,-1*pres,'.');
    end  

end

