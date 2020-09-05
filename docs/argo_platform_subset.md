### argo_platform_subset

#### Syntax

```Matlab
[subargo] = argo_platform_subset(argo,platform_id) 
```
#### Description

``[subargo] = argo_platform_subset(argo,platform_id)`` subsets ``argo`` by Argo platform ID into struct ``subargo``; where ``argo`` is a struct created by ``argo_build`` and platform_id is the integer ID


#### Example 1

```Matlab
% Plot locations of Argo profiles:
argo_platform_map(argo,1)
bathymetry_plot(bathymetry_dir,bounding_region(argo),'2Dcontour')
```

<img src="https://user-images.githubusercontent.com/24570061/88316847-6955da80-cce6-11ea-8bb0-d9d0523a3a29.png" width="700">

```Matlab
% Subset by platform:

platform_id = 5904421;
[subargo] = argo_platform_subset(argo,platform_id);

% Make a new plot:

argo_platform_map(subargo,1)
bathymetry_plot(bathymetry_dir,bounding_region(argo),'2Dcontour')

```

<img src="https://user-images.githubusercontent.com/24570061/88324607-ec306280-ccf1-11ea-8f9a-81320046ccf4.png" width="700">

[Back](https://github.com/lnferris/ocean_data_tools#additional-functions-for-inspecting-argo-data-1)

