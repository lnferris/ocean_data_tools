
#!/usr/bin/env python

# Author: Lauren Newell Ferris
# Institute: Virginia Institute of Marine Science
# Email address: lnferris@alum.mit.edu
# Website: https://github.com/lnferris/ocean_data_tools
# Aug 2018; Last revision: 03-Feb-2019
# Distributed under the terms of the MIT License

import datetime
import glob
import netCDF4
import numpy as np
import pandas as pd
from mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt
import gsw

# getStations() finds files in local directory that match full_path.
# Writes stations into a pandas dataframe and returns dataframe.
def getStations(full_path):
    filename_list = glob.glob(full_path) # Search for files in full_path.
    print('\nMatching files:\n'+'\n'.join(filename_list)) # Print a list of matching files.

    Hydro_Dataframe = pd.DataFrame(columns=["CTDPRS","CTDSAL","CTDTMP","CTDOXY","LAT","LON","UTC"]) # Make an empty dataframe to hold profile data.

    for filename in filename_list: # For each file in full_path...
        nc = netCDF4.Dataset(filename) # Call the Dataset constructor.

        LAT = nc.variables['latitude'][:]
        LON = nc.variables['longitude'][:]
        CTDTMP = nc.variables['temperature'][:]
        CTDSAL = nc.variables['salinity'][:]
        CTDPRS = nc.variables['pressure'][:]
        CTDOXY = nc.variables['oxygen'][:]
        UTC = nc.variables['woce_date'][:]

        Station_Dataframe = pd.DataFrame({"CTDPRS":[CTDPRS],"CTDSAL":[CTDSAL],"CTDTMP":[CTDTMP],"CTDOXY":[CTDOXY],"LAT":LAT,"LON":LON,"UTC":UTC},index=[0]) # Write station into a temporary dataframe.
        Hydro_Dataframe= pd.concat([Hydro_Dataframe, Station_Dataframe],axis=0,sort=False) # Combine temporary with general dataframe.

        nc.close() # Close the file.

    # Convert WOCE date (YYYMMDD integer format) into a datetime variable.
    Hydro_Dataframe['UTC'] =  pd.to_datetime(Hydro_Dataframe['UTC'], format='%Y%m%d')

    print(Hydro_Dataframe) # Print the dataframe.
    print(Hydro_Dataframe.shape)
    return(Hydro_Dataframe) # Return the list and the dataframe.


# map_dataframe() plots latitude vs. longitude of profiles over basemap.
def map_dataframe(Hydro_Dataframe,BasemapLimits):
    south, north, west, east = BasemapLimits[:]
    map = Basemap(projection='cyl',llcrnrlon=west,llcrnrlat=south,urcrnrlon=east,urcrnrlat=north,resolution='l') # c'l'ihf (Choose basemap resolution.)
    map.drawcoastlines()
    map.fillcontinents(color='black',lake_color='white')
    map.drawparallels(np.arange(south,north,5.0))
    map.drawmeridians(np.arange(west,east,5.0))
    plt.plot(Hydro_Dataframe.LON,Hydro_Dataframe.LAT,marker='.',linestyle='None')
    plt.show()


# Example of how plot oxygen vs. depth for each station in dataframe.
def vertical_profile(Hydro_Dataframe):
    for index, row in Hydro_Dataframe.iterrows():
        tracer = row["CTDOXY"]
        pres = row["CTDPRS"]
        plt.plot(tracer,-pres,marker='.',linestyle='None',markersize=1)
    plt.show()

# Calculate and plot density profiles using Thermodynamic Equation of Seawater 2010 (TEOS-10).
def density_profile(Hydro_Dataframe):
    for index, row in Hydro_Dataframe.iterrows():
        t = row["CTDTMP"] #ITS-90
        SP = row["CTDSAL"] # PSS-78
        p = row["CTDPRS"] # decibar
        lon = [row["LON"]]*t.size
        lat = [row["LAT"]]*t.size
        SA = gsw.SA_from_SP(SP, p, lon, lat) #gsw.SA_from_SP(SP, p, lon, lat)
        CT = gsw.CT_from_t(SA,t,p) # gsw.CT_from_t(SA, t, p)
        D = gsw.density.sigma0(SA, CT)# gsw.density.sigma0(SA, CT)
        plt.plot(D+1000,-p,marker='.',linestyle='None',markersize=1)
    plt.show()

# Example of how to subset dataframe by date of data collection.
def subset_by_date(Hydro_Dataframe):
    date1 = datetime.datetime(2015, 6, 15)
    date2 = datetime.datetime(2016, 6, 25)
    return Hydro_Dataframe[ (Hydro_Dataframe.UTC >= date1) & (Hydro_Dataframe.UTC <= date2 ) ]

# Example of how to subset dataframe by location of station.
def subset_by_region(Hydro_Dataframe):
    lat_s = 48.0 # [-90.0 90.0]
    lat_n = 60.0
    lon_w = -160.0 # [-180.0 180.0]
    lon_e = -145.0
    return Hydro_Dataframe[ (Hydro_Dataframe.LAT >= lat_s) & (Hydro_Dataframe.LAT <= lat_n ) & \
                            (Hydro_Dataframe.LON >= lon_w) & (Hydro_Dataframe.LON <= lon_e)]


#___________Example_Script______________________________________________________

full_path = '/Users/lnferris/Documents/data/goship/P16N/*.nc'
BasemapLimits = [40.0, 65.0, -155.0, -125.0] # Dimensions of lat/lon map.

# Write station data from files in full_path to dataframe.
Hydro_Dataframe = getStations(full_path)

# Map profiles in dataframe.
map_dataframe(Hydro_Dataframe,BasemapLimits)

# Access and plot vertical profile data.
vertical_profile(Hydro_Dataframe)

# Calculate and plot density profiles using Thermodynamic Equation of Seawater 2010 (TEOS-10).
density_profile(Hydro_Dataframe)

# Subset dataframe by date.
Small_Date_Frame = subset_by_date(Hydro_Dataframe)

# Subset dataframe by location of station.
Small_Region_Frame = subset_by_region(Hydro_Dataframe)
