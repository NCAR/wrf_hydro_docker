![](https://ral.ucar.edu/sites/default/files/public/wrf_hydro_symbol_logo_2017_09_150pxby63px.png) WRF-HYDRO

# Overview
This container is used for WRF-Hydro Forcing Engine testing on a small domain,single-node machine 

# Usage
1. Make sure you have the NCAR/WrfHydroForcing cloned on your local machine
2. When running this container, make sure the local repo is mapped to `/home/docker/WrfHydroForcing`
3. To prepare the environment and run all tests, run with the default commands:
   
```
docker run -v $REPO_LOCATION:/home/docker/WrfHydroForcing wrfhydro/wrf_hydro_forcing:latest
```

4. To run the container interactively, override the default command with a shell, e.g.:
   
```
docker run -it -v $REPO_LOCATION:/home/docker/WrfHydroForcing wrfhydro/wrf_hydro_forcing:latest /bin/bash
```

Note when running interactively you will need to install the needed python packages manually before running the Forcing Engine or FE tests. This can be done by running this script from within the container:

```
/home/docker/install_python_packages.sh
```
