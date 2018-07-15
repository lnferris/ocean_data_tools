#!/usr/bin/env python

# Author: Lauren Newell Ferris
# Institute: Virginia Institute of Marine Science
# Email address: lnferris@alum.mit.edu
# Website: https://github.com/lnferris/ocean_data_tools
# Jul 2018; Last revision: 11-Jul-2018
# Distributed under the terms of the MIT License

import os
import datetime
import glob
from netCDF4 import Dataset, chartostring
import numpy as np
import pandas as pd
from mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt

# Converts calendar date to Argo date (days since 1950-01-01).
def ArgoDate(year,month,day):
    d = datetime.date(year, month, day)-datetime.date(1950,1,1)
    return d.days

# Identifies files in local directory that contain matching profiles.
# Returns a list of the full pathnames of these files.
def fileSearch(full_path,SearchLimits,StartDate,EndDate):
    s_lim, n_lim, w_lim, e_lim = SearchLimits[:]
    filename_list = glob.glob(full_path)
    specific_list = []
    for filename in filename_list:
        nc = Dataset(filename)
        try:
            LAT = np.array(nc.variables['LATITUDE'])
            LON = np.array(nc.variables['LONGITUDE'])
            JULD = np.array(nc.variables['JULD'])
            LAT_good_loci = np.where((s_lim <= LAT) & (LAT <= n_lim))
            LON_good_loci = np.where((w_lim <= LON) & (LON <= e_lim))
            JULD_good_loci = np.where((StartDate <= JULD) & (JULD < (EndDate+1)))
            good_profiles = np.intersect1d(np.intersect1d(LAT_good_loci,LON_good_loci),JULD_good_loci)
            if (len(good_profiles) > 0):
                specific_list.append(filename) # Record filename to list.
        except Exception as error_message:
            print(error_message)
            print('Missing data')
        nc.close()
    print('\nMatching files:\n'+'\n'.join(specific_list))
    return(specific_list)

# Checks each profile and writes matching profiles into a pandas dataframe.
# Returns the pandas dataframe.
def getData(specific_list,SearchLimits,StartDate,EndDate,FillValue):
    s_lim, n_lim, w_lim, e_lim = SearchLimits[:]
    Argo_Dataframe = pd.DataFrame(columns=["PRES","PSAL","TEMPR","LAT","LON","JULD","ID"])
    for filename in specific_list:
        print('Searching '+ os.path.basename(filename))
        ncdata = Dataset(filename)
        nProfiles = len(ncdata.dimensions['N_PROF'])
        for profile_index in range(nProfiles):
            try:
                LAT = np.array(ncdata.variables['LATITUDE'])[profile_index]
                LON = np.array(ncdata.variables['LONGITUDE'])[profile_index]
                JULD = np.array(ncdata.variables['JULD'])[profile_index]
                TEMPR = np.array(ncdata.variables['TEMP_ADJUSTED'])[profile_index]
                PSAL = np.array(ncdata.variables['PSAL_ADJUSTED'][profile_index])
                PRES = np.array(ncdata.variables['PRES_ADJUSTED'])[profile_index]
                ID = chartostring(np.array(ncdata.variables['PLATFORM_NUMBER']))[profile_index]
                ID = ID.astype(np.int)
                if (s_lim <= LAT <= n_lim):
                    if (w_lim <= LON <= e_lim):
                        if (StartDate <= JULD < (EndDate+1)):
                            if not all(x == FillValue for x in PRES):
                                Profile_Dataframe = pd.DataFrame({"PRES":[PRES],\
                                        "PSAL":[PSAL],"TEMPR":[TEMPR],"LAT":LAT,\
                                        "LON":LON,"JULD":JULD,"ID":ID},index=[0])
                                Argo_Dataframe= pd.concat([Argo_Dataframe, Profile_Dataframe],\
                                                                             axis=0,sort=False)
            except Exception as error_message:
                print(error_message)
        ncdata.close()
    print(Argo_Dataframe)
    return(Argo_Dataframe)

# Plot latitude vs. longitude of profiles over basemap.
def map_dataframe(Argo_Dataframe,BasemapLimits):
    south, north, west, east = BasemapLimits[:]
    map = Basemap(projection='cyl',llcrnrlon=west,llcrnrlat=south,\
		               urcrnrlon=east,urcrnrlat=north,resolution='l') # c'l'ihf
    map.drawcoastlines()
    map.fillcontinents(color='black',lake_color='white')
    map.drawparallels(np.arange(south,north,5.0))
    map.drawmeridians(np.arange(west,east,5.0))
    plt.title('Profiles in dataframe:')
    plt.plot(Argo_Dataframe.LON,Argo_Dataframe.LAT,marker='.',linestyle='None')
    plt.show()

# Example of how plot salinity vs. depth for each profile in dataframe.
def vertical_profile(Small_Frame,FillValue):
    for index, row in Small_Frame.iterrows():
        psal = np.array(row["PSAL"])
        psal[np.where(psal==FillValue)] = np.nan
        pres = np.array(row["PRES"])
        pres[np.where(pres==FillValue)] = np.nan
        plt.plot(psal,-pres,marker='.',linestyle='None',markersize=1)
    plt.show()

# Example of how to subset dataframe based on values in a column.
def subset_dataframe(Argo_Dataframe):
    return Argo_Dataframe[Argo_Dataframe.ID==5904658]


#___________Example_Script______________________________________________________

SearchLimits= [-40.0, -30.0, -30.0, -10.0] # S N W E [-90.0 90.0 -180.0, 180.0]
StartDate, EndDate = ArgoDate(2016,1,1), ArgoDate(2016,1,15) # YYYY, M, D
full_path = '/Users/username/Desktop/ArgoData/*profiles*.nc' # Data directory.
FillValue = 99999.0 # From Argo manual.
BasemapLimits = [-45.0, -25.0, -35.0, -5.0 ] # Dimensions of lat/lon map.

# Get list of relevant netcdf files.
specific_list = fileSearch(full_path,SearchLimits,StartDate,EndDate)

# Write matching profiles to dataframe.
Argo_Dataframe = getData(specific_list,SearchLimits,StartDate,EndDate,FillValue)

# Map profiles in dataframe.
map_dataframe(Argo_Dataframe,BasemapLimits)

# Access and plot vertical profile data.
vertical_profile(Argo_Dataframe,FillValue)

# Subset dataframe based on platform,day,etc. (see definition).
Small_Frame = subset_dataframe(Argo_Dataframe)
