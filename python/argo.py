#!/usr/bin/env python

#  Author: Laur Ferris
#  Email address: lnferris@alum.mit.edu
#  Website: https://github.com/lnferris/ocean_data_tools
#  Jun 2020; Last revision: 16-Jun-2020
#  Distributed under the terms of the MIT License

import datetime
import glob
import netCDF4
import numpy as np
import pandas as pd
from mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt
import gsw

# ArgoDate() converts calendar date to Argo date (days since 1950-01-01).
def ArgoDate(year,month,day):
    d = datetime.date(year, month, day)-datetime.date(1950,1,1)
    return d.days


# getProfiles() finds files in local directory that contain matching profiles.
# Writes matching profiles into a pandas dataframe.
# Returns a list of the relevant files and the pandas dataframe.
def getProfiles(full_path,SearchLimits,StartDate,EndDate,FillValue):
    s_lim, n_lim, w_lim, e_lim = SearchLimits[:] # Unpack SearchLimits.
    filename_list = glob.glob(full_path) # Search for files in full_path.

    matching_file_list = [] # Make an empty list to hold filenames.
    Argo_Dataframe = pd.DataFrame(columns=["PRES","PSAL","TEMPR","LAT","LON","JULD","ID"]) # Make an empty dataframe to hold profile data.

    for filename in filename_list: # For each file in full_path...
        nc = netCDF4.Dataset(filename) # Call the Dataset constructor.

        try: # Try to read the file.
            LAT = nc.variables['LATITUDE'][:]
            LON = nc.variables['LONGITUDE'][:]
            JULD = nc.variables['JULD'][:]

            # See which profiles have the correct lat,lon,date.
            LAT_good_loci = np.where((s_lim <= LAT) & (LAT <= n_lim))
            LON_good_loci = np.where((w_lim <= LON) & (LON <= e_lim))
            JULD_good_loci = np.where((StartDate <= JULD) & (JULD < (EndDate+1))) # (The "+1" is to include the EndDate.)
            loci_of_good_profiles = np.intersect1d(np.intersect1d(LAT_good_loci,LON_good_loci),JULD_good_loci)

            if (len(loci_of_good_profiles) > 0): # If there is at least one good profile in this file...
                matching_file_list.append(filename) # Record filename to list.
                TEMPR = nc.variables['TEMP_ADJUSTED'][:] # Read all profiles in the file.
                PSAL = nc.variables['PSAL_ADJUSTED'][:]
                PRES = nc.variables['PRES_ADJUSTED'][:]
                ID = netCDF4.chartostring(nc.variables['PLATFORM_NUMBER'][:])
                ID = ID.astype(np.int)

                for locus in loci_of_good_profiles: # Write each good profile into temporary cell array...
                    if not all(x == FillValue for x in PRES[locus]): # As long is profile is not just fill values.
                        Profile_Dataframe = pd.DataFrame({"PRES":[PRES[locus]],"PSAL":[PSAL[locus]],"TEMPR":[TEMPR[locus]],"LAT":LAT[locus],"LON":LON[locus],"JULD":JULD[locus],"ID":ID[locus]},index=[0])
                        Argo_Dataframe= pd.concat([Argo_Dataframe, Profile_Dataframe],axis=0,sort=False) # Combine temporary with general dataframe.

        except Exception as error_message: # Throw an exception if unable to read file.
            print(error_message)

        nc.close() # Close the file.
    print('\nMatching files:\n'+'\n'.join(matching_file_list)) # Print a list of matching files.
    print(Argo_Dataframe) # Print the dataframe.
    print(Argo_Dataframe.shape)
    return(matching_file_list,Argo_Dataframe) # Return the list and the dataframe.


# map_dataframe() plots latitude vs. longitude of profiles over basemap.
def map_dataframe(Argo_Dataframe,BasemapLimits):
    south, north, west, east = BasemapLimits[:]
    map = Basemap(projection='cyl',llcrnrlon=west,llcrnrlat=south,\
		               urcrnrlon=east,urcrnrlat=north,resolution='l') # c'l'ihf (Choose basemap resolution.)
    map.drawcoastlines()
    map.fillcontinents(color='black',lake_color='white')
    map.drawparallels(np.arange(south,north,5.0))
    map.drawmeridians(np.arange(west,east,5.0))
    plt.title('Profiles in dataframe:')
    plt.plot(Argo_Dataframe.LON,Argo_Dataframe.LAT,marker='.',linestyle='None')
    plt.show()


# Example of how plot salinity vs. depth for each profile in dataframe.
def vertical_profile(Argo_Dataframe,FillValue):
    for index, row in Argo_Dataframe.iterrows():
        psal = row["PSAL"]
        pres = row["PRES"]
        psal[np.where(psal==FillValue)] = np.nan
        pres[np.where(pres==FillValue)] = np.nan
        plt.plot(psal,-pres,marker='.',linestyle='None',markersize=1)
    plt.show()

# Calculate and plot density profiles using Thermodynamic Equation of Seawater 2010 (TEOS-10).
def density_profile(Argo_Dataframe):
    for index, row in Argo_Dataframe.iterrows():
        t = row["TEMPR"] #ITS-90
        SP = row["PSAL"] # PSS-78
        p = row["PRES"] # decibar
        t[np.where(t==FillValue)] = np.nan
        SP[np.where(SP==FillValue)] = np.nan
        p[np.where(p==FillValue)] = np.nan
        lon = [row["LON"]]*t.size
        lat = [row["LAT"]]*t.size
        SA = gsw.SA_from_SP(SP, p, lon, lat) #gsw.SA_from_SP(SP, p, lon, lat)
        CT = gsw.CT_from_t(SA,t,p) # gsw.CT_from_t(SA, t, p)
        D = gsw.density.sigma0(SA, CT)# gsw.density.sigma0(SA, CT)
        plt.plot(D+1000,-p,marker='.',linestyle='None',markersize=1)
    plt.show()

# Example of how to subset dataframe based on values in a column.
def subset_dataframe(Argo_Dataframe):
    return Argo_Dataframe[Argo_Dataframe.ID==5904658]


#___________Example_Script______________________________________________________

SearchLimits= [-65.0, -40.0, 150.0, 175.0] # S N W E [-90.0 90.0 -180.0, 180.0]
StartDate, EndDate = ArgoDate(2016,1,1), ArgoDate(2016,1,5) # YYYY, M, D
full_path = '/Users/lnferris/Documents/data/argo/coriolis_25feb2018/*profiles*.nc' # Data directory.
FillValue = 99999.0 # From Argo manual.
BasemapLimits = [-70.0, -35.0, 140.0, 185.0 ] # Dimensions of lat/lon map.

# Get list of relevant netcdf files. Write matching profiles to dataframe.
matching_file_list, Argo_Dataframe = getProfiles(full_path,SearchLimits,StartDate,EndDate,FillValue)

# Map profiles in dataframe.
map_dataframe(Argo_Dataframe,BasemapLimits)

# Access and plot vertical profile data.
vertical_profile(Argo_Dataframe,FillValue)

# Calculate and plot density profiles using Thermodynamic Equation of Seawater 2010 (TEOS-10).
density_profile(Argo_Dataframe)

# Subset dataframe based on platform,day,etc. (see definition).
Small_Frame = subset_dataframe(Argo_Dataframe)
