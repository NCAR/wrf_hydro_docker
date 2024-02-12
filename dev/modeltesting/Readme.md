![](https://ral.ucar.edu/sites/default/files/public/wrf_hydro_symbol_logo_2017_09_150pxby63px.png) WRF-HYDRO

# Overview
This container is used for WRF-Hydro model testing on a small domain,single-node WRF-Hydro
simulation. This container includes the following:

# Usage
**Step 1: Pull the image**
```
docker pull wrfhydro/dev:modeltesting
```

**Step 2: Run the image with volume mounts and arguments**

```
docker run -it \
        -v /<local_system_path_for_candidate>/wrf_hydro_nwm_public/:/home/docker/candidate \
        -v /<local_system_path_for_reference>/wrf_hydro_nwm_public/:/home/docker/reference \
        wrfhydro/dev:modeltesting --config nwm_ana --domain_tag v5.0.1
```

The docker interactive flag `-it` is used to run the docker image in interactive terminal mode. This allows the user to examine testing artifcats rather then shutting down the container on test exit.

The `candidate` is the source code you would like to test and the `reference` is the source code you
would like to regress the candidate against for regression testing. These directories reside on
your local system and need to be volume mounted into the Docker container file system. **DO NOT
EDIT THE DOCKER SYSTEM PATH OF THE VOLUME MOUNTS, THIS IS HARD CODED INTO THE TESTING**

The `--config` argument is required and specifies the configuration to test, which is one of the
configs listed in the wrf_hydro_nwm_public/src/hydro_namelist.json file keys. The `--domain_tag` argument
specifies a GitHub tagged release version of the testing domain to retrieve. Or, if retrieving the bleeding edge use 'dev' for the tag, in which case the bleeding-edge domain will be retrieved from google drive.

Alternatively, you may mount your
own local domain to use in testing with a volume mount `-v /<local_system_path_for_domain>:/home/docker/example_case`


**Get Help**
You may get help on the usage of this container locally by calling the container help
```
docker run wrfhydro/dev:modeltesting --help
```
