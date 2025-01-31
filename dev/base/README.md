![](https://ral.ucar.edu/sites/default/files/public/wrf_hydro_symbol_logo_2017_09_150pxby63px.png) WRF-HYDRO

# Overview
This container is used for WRF-Hydro development and single-node WRF-Hydro simulations.

This container includes the following:

* Ubuntu base image
* All system libraries required by WRF-Hydro
* Text editors - VIM, Nano, Emacs
* git version control system
* nccmp - NetCDF Compare utility for diffing NetCDF files
* NetCDF C and Fortran libraries
* MPI

# Usage
**Step 1: Pull the image**
```
docker pull wrfhydro/dev:base
```

**Step 2: Run the image**
```
docker run -it wrfhydro/dev:base
```

**Optionally: Run the image with a volume mount**

**NOTE: DO NOT COMPILE WRFHYDRO IN THE MOUNTED FOLDER.**
On some filesystems, WRF-Hydro will not compile correctly if compilation occurs in a mounted
directory. WRF-Hydro will run in a mounted directory on most filesystems, but compilation may fail.

```
docker run -v <path-to-your-local-mount-folder>:<path-to-the-desired-docker-folder> -it wrfhydro/dev:base
```

