![](https://ral.ucar.edu/sites/default/files/public/wrf_hydro_symbol_logo_2017_09_150pxby63px.png) WRF-HYDRO

# Overview
This container is used for WRF-Hydro training sessions and can be run locally.

This container includes the following:

* Ubuntu base image
* All system libraries required by WRF-Hydro
* Text editors - VIM, Nano, Emacs
* git version control system

##Requirements

The easiest and recommended way to run the training lessons is via the wrfhydro/training Docker container, which has all software dependencies and data pre-installed.

* Docker >= v.17.12
* Web browser (Google Chrome recommended)

## Where to get help and/or post issues
If you have general questions about Docker, there are ample online resources including the excellent Docker documentation at https://docs.docker.com/.

If you have questions regarding the lessons please contact us here https://ral.ucar.edu/projects/wrf_hydro/contact. 

The best place ask questions or post issues with these lessons is via the Issues page of the GitHub repository at https://github.com/NCAR/wrf_hydro_training/issues.

## How to run
Make sure you have Docker installed and that it can access your localhost ports. Most out-of-the-box
Docker installations accepting all defaults will have this configuration. 

**NOTE: THE DEFAULT DOCKER CONFIGURATION IS FOR 2 CPUS, YOU MUST HAVE AT LEAST 2 CPUS AVAILABLE TO THE DOCKER DAEMON FOR THIS TRAINING**

**Step 1: Open a terminal or PowerShell session**

**Step 2: Pull the wrfhydro/rfc-training Docker container for the desired code version**
Each training container is specific to a release version of the WRF-Hydro source code, which can be found at https://github.com/NCAR/wrf_hydro_costa-rica_public/releases.
Issue the following command in your terminal to pull a specific version of the training
corresponding to your code release version. In this example, we will pull the training container for Costa Rica.

`docker pull wrfhydro/costa-rica-training`

**Step 3: Start the training Docker container**
Issue the following command in your terminal session to start the training Docker container.
`docker run --name wrf-hydro-training -p 8888:8888 -it wrfhydro/costa-rica-training`

**Note: Port forwarding is setup with the -p 8888:8888 argument, which maps your localhost port to
the container port. If you already have something running on port 8888 on your localhost you will
need to change this number**

The container will launch a Jupyter Notebook server and echo the address to your terminal.

**Step 4: Open the jupyter notebook lessons**
All lessons for this training are contained in the `~/costa-rica-training/lessons` folder. The
lessons are interactive and can execute code commands live. For more information on jupyter
notebooks visit the jupyter project page at http://jupyter.org/.

