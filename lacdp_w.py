
#!/usr/bin/env python

# Author: Lauren Newell Ferris
# Institute: Virginia Institute of Marine Science
# Email address: lnferris@alum.mit.edu
# Website: https://github.com/lnferris/ocean_data_tools
# Aug 2018; Last revision: 10-Jan-2019
# Distributed under the terms of the MIT License

import datetime
import glob
import netCDF4
import numpy as np
import pandas as pd
from mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt


# getStations() finds files in local directory that match full_path.
# Writes stations into a pandas dataframe and returns dataframe.
def getStations(full_path):
    filename_list = glob.glob(full_path) # Search for files in full_path.
    print('\nMatching files:\n'+'\n'.join(filename_list)) # Print a list of matching files.

    Hydro_Dataframe = pd.DataFrame(columns=["DEP","HAB","DC_EL","DC_W","UC_W"]) # Make an empty dataframe to hold profile data.

    for filename in filename_list: # For each file in full_path...
        nc = netCDF4.Dataset(filename) # Call the Dataset constructor.

        DEP = np.array(nc.variables['depth']) # Depth m
        HAB = np.array(nc.variables['hab']) # Height Above Seabed m
        DC_EL = np.array(nc.variables['dc_elapsed']) # Downcast Elapsed Time
        DC_W = np.array(nc.variables['dc_w']) # Downcast Vertical Ocean Velocity m/s
        # Downcast Mean Absolute Deviation in Bin
        # Downcast Number of Samples in Bin
        # Upcast Elapsed Time
        UC_W = np.array(nc.variables['uc_w']) # Upcast Vertical Ocean Velocity, m/s, uc_w(depth)
        # Upcast Mean Absolute Deviation in Bin, uc_w.mad(depth)
        # Upcast Number of Samples in Bin, uc_w.nsamp(depth)

        Station_Dataframe = pd.DataFrame({"DEP":[DEP],"HAB":[HAB],"DC_EL":[DC_EL],"DC_W":[DC_W],"UC_W":[UC_W]},index=[0]) # Write station into a temporary dataframe.
        Hydro_Dataframe= pd.concat([Hydro_Dataframe, Station_Dataframe],axis=0,sort=False) # Combine temporary with general dataframe.

        nc.close() # Close the file.

    print(Hydro_Dataframe) # Print the dataframe.
    print(Hydro_Dataframe.shape)
    return(Hydro_Dataframe) # Return the list and the dataframe.

def vertical_profile(Hydro_Dataframe):
    for index, row in Hydro_Dataframe.iterrows():
        tracer = np.array(row["UC_W"])
        pres = np.array(row["DEP"])
        plt.plot(tracer,-pres,marker='.',markersize=1,linestyle='None')
    plt.show()

#___________Example_Script______________________________________________________

full_path = '/Users/lnferris/Desktop/processed_w_20181230/*wprof.nc' # Data directory.

# Write station data from files in full_path to dataframe.
Hydro_Dataframe = getStations(full_path)

# Access and plot vertical profile data.
vertical_profile(Hydro_Dataframe)
