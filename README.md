# ocean_data_tools 
[![DOI](https://zenodo.org/badge/140592821.svg)](https://zenodo.org/badge/latestdoi/140592821)

Basic scripts that pull data from the local directory or an online server (THREDDS, OPeNDAP, FTP), write them into data structures, and make plots. Please email me (lnferris@alum.mit.edu) with questions or bugs. :-)

Distributed under the terms of the MIT License, Copyright (c) 2018 lnferris


## Contents of Repository

### Copernicus:
##### 1. CopernicusPhys_download (Unix executable)
##### 2. CopernicusTools2D.m (Matlab script)
##### 3. CopernicusTools2D_NoMerge.m (Matlab script)

### HYCOM:
##### 4. HYCOMTools2D.m (Matlab script)
##### 5. HYCOMTools3D.m (Matlab script)
##### 6. HYCOM_slice.m (Matlab script)
##### 7. HYCOM_virtual_cast.m (Matlab function)

### MOCHA:
##### 8. MOCHA_2D.m (Matlab script)

### Argo:
##### 9. Argo_download (Unix executable)
##### 10. ArgoTools.m (Matlab script)
##### 11. ArgoTools.py (Python)

### World Ocean Database:
##### 12. WOD.m (Matlab function)

### GO-SHIP:
##### 13. GOSHIP_unified.m (Matlab script)
##### 14. GOSHIP_CTDO.m (Matlab script)
##### 15. GOSHIP_CTDO.py (Python)
##### 16. GOSHIP_ladcp_w.py (Python)
##### 17. GOSHIP_ladcp_vke.py (Python)
##### 18. GOSHIP_ladcp_w.m (Matlab script)
##### 19. GOSHIP_ladcp_vke.m (Matlab script)
##### 20. GOSHIP_lacdp_uv.m (Matlab script)

### Smith & Sandwell:
##### 21. SSbathymetry.m (Matlab function)
##### 22. SSsection.m (Matlab function)

### Utilities:
##### 23. NetCDF_variables.py (Python)
##### 24. shapeSubset.m (Matlab function)

## Description of Repository

##### 1. CopernicusPhys_download (Unix executable)
Download Copernicus Marine data directly from FTP servers. Go to (http://marine.copernicus.eu/services-portfolio/access-to-products/) and make a Copernicus account. Follow instructions for modifying ~/.netrc file in comments at top of script.

##### 2. CopernicusTools2D.m (Matlab script)

![untitledddd](https://user-images.githubusercontent.com/24570061/61997888-21ba5580-b076-11e9-8173-069534ee0238.png)
![untitleddddd](https://user-images.githubusercontent.com/24570061/61997890-22eb8280-b076-11e9-94d7-663c6267998a.png)

##### 3. CopernicusTools2D_NoMerge.m (Matlab script)
Produces similar end result to CopernicusTools2D.m but avoids merging separate plots over the dateline (at the cost of speed). This is probably more useful when further analysis would be inhibited by splitting the dataset (as in CopernicusTools2D.m).

![vell](https://user-images.githubusercontent.com/24570061/61997915-66de8780-b076-11e9-8dc7-227407fcc564.png)
![sall](https://user-images.githubusercontent.com/24570061/61997916-67771e00-b076-11e9-8edd-67c71e9f741e.png)

##### 4. HYCOMTools2D.m (Matlab script)
Get the data url by visiting https://www.hycom.org/dataserver/gofs-3pt1/analysis. For example, click Access Data Here -> GLBv0.08/expt_57.7 (Jun-01-2017 to Sep-30-2017)/ -> Hindcast Data: Jun-01-2017 to Sep-30-2017. Copy the OPENDAP url. **NOTE: Some HYCOM runs are distributed in -180/180 longitudes, some are in 0/360 longitudes. Add 360 to the input in lines 26 and 27 to accommodate the latter.**

![hycomtools2d velocity-1](https://user-images.githubusercontent.com/24570061/49345157-eda9a480-f64e-11e8-8122-4e3cd6834776.png)
![elev](https://user-images.githubusercontent.com/24570061/49345162-f26e5880-f64e-11e8-8dfe-7770691555ba.png)

##### 5. HYCOMTools3D.m (Matlab script)

![3v](https://user-images.githubusercontent.com/24570061/49357354-ff199d80-f69c-11e8-94fa-d2ca99824cd6.png)
![3t](https://user-images.githubusercontent.com/24570061/49357355-00e36100-f69d-11e8-8594-3ce401f0ad6e.png)

##### 6. HYCOM_slice.m (Matlab script)
Subset HYCOM data at strange angles (without using nctoolbox vslicg or interpolation) and make vertical section plots.

![8](https://user-images.githubusercontent.com/24570061/49703719-910e3280-fbd6-11e8-9f6b-4a032ffb600d.png)
![5](https://user-images.githubusercontent.com/24570061/49703727-b602a580-fbd6-11e8-95ef-040dcaf37686.png)

##### 7. HYCOM_virtual_cast.m (Matlab function)

Create a virtual cast from HYCOM ncgeovariable object (constructed using HYCOMTools2D.m, HYCOMTools3D.m, or HYCOM_slice.m) at a specific point on the domain (lat/lon).

![untitled](https://user-images.githubusercontent.com/24570061/61972979-ea35a580-afb0-11e9-9667-65e256d04479.jpg)
![untitledd](https://user-images.githubusercontent.com/24570061/61972985-edc92c80-afb0-11e9-9e8f-b556a86e31a5.jpg)

##### 8. MOCHA_2D.m (Matlab script)
Plot data from Rutgers MOCHA monthly climatology. 

![ex](https://user-images.githubusercontent.com/24570061/49701723-cc503780-fbbd-11e8-9b34-8e0a64104cca.png)

##### 9. Argo_download (Unix executable)
Download data directly from GDAC FTP servers.

##### 10. ArgoTools.m (Matlab script)
Get Argo data (www.argo.ucsd.edu) using either the Coriolis selection tool (http://www.argodatamgt.org/Access-to-data/Argo-data-selection), the US GDAC (http://www.usgodae.org/cgi-bin/argo_select.pl), or File Transfer Protocal (see Argo_download). Matlab version has more functionality than Python version. Documentation for GSW-Python at (https://teos-10.github.io/GSW-Python/).

![50994659-d92cb14ea-11e9-837a-3609292bf58c](https://user-images.githubusercontent.com/24570061/51057422-8ec33d80-15b3-11e9-82d1-ed214285846f.png)
![u888](https://user-images.githubusercontent.com/24570061/50261389-62fccf80-03da-11e9-99ca-e619c3b71b88.png)

##### 11. ArgoTools.py (Python)

##### 12. WOD.m (Matlab function)
Search and select World Ocean Database data at (https://www.nodc.noaa.gov/OC5/SELECT/dbsearch/dbsearch.html).

![untitled](https://user-images.githubusercontent.com/24570061/61960746-1262db80-af94-11e9-916e-d16bf6fbcd89.jpg)

##### 13. GOSHIP_unified.m (Matlab script)
Load repeat hydrography data (CTD, LADCP) into one uniform data table, organized by station.

##### 14. GOSHIP_CTDO.m (Matlab script)
Get data by choosing a GO-SHIP cruise (https://cchdo.ucsd.edu/search?q=GO-SHIP) and downloading the **CTD** data in **whp_netcdf** format. Documentation for GSW-Python at (https://teos-10.github.io/GSW-Python/).

##### 15. GOSHIP_CTDO.py (Python)

![go](https://user-images.githubusercontent.com/24570061/50993109-d62fc800-14e6-11e9-98f1-0ecada45428e.png)
<img width="300" alt="screen shot 2018-12-02 at 16 18 23" src="https://user-images.githubusercontent.com/24570061/49345122-76741080-f64e-11e8-83dc-3064d23abd00.png">
![sec co](https://user-images.githubusercontent.com/24570061/52182264-8385bb00-27c9-11e9-92b4-0194b77a2415.png)

##### 16. ladcp_w.py (Python)
##### 17. ladcp_vke.py (Python)
##### 18. ladcp_w.m (Matlab script)
##### 19. ladcp_vke.m (Matlab script)
##### 20. lacdp_uv.m (Matlab script)
For LADCP data. Recent data at (ftp://ftp.ldeo.columbia.edu/pub/ant/Data/), older data at (https://currents.soest.hawaii.edu/clivar/ladcp/). Code is written for recent data.

![w](https://user-images.githubusercontent.com/24570061/51152793-62b9ed80-183b-11e9-9756-07cfad5390af.png)
![uv](https://user-images.githubusercontent.com/24570061/51152792-62215700-183b-11e9-9185-9e724cf79756.png)


##### 21. SSbathymetry.m (Matlab function)
Standalone function for adding bathymetry to existing 2D (lat/lon) or 3D (lat/lon/depth) data plots. Download Smith & Sandwell "Global Topography V18.1" (https://topex.ucsd.edu/marine_topo/). **extract1m_modified.m** must be in the path. Example in ArgoTools.m

![bath](https://user-images.githubusercontent.com/24570061/50197983-a4787680-0317-11e9-9b55-5469c914b592.png)

##### 22. SSsection.m (Matlab function)
Standalone function for adding bathymetry to section plots. Example in HYCOM_slice.m

![b](https://user-images.githubusercontent.com/24570061/50329509-99634900-04c5-11e9-8f07-d5286c071b6f.png)

##### 23. NetCDF_variables.py (Python)
Get information about variables contained in one netcdf file in the data directory. Visit (https://exchange-format.readthedocs.io/en/latest/index.html#) for information about whp_netcdf parameters, specific to GO-SHIP.

##### 24. shapeSubset.m (Matlab function)
Subset a dataframe using a polygonal lat/lon region, specificed by coordinates. Dataframe columns should be titled TheTableName.LAT and TheTableName.LON . Out of the box this script works with ArgoTools.m, GOSHIP_CTDO.m, GOSHIP_unified.m, ladcp_uv.m.

![roi](https://user-images.githubusercontent.com/24570061/54892191-f97fd780-4e86-11e9-8518-cbfee9652fc4.png)
