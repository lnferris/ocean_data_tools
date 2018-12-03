## ocean_data_tools
Scripts for searching, subsetting, and analyzing ocean data.

### ArgoTools.py
Download Argo data (www.argo.ucsd.edu) using either the Coriolis selection tool (http://www.argodatamgt.org/Access-to-data/Argo-data-selection) or the US GDAC (http://www.usgodae.org/cgi-bin/argo_select.pl). Run this Python script to search your data for profiles in a specific region and date range. Make a map of profile locations. Plot vertical profiles.

### ArgoTools.m
Same as above, but for MATLAB users.

<img width="500" alt="screen shot 2018-12-02 at 16 20 16" src="https://user-images.githubusercontent.com/24570061/49345111-4c225300-f64e-11e8-9cfd-d126c814e5c5.png">

### GOSHIPTools.py
Choose a GO-SHIP cruise (https://cchdo.ucsd.edu/search?q=GO-SHIP) and download the **CTD** data in **whp_netcdf** format. Run this Python script to load the data into a dataframe, subset the data by date/region, map the station locations, or plot vertical profiles.

### GOSHIP_inspect.py
Run this script on one of your downloaded GO-SHIP data files to learn which variables are in the file. Visit (https://exchange-format.readthedocs.io/en/latest/index.html#) for information about whp_netcdf parameters.

<img width="200" alt="screen shot 2018-12-02 at 16 18 12" src="https://user-images.githubusercontent.com/24570061/49345120-74aa4d00-f64e-11e8-9dad-9e2eac5ef1a5.png">
<img width="200" alt="screen shot 2018-12-02 at 16 18 23" src="https://user-images.githubusercontent.com/24570061/49345122-76741080-f64e-11e8-83dc-3064d23abd00.png">

### HYCOMTools2D.m
Get the data url by visiting https://www.hycom.org/dataserver/gofs-3pt1/analysis. For example, click Access Data Here -> GLBv0.08/expt_57.7 (Jun-01-2017 to Sep-30-2017)/ -> Hindcast Data: Jun-01-2017 to Sep-30-2017. Copy the OPENDAP url.

![temp](https://user-images.githubusercontent.com/24570061/49345159-f00bfe80-f64e-11e8-9d03-e6a2b94aa85c.png)
![hycomtools2d velocity-1](https://user-images.githubusercontent.com/24570061/49345157-eda9a480-f64e-11e8-8122-4e3cd6834776.png)
![elev](https://user-images.githubusercontent.com/24570061/49345162-f26e5880-f64e-11e8-8dfe-7770691555ba.png)

### HYCOMTools3D.m

![3v](https://user-images.githubusercontent.com/24570061/49357354-ff199d80-f69c-11e8-94fa-d2ca99824cd6.png)
![3t](https://user-images.githubusercontent.com/24570061/49357355-00e36100-f69d-11e8-8594-3ce401f0ad6e.png)
![in](https://user-images.githubusercontent.com/24570061/49357358-02148e00-f69d-11e8-99a0-368033269a73.png)
