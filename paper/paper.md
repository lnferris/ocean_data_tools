---
title: 'ocean_data_tools: A MATLAB toolbox for interacting with bulk freely-available oceanographic data'
tags:
  - MATLAB
  - oceanography
authors:
  - name: Laur Ferris
    orcid: 0000-0001-6446-9340
    affiliation: 1
affiliations:
 - name: Virginia Institute of Marine Science
   index: 1
date: 03 July 2020
bibliography: paper.bib
---

# Statement of Need

``ocean_data_tools`` simplifies the process of extracting, formatting, and 
visualizing freely-available oceanographic data. A wealth of oceanographic 
data (from research cruises, autonomous floats, global ocean models, etc.)
is accessible online. However, many oceanographers and environmental 
scientists (particularly those from subdisciplines not accustomed to working
with large datasets) can be dissuaded from utilizing this data because of the
overhead associated with determining how to batch download data and 
format it into easily-manipulable data structures. ``ocean_data_tools``
solves this problem by allowing the user to transform common oceanographic 
data sources into uniform structure arrays, call general functions on these structure arrays, 
perform custom calculations, and make graphics. 

![Building a virtual cruise from the Operational Mercator global ocean
analysis and forecast system at 1/12 degree with 3D bathymetry [@Smith:1997]. 
Showing (a) a 3D velocity plot created using ``model_domain_plot``, (b) 
virtual cruise selection using ``transect_select``, and ``model_build_profiles``, 
(c) coordinates of the resulting uniform structure array, and (d) a temperature section 
plotted using ``general_section`` with ``bathymetry_section``. Three of the 
subplots use colormaps from cmocean [@Thyng:2016]. \label{fig:1}](figure.png)

# Summary

Structure arrays, the common currency of ``ocean_data_tools``, are more user-friendly than the native data storage underlying many of the datasets because they allow the user to neatly group related data of any type or size into containers called fields. Both the structure array and its fields are mutable, and data is directly visible and accessible in the Matlab workspace (unlike NetCDF which requires a function call to read variables).
Matlab was chosen as the language of choice for this toolbox because it is already extensively used within the oceanographic community.
It is also a primary language for much of the community, which is important because this toolbox aims to lower the barrier to entry for using the growing variety of freely-available field- and model-derived oceanographic datasets.

The workflow of ``ocean_data_tools`` is to build uniform structure arrays (e.g. ``argo``,
``cruise``, ``hycom``, ``mercator``, ``woa``, ``wod``) from raw datasets and 
call general functions on these structure arrays to map, subset, or plot. Functions with 
the ``\_build`` suffix load raw data into uniform structure arrays. Structure arrays are 
compatible with all ``general_`` functions, and serve to neatly contain the data for use with 
custom user-defined calculations or other toolboxes such as the commonly-used
Gibbs-SeaWater (GSW) Oceanographic Toolbox [@McDougall:2011]. One application of the ``\_build`` 
feature is to create virtual cruises from model output \autoref{fig:1}. The user
draws transects on a map (or passes coordinates as an argument) to build vertical profiles 
from model data. This may be used as a cruise planning tool, to facilitate 
comparison of observations with model output, or to support decision-making in underwater glider 
piloting (using model forecasts to inform ballasting or adjust flight for ocean currents).  Some ``ocean_data_tools`` functions
employ ``nctoolbox`` [@nctoolbox].

| Data Source | DOI, Product Code, or Link    |
|:--  |:--|
| Argo floats | [doi:10.17882/42182](https://doi.org/10.17882/42182) |
| Smith & Sandwell bathymetry | [doi:10.1126/science.277.5334.1956](https://doi.org/10.1126/science.277.5334.1956) |
| IOOS Glider DAC | https://gliders.ioos.us/ |
| MOCHA Climatology | [doi:10.7282/T3XW4N4M](https://doi.org/10.7282/T3XW4N4M) |
| HYbrid Coordinate Ocean Model | https://hycom.org |
| CMEMS Global Ocean 1/12° Physics Analysis and Forecast | GLOBAL_ANALYSIS_FORECAST_ PHY_001_024 |
| GO-SHIP hydrographic cruises | https://www.go-ship.org/ |
| World Ocean Atlas 2018 | https://www.ncei.noaa.gov/products/world-ocean-atlas |
| World Ocean Database | https://www.ncei.noaa.gov/products/world-ocean-database |

: Data sources currently supported. \label{table:1}

There are several high-quality ocean and/or climate related Matlab toolboxes such as Climate Data Toolbox for Matlab [@Greene:2019], those part of [SEA-MAT: Matlab Tools for Oceanographic Analysis](https://sea-mat.github.io/sea-mat/), and Gibbs-SeaWater (GSW) Oceanographic Toolbox [@McDougall:2011]. However, there are no other documented and designed-to-be-shared toolboxes filling the same data exploration niche as this one. ``ocean_data_tools`` is unique in encouraging the user to invoke a variety of freely-available data into their exploration and does not expect the user to provide privately-collected measurements or privately-generated model output. It connects users to specific, well-documented data sources Table \ref{table:1}. ``ocean_data_tools`` has already been used for data exploration in support of scientific publications [@Bemis:2020] 
and [@Crear:2020]. This toolbox is built for extensibility; the objective is 
is to welcome contributors and continuously add support for additional datasets such as [Remote Sensing 
Systems](http://www.remss.com/) products and European Centre for Medium-Range 
Weather Forecasts (ECMWF) products. The source code for ``ocean_data_tools`` has
been archived to Zenodo with the linked DOI: [@Ferris:2020].

# Acknowledgements

The Virginia Institute of Marine Science (VIMS) provided financial support for this project.
I am grateful to Donglai Gong for ongoing mentorship. I thank the many organizations providing freely-available
data to the oceanography community including (but not limited to) Argo, the HYCOM 
consortium, the Copernicus Programme, the International Global Ship-based Hydrographic
Investigations Program (GO-SHIP), and the National Oceanic and Atmospheric 
Administration (NOAA). I would also like to thank the two reviewers for helpful feedback, especially 
Kelly Kearney for her insightful suggestions. The figure was generated using E.U. Copernicus Marine Service Information. This paper is VIMS Contribution No.xxxx.

# References
