# WRF-Hydro <img src="https://ral.ucar.edu/sites/default/files/public/wrf_hydro_symbol_logo_2017_09_150pxby63px.png" width=100 align="left" />

# WPS container 

# Overview
This container is used primarily to create geogrid files for a specified domain to be used with the WRF-Hydro modeling system. It also generates wrfinput files (these files are used to specify the initial conditions for the land surface model in WRF-Hydro) and maps of the specified model domain.

There are both standard and training versions of this container.  The former run as a service using the directions posted here and the latter include the JupyterLab server allowing users to work with the container interactively and through training notebooks.

The containers include the following:

* Ubuntu base image
* WRF and WPS v3.9 built with the GNU Fortran compiler ‘gfortran’
* Python 3.6 command line utility for creating WRF-Hydro geogrid files using the WPS geogrid.exe program
* WRF-WPS geographical input data for the contiguous United States **ONLY USGS+DEFAULT DATASETS ARE SUPPORTED, lai_modis_30s, nlcd2011_30m, and topo_30s are subsets for training purposes only**

## Where to get help and/or post issues
If you have general questions about Docker, there are ample online resources including the excellent Docker documentation at https://docs.docker.com/.

The best place ask questions or post issues is via the Issues page of the GitHub repository at
https://github.com/NCAR/wrf_hydro_docker/issues.

## Data sources
The WRF Preprocessing System (WPS) geographical input data are one of the primary datasets used by the Noah-MP land surface model (LSM). These datasets can be obtained from the [WPS geographical input data download page](http://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html). However, these data are rather large (~50GB) and contain a number of datasets that are not used in most implementations of WRF-Hydro. We have reduced the data by removing various resolutions of the data that are not commonly used by WRF-Hydro. Furthermore, the dataset provided with this container has been subset to the contiguous United States (CONUS). Thus, the dataset provided with this container is considerably smaller than the complete WRF-WPS dataset.

# Running the training version(s) of this container:
Make sure you have Docker installed and that it can access your localhost ports. Most out-of-the-box
Docker installations accepting all defaults will have this configuration. 

**Step 1: Open a terminal or PowerShell session**

**Step 2: Pull the appropriate Docker container for the desired code version**
Each training container is specific to a release version of the WRF-Hydro source code, which can be found at https://github.com/NCAR/wrf_hydro_nwm_public/releases.
Issue the following command in your terminal to pull a specific version of the training
corresponding to your code release version. In this example, we will pull the training container for v5.1.1.

`docker pull wrfhydro/wps:conus-training-v5.1.1`

**Step 3: Start the training Docker container**
Issue the following command in your terminal session to start the training Docker container.
`docker run --name wrf-hydro-training -p 8889:8888 -it wrfhydro/wps:conus-training-v5.1.1`

**Note: Port forwarding is setup with the -p 8889:8888 argument, which maps your localhost port to
the container port. If you already have something running on port 8889 on your localhost you will
need to change this number**

**Step 4: Open the training lesson in Jupyter Lab**
All lessons for this training are contained in the `~/wrf-hydro-training/lessons` folder. The
lessons are interactive and can execute code commands live. For more information on Jupyter
visit the project page at http://jupyter.org/.

# Running the standard version(s) of this container:

## Creating the geo_em_d01.nc (geogrid) file
### geogrid.exe
The WPS program `geogrid.exe` is used to create the `geo_em_d01.nc` file, hereafter referred to as the 'geogrid' file. The `geogrid.exe` program takes a Fortran namelist (`namelist.wps`) and the [WPS geographical input data](http://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html) as inputs and creates the geogrid file. However, the `geogrid.exe.` program requires that WRF and WPS be built according to your system specification, and building WRF and WPS can be difficult on some systems. Additionally, much of the functionality of WRF and WPS is not utilized for creating a geogrid file for WRF-Hydro, and many of the options in the `namelist.wps` are not relevant to this process. Therefore, we have created a Docker container and Python command line utility to abstract much of the WRF/WPS complexity and simplify the process of creating a geogrid file for WRF-Hydro users. 

We will cover the steps to create the geogrid file using this method in the section 'Usage and invocations'. For more non-standard, advanced usage please see the WRF-WPS documentation.

### Defining domain boundaries
WRF-Hydro uses domains boundaries defined by the `namelist.wps` input namelist to the geogrid.exe program. The first step to creating the geogrid file is to define our domain boundaries. The `geogrid.exe` program takes a centerpoint, x and y coordinates, and other projection information to define a bounding box for the domain.

### Exploring the abbreviated namelist.wps file
The WPS `geogrid.exe` utility is controlled by options set in the `namelist.wps`. As previously stated, there are many options in the `namelist.wps` file that are not relevant to most WRF-Hydro users. Therefore, the Python command line utility supplied with this container accepts an abbreviated `namelist.wps` file.

`namelist.wps`

----------
```
&geogrid

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Define the extend in west-east (e_we) and south-north (e_sn) directions
!  Note: will create a domain of size (e_we-1) x (e_sn-1)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

 e_we              =  16,
 e_sn              =  17,

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Define the center point of your domain
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

 ref_lat   =   41.47100
 ref_lon   =  -73.74365

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Define the domain grid spacing (in meters)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

 dx = 1000,
 dy = 1000,

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Define the map projection
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

 map_proj = 'lambert',
 truelat1  =  30.0,
 truelat2  =  60.0,
 stand_lon =  -97.00,

/
```
----------

### Usage
**Step 1: Pull the image**
```
docker pull wrfhydro/wps:conus
```

**Step 2:  Create a directory to bind-mount to Docker for passing files between your system and docker**
```
mkdir /home/dockerMount
```

**Step 3: Create a namelist.wps file for your domain using the above example as a starting point and save it in your mount directory from step 1.**

**Step 4: Run Docker invoking the python make_geogrid.py utility with the required arguments.**

Note that by default a domain plot (`domain.png`) and wrfinput file (`wrfinput_d01.nc`) are also generated for the specified domain. This wrfinput file is a very basic WRF-Hydro initialization file created from the geogrid file and a set of specified conditions. The file contains fields of spatially uniform initial model states of soil moisture, soil temperature, soil liquid water content and skin temperature among a few other variables necessary for model cold-start initialization. This file can be used as a 'cold start' for long-term model spin-up or users can overwrite the fields in the file created. Sophisticated and WRF-savvy users can use the WRF utility real.exe to create a wrfinput file from model or reanalysis products for more realistic initial conditions.

The R script used to create this file can be downloaded at https://ral.ucar.edu/projects/wrf_hydro/pre-processing-tools. 

**NOTE THE PATHS LISTED BELOW IN THE ARUGMENT LIST ARE FOR THE DOCKER FILESYSTEM. ALSO NOTE THAT ALL PATHS MUST BE ABSOLUTE**

```
docker run -v <path-to-your-local-mount-folder>:/home/docker/mount wrfhydro/wps:conus
```

#### We will now dissect the pieces of this Docker command and additional options.

-----------------

`docker run -v <path-to-your-local-mount-folder>:/home/docker/mount...` - Run the container with the `-v` argument to bind mount a volume on your local system to a folder in the docker container. It is best to leave the folder in the docker container unchanged. 

 `--plot_only` - Only create a plot and do not run geogrid. Useful for making changes to the domain location and boundaries.

**Note: You can access help on these arguments with the following command**

`docker run wrfhydro/wps --help`
