## VIMFC as predictor of Extreme Precipitation Events

This repository contains the code and data used in the paper:  
**"Deep Learning-Based Insights into Extreme Precipitation Regional Dynamics over Central Africa Using Moisture Flux Patterns"**  
*Fernand L. Mouassom · Alain T. Tamoffo · Elsa Cardoso-Bihlo, JGR: Atmosphere, 2025*

If you find meaningful errors in the code or have questions, please contact Frances Davenport

## Organization of repository 
* **input_data**: input data used for analysis (not all raw data is included due to size; see details below)
* **notebooks**: jupyter notebooks and python scripts to read and analyze data, and create figures
* **processed_data**: processed data from analysis
* **project_utils**: python utilities used in analysis (see instructions below to install)
* **figures** : placeholder directory for figure png created by running figure notebooks in **notebooks** directory
* environment.yml : specifies python packages needed to run notebooks
* environment_LRP.yml : specifies python packages needed to run the LRP notebook

## data
All the data analyzed in the paper is publicly available at ERA5: 

This include:

* **Daily precipitation (pr)**;
* **Daily Specific humidity (q)**;
* **Daily Surface pressure (sp)**;
* **Daily Zonal wind (u)**;
* **Daily Meridional wind (v)**.
 

Due to the large size of the raw data, they have not been uploaded in this repositry 

## Steps to run the notebooks:
1. download this repository  
2. download pre-processed data [here](https://figshare.com/articles/dataset/Pre-processed_data_for_Davenport_and_Diffenbaugh_2021/14977440) into the processed_data folder. 
3. install the required python modules using conda. The environment.yml and environment_tf1.yml provide information on the required modules. (The environment_tf1.yml files specifies the tensorflow 1 compatible environment needed to calculate the layerwise relevance propagation - see **notebooks** directory for more details)
4. install project_utils in conda environment with the following command (should be run from within the main project directory): 
```bash
pip install -e . --user
```
5. run and/or edit the notebooks. ////////////////
