![](https://ral.ucar.edu/sites/default/files/public/wrf_hydro_symbol_logo_2017_09_150pxby63px.png) WRF-HYDRO

# Overview
This container is used for WRF-Hydro development, sanboxing, and single-node WRF-Hydro simulations.

In particular, this container is designed for testing domain configurations. 

This container includes the following:

* Everything in wrfhydro/dev:base
* Latest WRF-Hydro release source code (v5.2.0)

# Usage
**Step 1: Pull the image**
```
docker pull wrfhydro/dev:domaintesting
```

**Step 2: Setup the `setEnvar.sh` script**

Make sure the compile-time options are correct for your intended run of WRF-Hydro. 
	
You can get the current setEnvar script from here:
	https://github.com/NCAR/wrf_hydro_nwm_public/blob/main/src/template/setEnvar.sh
	
Make sure the desired version and options in setEnvar.sh are in the repository `/domaintesting/` directory.
	
**Step 3: Build the docker container for the domaintesting configuration**

Open Windows PowerShell (Windows) or a Linux shell in your base directory:

```
>docker build -f .\Dockerfile -t wrfhydro/dev:domaintesting .
```

This will copy the setEnvar.sh script from `./domaintesting` into the compile directory in the container, and 
it will also configure and compile WRF-Hydro within the container.
		
Next, you will want to copy the entire Run directory from compiled WRF-Hydro code to local directory. Make sure the output directory does not yet exist:

```
>docker cp -L <container ID>:/home/docker/wrf_hydro_nwm_public/trunk/NDHMS/Run <target Run directory>
```	
	
This will create a `./Run` directory with namelists and parameter tables, as well as the WRF-Hydro executable, in your local directory.

**Step 4: Make any modifications you need to the namelists, particularly hydro.namelist and namelist.hrldas.	**

Create a `./Run` directory to store the parameter tables, executables, and model outputs.
Also create a `./Run/DOMAIN` directory to store domain files to test. Copy all necessary domain files here.
 
Edit `hydro.namelist` and `namelist.hrldas` to suit your domain and WRF-Hydro configuration.

**Step 5: Run WRF-Hydro. We will mount our local Run directory as the WRF-Hydro Run directory and execute WRF-Hydro.**

```
>docker run --mount type=bind,source=<Path to local Run directory>,target=/home/docker/Run wrfhydro/dev:domaintesting sh -c "cd /home/docker/Run && mpiexec -n 4 /home/docker/Run/wrf_hydro_NoahMP.exe"
```

This will execute WRF-Hydro, with all outputs going into the designated Run directory. You can change the number of cores using the `-n` parameter and limit 
memory usage using the `-m` parameter. However, limiting memory may cause the model to crash for an unspecified reason.