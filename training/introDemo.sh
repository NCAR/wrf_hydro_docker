#!/bin/bash

# This walks a user through the basic config-compile-run workflow 

echo 
echo -e "\e[0;49;1m-----------------------------------\e[0m" 
echo -e "\e[7;49;1mWelcome to the WRF-Hydro community introductory demonstration\e[0m" 
echo 
echo -e "\e[1mThis walkthrough will guide you through a basic compilation and run for WRF-Hydro in standalone (uncoupled) mode for a small test case domain\e[0m" 
echo -e "\e[1mencompassing the West Branch of the Croton River, NY, USA during hurricane Irene, 2011-08-26 to 2011-09-02.\e[0m" 
echo -e "\e[1mThis walkthrough is meant as a simple demonstration. You will need to modify the process on your own systems.\e[0m" 
echo -e "\e[1mFor a detailed description of the model and its configurations, please see the Technical Description and User Guides located at https://ral.ucar.edu/projects/wrf_hydro.\e[0m" 
echo -e "\e[7;49;1mPress [ENTER] to progress through each step:\e[0m"
read progress

echo 
echo -e "\e[0;49;1m-----------------------------------\e[0m" 
echo -e "\e[7;49;1mNavigate to the code directory.\e[0m" 
echo -e "\e[1mFirst we must change directories to the code repository directory.\e[0m" 
read progress 
echo -e "cd wrf_hydro_nwm_public*/trunk/NDHMS" 
read progress 
cd wrf_hydro_nwm_public*/trunk/NDHMS

echo 
echo -e "\e[0;49;1m-----------------------------------\e[0m" 
echo -e "\e[7;49;1mNext we configure the model using the configure script.\e[0m" 
echo -e "\e[1mFor this training environment we are using GNU so we select option 2 for Linux gfort compiler dmpar.\e[0m" 
read progress 
echo -e "./configure 2" 
read progress 
./configure 2
read progress 

echo 
echo -e "\e[0;49;1m-----------------------------------\e[0m" 
echo -e "\e[7;49;1mNext we will compile the model using the NoahMP LSM.\e[0m" 
echo -e "\e[7;49;1mCompile-time options are set using environment variables.\e[0m" 
echo -e "\e[1mThese variables are can be set using the helper script setEnvar.sh in the trunk/NDHMS/template directory.\e[0m" 

echo -e "\e[1mYou may supply your own file of variable definitions, or use the template setEnvar.sh.\e[0m" 
echo -e "\e[1mFor this demo we will just use the default setEnvar.sh settings.\e[0m" 
echo -e "\e[1mNote there will be no output from this step.\e[0m" 
echo -e "\e[1mThe compile output log will be piped to a file called compile.log to reduce output during this demo.\e[0m" 
read progress 
echo -e "./compile_offline_NoahMP.sh >> compile.log 2>&1" 
read progress 
echo -e "\e[1mCompiling, warnings about non-existent include directories can be ignored\e[0m" 
./compile_offline_NoahMP.sh template/setEnvar.sh >> compile.log 2>&1

echo 
echo -e "\e[0;49;1m-----------------------------------\e[0m" 
echo -e "\e[7;49;1mCongratulations! You have successfully compiled the model.\e[0m" 
echo 
echo -e "\e[1mThere should now be a new directory called 'Run' containing the compiled binary wrf_hydro.exe and associated *.TBL files.\e[0m" 
echo -e "\e[1mTemplate namelist files are also copied over from the template directory in the source code directory.\e[0m" 
echo -e "\e[1mTHESE NAMELISTS ARE TEMPLATES ONLY AND UNLIKE THE *.TBL FILES, REQUIRE SUBSTANTIAL EDITS BY THE USER.\e[0m" 

read progress 
echo -e "cd Run" 
read progress 
cd Run 
echo -e "ls" 
read progress 
ls
echo -e "\e[1mThese *.TBL files are needed later for running the model.\e[0m" 
read progress 

echo 
echo -e "\e[0;49;1m-----------------------------------\e[0m" 
echo -e "\e[7;49;1mNext we will prepare to run the model.\e[0m" 
echo -e "\e[1mFor this demo, we will run a simulation of the West Branch of the Croton River, NY, USA during hurricane Irene, 2011-08-26 to 2011-09-02.\e[0m" 
echo -e "\e[1mFirst we need to copy the files in the Run directory to our directory containing the domain and forcing files.\e[0m" 
echo -e "\e[1mFor this demo, these files are located in /home/docker/domain/croton_NY\e[0m" 
read progress 
echo -e "cd /home/docker/domain/croton_NY" 
read progress 
cd /home/docker/domain/croton_NY
echo -e "ls" 
read progress 
ls
echo -e "\e[1mNote there are 3 subfolders with the names NWM, Gridded, and Reach.\e[0m" 
read progress 

echo 
echo -e "\e[1mThese directories represent the 3 general routing configuration schemes.\e[0m"
echo -e "\e[1mInformation regarding routing configurations can be found in the Technical Description located at https://ral.ucar.edu/projects/wrf_hydro.\e[0m"
echo -e "\e[1mAlso, note that there is only 1 FORCING directory. The same forcing data can be used for each routing configuration.\e[0m" 
echo -e "\e[1mWe will only be running National Water Model (NWM) routing for this demo, but a similar process can be repeated for the other two configurations.\e[0m" 
echo -e "\e[1mGive it a go on your own after this demo!\e[0m" 
read progress 
echo -e "cd /home/docker/domain/croton_NY/NWM" 
read progress 
cd /home/docker/domain/croton_NY/NWM 
echo -e "ls" 
read progress 
ls

echo 
echo -e "\e[1mNow lets copy the necessary files from the Run directory to the NWM directory.\e[0m" 
echo -e "\e[1mNote that this is one of many ways to organize your files and more sophisticated methods are available.\e[0m" 
read progress 
echo -e "cp /home/docker/wrf_hydro_nwm_public*/trunk/NDHMS/Run/*.TBL ." 
read progress 
cp /home/docker/wrf_hydro_nwm_public*/trunk/NDHMS/Run/*.TBL . 
echo -e "cp /home/docker/wrf_hydro_nwm_public*/trunk/NDHMS/Run/wrf_hydro.exe ." 
read progress 
cp /home/docker/wrf_hydro_nwm_public*/trunk/NDHMS/Run/wrf_hydro.exe . 
echo -e "ls" 
read progress 
ls

echo 
echo -e "\e[0;49;1m-----------------------------------\e[0m" 
echo -e "\e[7;49;1mNext we will run the model\e[0m"
echo -e "\e[1mNote that there are many options and filepaths that need to be set in the two namelist files hydro.namelist and namelist.hrldas.\e[0m" 
echo -e "\e[1mHowever, for this demo these files have been prepared for you.\e[0m" 
echo -e "\e[1mWe will now run the model using mpirun with 2 cores\e[0m" 
read progress 
echo -e "mpirun -np 2 ./wrf_hydro.exe" 
read progress 
mpirun -np 2 ./wrf_hydro.exe 
echo -e "ls" ls

echo 
echo -e "\e[0;49;1m-----------------------------------\e[0m" 
echo -e "\e[7;49;1mCongratulations, you have successfully run the model\e[0m"
echo -e "\e[1mWe can see that we now have a number of output files in the directory\e[0m"
read progress 
echo -e "ls | head" 
read progress 
ls | head
echo -e "\e[1mFor this run we specified in the hydro.namelist that we only wanted output where there are measurement points\e[0m"
echo -e "\e[1mWith these output settings the streamflow at observation points for each timestep are written to the *CHANOBS*.nc files.\e[0m"
echo -e "\e[1mIf we had all output on, the streamflow output would be in *CHRTOUT*.nc files.\e[0m"
echo -e "\e[1mThere are also RESTART and HYDRO_RST output files for restarting the model at a given timestep.\e[0m"
echo -e "\e[1mFor a complete description of output files and variables see the Technical Description and User Guides located at https://ral.ucar.edu/projects/wrf_hydro.\e[0m"
read progress 

echo 
echo -e "\e[0;49;1m-----------------------------------\e[0m" 
echo -e "\e[7;49;1mNow lets plot a hydrograph of the modelled and observed streamflow at a gage point.\e[0m"
echo -e "\e[7;49;1mThe observation data for USGS gage 01374559 has been provided as a csv file in Croton_usgsObs_01374559.csv.\e[0m"
echo -e "\e[7;49;1mWe will use these data, the *CHANOBS* model output files, and the included python script plot_hydrograph.py.\e[0m"
echo -e "\e[7;49;1mThe first argument to the python script is the directory containing the model output.\e[0m"
echo -e "\e[7;49;1mThe second argument to the python script is the path for the output plot.\e[0m"
read progress 
echo -e "python3 /home/docker/plot_hydrograph.py"
read progress  
python3 /home/docker/plot_hydrograph.py /home/docker/domain/croton_NY/NWM /home/docker/hydrograph.png
echo -e "\e[7;49;1mIf you would like to view this image on your host system please see the Docker documentation about mounting a local drive.\e[0m"
echo -e "\e[7;49;1mYou can mount a folder form this container, e.g. '/home/docker/host', to a folder on your local host and copy files to it.\e[0m"

read progress  
echo -e "\e[1mNow, try it on your own for the Gridded and Reach configurations.\e[0m" 

read progress  
echo 
echo -e "\e[0;49;1m-----------------------------------\e[0m" 
echo -e "\e[7;49;1mThis concludes the wrf_hydro_nwm_public introductory demonstration.\e[0m"

