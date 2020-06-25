function [region] = bathymetry_region(object)
region = [min(object.lat)-5 max(object.lat)+5 min(object.lon)-5 max(object.lon)+5];
end
