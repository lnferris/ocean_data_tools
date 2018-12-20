# ocean_data_tools
Scripts for searching, subsetting, and analyzing ocean data. Please consider acknowledgment or collaboration (lnferris@alum.mit.edu) if this is very useful to your project.

### ArgoTools.py (Python)
1. Download Argo data (www.argo.ucsd.edu) using either the Coriolis selection tool (http://www.argodatamgt.org/Access-to-data/Argo-data-selection) or the US GDAC (http://www.usgodae.org/cgi-bin/argo_select.pl). 
2. Run this Python script to search the data for profiles in a specific region and date range. Make plots.

### ArgoTools.m (Matlab)
Slightly more functionality than Python version.

![untitleddd](https://user-images.githubusercontent.com/24570061/50263322-339e9080-03e3-11e9-8288-44484ffc85fa.png)
![u9999](https://user-images.githubusercontent.com/24570061/50261387-61cba280-03da-11e9-8b32-64c218428aa4.png)
![u888](https://user-images.githubusercontent.com/24570061/50261389-62fccf80-03da-11e9-99ca-e619c3b71b88.png)

### Argo_download (Unix executable)
This is an alternative to using the Argo data selections tools. Download data directly from GDAC FTP servers using this shell script.

### GOSHIP_CTDO.py (Python)
1. Choose a GO-SHIP cruise (https://cchdo.ucsd.edu/search?q=GO-SHIP) and download the **CTD** data in **whp_netcdf** format. 
2. Run this Python script to load the data into a dataframe, subset the data by date/region, map the station locations, or plot vertical profiles.

<img width="250" alt="screen shot 2018-12-02 at 16 18 12" src="https://user-images.githubusercontent.com/24570061/49345120-74aa4d00-f64e-11e8-9dad-9e2eac5ef1a5.png">

<img width="250" alt="screen shot 2018-12-02 at 16 18 23" src="https://user-images.githubusercontent.com/24570061/49345122-76741080-f64e-11e8-83dc-3064d23abd00.png">

### GOSHIP_peek.py (Python)
Run this script on **one** of the downloaded files to get information about variables in the file. Visit (https://exchange-format.readthedocs.io/en/latest/index.html#) for information about whp_netcdf parameters.

### HYCOMTools2D.m (Matlab)
1. Get the data url by visiting https://www.hycom.org/dataserver/gofs-3pt1/analysis. For example, click Access Data Here -> GLBv0.08/expt_57.7 (Jun-01-2017 to Sep-30-2017)/ -> Hindcast Data: Jun-01-2017 to Sep-30-2017. Copy the OPENDAP url.
2. Paste into script and run.

![hycomtools2d velocity-1](https://user-images.githubusercontent.com/24570061/49345157-eda9a480-f64e-11e8-8122-4e3cd6834776.png)

![elev](https://user-images.githubusercontent.com/24570061/49345162-f26e5880-f64e-11e8-8dfe-7770691555ba.png)

### HYCOMTools3D.m (Matlab)

![3v](https://user-images.githubusercontent.com/24570061/49357354-ff199d80-f69c-11e8-94fa-d2ca99824cd6.png)

![3t](https://user-images.githubusercontent.com/24570061/49357355-00e36100-f69d-11e8-8594-3ce401f0ad6e.png)

### HYCOM_slice.m (Matlab)

Subset HYCOM data at strange angles (without using nctoolbox vslicg or interpolation) and make vertical section plots.

![8](https://user-images.githubusercontent.com/24570061/49703719-910e3280-fbd6-11e8-9f6b-4a032ffb600d.png)

![5](https://user-images.githubusercontent.com/24570061/49703727-b602a580-fbd6-11e8-95ef-040dcaf37686.png)

### MOCHA_2D.m (Matlab)
Plot data from Rutgers MOCHA monthly climatology. 

![ex](https://user-images.githubusercontent.com/24570061/49701723-cc503780-fbbd-11e8-9b34-8e0a64104cca.png)

### SSbathymetry.m (Matlab)
This is a standalone function; use it to add bathymetry to other 2D (lat/lon) or 3D (lat/lon/depth) data plots. Download Smith & Sandwell "Global Topography V18.1" (https://topex.ucsd.edu/marine_topo/). Make sure **extract1m_modified.m** is in the path. 

![bath](https://user-images.githubusercontent.com/24570061/50197983-a4787680-0317-11e9-9b55-5469c914b592.png)

