
#!/usr/bin/env python

# Author: Lauren Newell Ferris
# Institute: Virginia Institute of Marine Science
# Email address: lnferris@alum.mit.edu
# Website: https://github.com/lnferris/ocean_data_tools
# Aug 2018; Last revision: 3-Aug-2018
# Distributed under the terms of the MIT License

import netCDF4

# Call the dataset constructor for one of the data files.
filename = '/Users/lnferris/Desktop/33RO20150525/33RO20150525_00113_00001_ctd.nc'
dset = netCDF4.Dataset(filename)

# Print information about the variables in the file.
print(dset.variables)


# Sample output.....

#   (u'woce_date', <type 'netCDF4._netCDF4.Variable'>
#   int32 woce_date(time)
#        long_name: WOCE date
#        units: yyyymmdd UTC
#        data_min: 20150527
#       data_max: 20150527
#        C_format: %8d
#   unlimited dimensions:
#   current shape = (1,)
