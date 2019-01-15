
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

    Hydro_Dataframe = pd.DataFrame(columns=["DEP","P0","EPS"]) # Make an empty dataframe to hold profile data.

    for filename in filename_list: # For each file in full_path...
        nc = netCDF4.Dataset(filename) # Call the Dataset constructor.

        #'widx'# Window Index, m
        DEP = np.array(nc.variables['depth']) # Window Center Depth, m
        #'depth.min'# Window Min Depth, m
        #'depth.max'# Window Max Depth, m
        HAB = np.array(nc.variables['hab']) # Window Center Height Above Seabed
        #'nspec'# Number of Input Spectra in Window
        P0 = np.array(nc.variables['p0']) # Normalized VKE Density, W/kg
        #'p0fit.rms'# RMS Errror from Power-Law VKE Fit
        #'p0fit.r'# Correlation Coefficient from Power-Law VKE Fit
        #'p0fit.slope'# Slope from Power-Law VKE Fit
        #'p0fit.slope.sig '# Slope Uncertainty (Standard Deviation) from Power-Law VKE Fit
        EPS = np.array(nc.variables['eps.VKE'])# Turbulent Kinetic Energy Dissipation from Finescale VKE Parameterization

        Station_Dataframe = pd.DataFrame({"DEP":[DEP],"P0":[P0],"EPS":[EPS]},index=[0]) # Write station into a temporary dataframe.
        Hydro_Dataframe= pd.concat([Hydro_Dataframe, Station_Dataframe],axis=0,sort=False) # Combine temporary with general dataframe.

        nc.close() # Close the file.

    print(Hydro_Dataframe) # Print the dataframe.
    print(Hydro_Dataframe.shape)
    return(Hydro_Dataframe) # Return the list and the dataframe.

def vertical_profile(Hydro_Dataframe):
    for index, row in Hydro_Dataframe.iterrows():
        tracer = np.array(row["EPS"])
        pres = np.array(row["DEP"])
        #plt.plot(tracer,-pres,marker='.',markersize=1)
        plt.semilogx(tracer,-pres,marker='.',markersize=1,LineStyle='None')
    plt.show()

#___________Example_Script______________________________________________________

full_path = '/Users/lnferris/Desktop/processed_w_20181230/*VKEprof.nc' # Data directory.

# Write station data from files in full_path to dataframe.
Hydro_Dataframe = getStations(full_path)

# Access and plot vertical profile data.
vertical_profile(Hydro_Dataframe)
