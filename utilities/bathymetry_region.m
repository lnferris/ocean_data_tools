function [region] = bathymetry_region(object)
region = [min(object.LAT)-5 max(object.LAT)+5 min(object.LON)-5 max(object.LON)+5];
end
