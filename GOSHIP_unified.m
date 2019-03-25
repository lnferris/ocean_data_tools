%%                  INFORMATION

%  Author: Lauren Newell Ferris
%  Institute: Virginia Institute of Marine Science
%  Email address: lnferris@alum.mit.edu
%  Website: https://github.com/lnferris/ocean_data_tools
%  March 2019; Last revision: 24-March-2019
%  Distributed under the terms of the MIT License
%  See function "buildTable" for dateline-crossing nuance.

%%                      LOAD DATA

% GOSHIP ctdo data
ctdo_directory = '/Users/lnferris/Documents/data/goship/ctd_direc';
ctdo_extension = '*.nc';

% LADCP uv data
uv_directory = '/Users/lnferris/Documents/data/goship/processed_uv';
uv_extension = '*.mat';

% LADCP w data
w_directory = '/Users/lnferris/Documents/data/goship/processed_w';
w_extension = '*wprof.nc';

% LADCP vke data
vke_directory = '/Users/lnferris/Documents/data/goship/S04P/processed_w';
vke_extension = '*VKEprof.nc';

% Build unified Datatable
[CTDOtable] = get_ctdo_Stations(ctdo_directory,ctdo_extension);
[UVtable] = get_uv_Stations(uv_directory,uv_extension);
[Wtable] = get_w_Stations(w_directory,w_extension);
[VKEtable] = get_vke_Stations(vke_directory,vke_extension);
[Datatable] = buildTable(CTDOtable,UVtable,Wtable,VKEtable);

%%                  STATION MAP

% Map of stations
figure
plot(Datatable.LON,Datatable.LAT,'.','MarkerSize',14)
grid on; grid minor
hold on
SSbathymetry('/Users/lnferris/Documents/data/bathymetry/topo_18.1.img',[min(Datatable.LAT)-5 max(Datatable.LAT)+5 min(Datatable.LON)-5 max(Datatable.LON)+5],'2Dcontour')
hold off
%%                  SECTION PLOTS

% Salinity, temperature, oxygen sections
sectionCTDO(Datatable);

% LADCP sections
sectionADCP_UV(Datatable)
sectionADCP_wvke(Datatable)

%%                    FUNCTIONS


function [CTDOtable] = get_ctdo_Stations(ctdo_directory,ctdo_extension)
full_path = dir([ctdo_directory ctdo_extension]);
CTDOtable = cell2table(cell(length(full_path),8)); % Make an empty table to hold profile data.
CTDOtable.Properties.VariableNames = {'STN','UTC','LON','LAT','CTDPRS','CTDSAL','CTDTMP','CTDOXY' };  
for i = 1:length(full_path) % For each file in full_path...
    filename = full_path(i).name;
    nc = netcdf.open([ctdo_directory filename], 'NOWRITE'); % Open the file as a netcdf datasource.
    STN = num2str(str2double(netcdf.getVar(nc,netcdf.inqVarID(nc,'station')))); %
    UTC = netcdf.getVar(nc,netcdf.inqVarID(nc,'woce_date'));
    LON = netcdf.getVar(nc,netcdf.inqVarID(nc,'longitude'));
    LAT = netcdf.getVar(nc,netcdf.inqVarID(nc,'latitude'));
    CTDPRS = netcdf.getVar(nc,netcdf.inqVarID(nc,'pressure'));
    CTDSAL = netcdf.getVar(nc,netcdf.inqVarID(nc,'salinity'));
    CTDTMP = netcdf.getVar(nc,netcdf.inqVarID(nc,'temperature'));
    CTDOXY = netcdf.getVar(nc,netcdf.inqVarID(nc,'oxygen')); 
    CTDOtable{i,:} = {STN, UTC, LON, LAT, CTDPRS, CTDSAL, CTDTMP, CTDOXY};
    netcdf.close(nc); % Close the file.  
end
end

function [UVtable] = get_uv_Stations(uv_directory,uv_extension)
full_path = dir([uv_directory uv_extension]);
UVtable = cell2table(cell(length(full_path),4)); % Make an empty table to hold profile data.
UVtable.Properties.VariableNames = {'STN','Z','U','V'};  
for i = 1:length(full_path) % For each file in full_path...
    filename = full_path(i).name; 
    load([uv_directory filename],'-mat');
    STN  = num2str(str2double(filename(1:3))); 
    Z = dr.z;
    U = dr.u;
    V = dr.v;
    UVtable{i,:} = {STN, Z, U, V};
end
end

function [Wtable] = get_w_Stations(w_directory,w_extension)
full_path = dir([w_directory w_extension]);
Wtable = cell2table(cell(length(full_path),5)); % Make an empty table to hold profile data.
Wtable.Properties.VariableNames = {'STN','WDEP','WHAB','DC_W','UC_W'};  
for i = 1:length(full_path) % For each file in full_path...
    filename = full_path(i).name;
    nc = netcdf.open([w_directory filename], 'NOWRITE'); % Open the file as a netcdf datasource.
    STN = num2str(str2double(filename(1:3)));    
    WDEP = netcdf.getVar(nc,netcdf.inqVarID(nc,'depth')); % Depth m
    WHAB = netcdf.getVar(nc,netcdf.inqVarID(nc,'hab')); % Height Above Seabed m
    DC_W = netcdf.getVar(nc,netcdf.inqVarID(nc,'dc_w')); % Downcast Vertical Ocean Velocity m/s
    UC_W = netcdf.getVar(nc,netcdf.inqVarID(nc,'uc_w')); % Upcast Vertical Ocean Velocity, m/s, uc_w(depth)
    Wtable{i,:} = {STN, WDEP, WHAB, DC_W, UC_W};
    netcdf.close(nc); % Close the file.  
end
end

function [VKEtable] = get_vke_Stations(vke_directory,vke_extension)
full_path = dir([vke_directory vke_extension]);
VKEtable = cell2table(cell(length(full_path),5)); % Make an empty table to hold profile data.
VKEtable.Properties.VariableNames = {'STN','VKEDEP','VKEHAB','P0','EPS'}; 
for i = 1:length(full_path) % For each file in full_path...
    filename = full_path(i).name;
    nc = netcdf.open([vke_directory filename], 'NOWRITE'); % Open the file as a netcdf datasource.
    STN = num2str(str2double(filename(1:3)));  
    VKEDEP = netcdf.getVar(nc,netcdf.inqVarID(nc,'depth')); % Window Center Depth, m
    VKEHAB = netcdf.getVar(nc,netcdf.inqVarID(nc,'hab')); % Window Center Height Above Seabed
    P0 = netcdf.getVar(nc,netcdf.inqVarID(nc,'p0')); % Normalized VKE Density, W/kg
    EPS = netcdf.getVar(nc,netcdf.inqVarID(nc,'eps.VKE')); % Turbulent Kinetic Energy Dissipation from Finescale VKE Parameterization
    VKEtable{i,:} = {STN, VKEDEP, VKEHAB, P0, EPS};
    netcdf.close(nc); % Close the file.  
end
end

function [Datatable] = buildTable(CTDOtable,UVtable,Wtable,VKEtable)
Datatable = outerjoin(CTDOtable,UVtable,'MergeKeys',true);  
Datatable = outerjoin(Datatable,Wtable,'MergeKeys',true);  
Datatable = outerjoin(Datatable,VKEtable,'MergeKeys',true);  
Datatable.STN = str2double(Datatable.STN);
Datatable = sortrows(Datatable,1);

Datatable.LON = cell2mat(Datatable.LON);
Datatable.LAT = cell2mat(Datatable.LAT);
Datatable.LON(Datatable.LON < 0) = Datatable.LON(Datatable.LON < 0)+360; % Comment out if not working near dateline. 
end 

function sectionCTDO(Datatable)

t = [];
z = [];
x = [];
for station = 1:height(Datatable) 
    z1 = cell2mat(Datatable.CTDPRS(station,:));
    x1 = Datatable.LON(station)*ones(length(z1),1);
    tracer1 = cell2mat(Datatable.CTDSAL(station,:));
    t = [t; tracer1];
    z = [z;  z1 ];
    x = [x; x1];
end 
figure
scatter(x,-z,[],t);
xlim([min(Datatable.LON)-5 max(Datatable.LON)+5])
colorbar;
title('salinity')

t = [];
z = [];
x = [];
for station = 1:height(Datatable) 
    z1 = cell2mat(Datatable.CTDPRS(station,:));
    x1 = Datatable.LON(station)*ones(length(z1),1);
    tracer1 = cell2mat(Datatable.CTDTMP(station,:));
    t = [t; tracer1];
    z = [z;  z1 ];
    x = [x; x1];
end 
figure
scatter(x,-z,[],t);
xlim([min(Datatable.LON)-5 max(Datatable.LON)+5])
colorbar;
title('temperature')

t = [];
z = [];
x = [];
for station = 1:height(Datatable) 
    z1 = cell2mat(Datatable.CTDPRS(station,:));
    x1 = Datatable.LON(station)*ones(length(z1),1);
    tracer1 = cell2mat(Datatable.CTDOXY(station,:));
    t = [t; tracer1];
    z = [z;  z1 ];
    x = [x; x1];
end 
figure
scatter(x,-z,[],t);
xlim([min(Datatable.LON)-5 max(Datatable.LON)+5])
colorbar;
title('oxygen')
end

function sectionADCP_UV(Datatable)

t = [];
z = [];
x = [];
for station = 1:height(Datatable) 
    z1 = cell2mat(Datatable.Z(station,:));
    x1 = Datatable.LON(station)*ones(length(z1),1);
    tracer1 = cell2mat(Datatable.U(station,:));
    t = [t; tracer1];
    z = [z;  z1 ];
    x = [x; x1];
end 
figure
scatter(x,-z,[],t);
xlim([min(Datatable.LON)-5 max(Datatable.LON)+5])
colorbar;
title('ladcp u')

t = [];
z = [];
x = [];
for station = 1:height(Datatable) 
    z1 = cell2mat(Datatable.Z(station,:));
    x1 = Datatable.LON(station)*ones(length(z1),1);
    tracer1 = cell2mat(Datatable.V(station,:));
    t = [t; tracer1];
    z = [z;  z1 ];
    x = [x; x1];
end 
figure
scatter(x,-z,[],t);
xlim([min(Datatable.LON)-5 max(Datatable.LON)+5])
colorbar;
title('ladcp v')
end

function sectionADCP_wvke(Datatable)

t = [];
z = [];
x = [];
for station = 1:height(Datatable) 
    z1 = cell2mat(Datatable.WDEP(station,:));
    x1 = Datatable.LON(station)*ones(length(z1),1);
    tracer1 = cell2mat(Datatable.DC_W(station,:));
    t = [t; tracer1];
    z = [z;  z1 ];
    x = [x; x1];
end 
figure
scatter(x,-z,[],t);
xlim([min(Datatable.LON)-5 max(Datatable.LON)+5])
colorbar;
title('ladcp w')

t = [];
z = [];
x = [];
for station = 1:height(Datatable) 
    z1 = cell2mat(Datatable.VKEDEP(station,:));
    x1 = Datatable.LON(station)*ones(length(z1),1);
    tracer1 = cell2mat(Datatable.P0(station,:));
    t = [t; tracer1];
    z = [z;  z1 ];
    x = [x; x1];
end 
figure
scatter(x,-z,[],t);
colorbar;
title('Normalized VKE Density, W/kg')

t = [];
z = [];
x = [];
for station = 1:height(Datatable) 
    z1 = cell2mat(Datatable.VKEDEP(station,:));
    x1 = Datatable.LON(station)*ones(length(z1),1);
    tracer1 = cell2mat(Datatable.EPS(station,:));
    t = [t; tracer1];
    z = [z;  z1 ];
    x = [x; x1];
end 
figure
scatter(x,-z,[],t);
cb = colorbar();
cb.Ruler.Scale = 'log';
title('epsilon')
end
