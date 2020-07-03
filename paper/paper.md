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

# Summary

``ocean_data_tools`` simplifies the process of extracting, formatting, and 
visualizing freely-available oceanographic data. A wealth of oceanographic 
data (from research cruises, autonomous floats, global ocean models, etc.)
is accessible online. However, many oceanographers and environmental 
scientists (particularly those from subdisciplines not accustomed to working
with large datasets) can be dissuaded from utilizing this data because of the
overhead associated with determining out how to batch download data and 
format it into an easily-manipulable data structures. ``ocean_data_tools``
solves this problem by allowing the user to transform common oceanographic 
data sources into uniform structs, call general functions on these structs, 
perform custom calculations, and make graphics.

The workflow of ``ocean_data_tools`` is to build uniform structs (e.g. ``argo``,
``cruise``, ``hycom``, ``mercator``, ``woa``, ``wod``) from raw datasets and 
call general functions on these structs to map, subset, or plot. Functions with 
the ``\_build`` suffix load raw data into uniform structs. Structs are 
compatible with all ``general_`` functions. One application of the ``\_build`` 
feature is to create virtual cruises from model output \autoref{fig:1}. 

![Figure 1. Building a virtual cruise from the Operational Mercator global ocean
analysis and forecast system at 1/12 degree with 3D bathymetry [@Smith:1997]. 
Showing (a) a 3D velocity plot created using ``model_domain_plot``, (b) 
virtual cruise selection using ``transect_select``, and ``model_build_profiles``, 
(c) coordinates of the resulting uniform struct, and (d) a temperature section 
plotted using ``general_section`` with ``bathymetry_section``. Three of the 
subplots use colormaps from cmocean [@Thyng:2016]. \label{fig:1}](figure.png)

The user draws transects on a map (or passes coordinates as an argument) to build casts 
from model data, which may be used as a cruise planning tool or to facilitate 
comparison of observations (such as those from underwater glider surveys) with 
model output. 

``ocean_data_tools`` has already been used in scientific publications [@Bemis:2020] 
and [@Crear:2020]. The toolbox is built for extensibility, and the working plan 
is to continuously add support for additional data sets such as Remote Sensing 
Systems (http://www.remss.com/) products, and European Centre for Medium-Range 
Weather Forecasts (ECMWF) datasets. The source code for ``ocean_data_tools`` has
been archived to Zenodo with the linked DOI: [@Ferris:2020].

# Acknowledgements

The Virginia Institute of Marine Science provided financial support for this project.
I am grateful to Donglai Gong for supporting my interest in open-source software and 
for ongoing mentorship. I also thank the many organizations providing freely-available
data to the oceanography community including (but not limited to) Argo, the HYCOM 
consortium, the Copernicus Programme, the International Global Ship-based Hydrographic
Investigations Program (GO-SHIP), and the National Oceanic and Atmospheric 
Administration (NOAA). This paper is Contribution No.xxxx of the Virginia Institute 
of Marine Science, William & Mary.

# References
