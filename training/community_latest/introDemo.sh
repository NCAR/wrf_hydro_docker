#!/bin/bash

# This walks a user through the basic config-compile-run workflow 

echo 
echo -e "\e[0;49;1m-----------------------------------\e[0m" 
echo -e "\e[7;49;1mWelcome to the WRF-Hydro community intro tutorial\e[0m" 
echo 
echo -e "\e[1mThis walkthrough will guide you through a basic compilation and run for WRF-Hydro in uncoupled mode.\e[0m" 
echo -e "\e[1mThis walkthrough is meant as a simple demonstration and users will likely modify the process on their own systems.\e[0m" 
echo -e "\e[1mPlease see the user guide for a detailed description of the model and its configurations.\e[0m" 
echo -e "\e[7;49;1mPress [ENTER] to progress through each step:\e[0m"
read progress

echo 
echo -e "\e[0;49;1m-----------------------------------\e[0m" 
echo -e "\e[7;49;1mNavigate to the code directory\e[0m" 
echo -e "\e[1mFirst we must change directories to the code repository directory.\e[0m" 
read progress 
echo -e "cd wrf_hydro_community_v*" 
read progress 
cd wrf_hydro_community_v*

echo 
echo -e "\e[0;49;1m-----------------------------------\e[0m" 
echo -e "\e[7;49;1mFirst set compile-time options using environment variables\e[0m" 
echo -e "\e[1mThese variables are set using the helper script setEnvar.sh\e[0m" 

echo -e "\e[1mYou may supply your own file of variable definitions, or use the template that is in setEnvar.sh\e[0m" 
echo -e "\e[1mFor this tutorial we will just use the default setEnvar.sh settings\e[0m" 
echo -e "\e[1mNote there will be no output from this step\e[0m" 
read progress 
echo -e "./setEnvar.sh" 
read progress 
./setEnvar.sh

echo 
echo -e "\e[0;49;1m-----------------------------------\e[0m" 
echo -e "\e[7;49;1mNext we configure using the configure script\e[0m" 
echo -e "\e[1mFor this training environment we are using GNU so we select option 2 for Linux gfort compiler dmpar\e[0m" 
read progress 
echo -e "./configure 2" 
read progress 
./configure 2
read progress 

echo 
echo -e "\e[0;49;1m-----------------------------------\e[0m" 
echo -e "\e[7;49;1mNext we will compile the model using the NoahMP LSM\e[0m" 
echo -e "\e[1mThe compile output log will be piped to a file called compile.log to reduce output during this tutorial\e[0m" 
read progress 
echo -e "./compile_offline_NoahMP.sh >> compile.log" 
read progress 
echo -e "\e[1mCompiling, warnings about non-existent include directories can be ignored\e[0m" 
./compile_offline_NoahMP.sh >> compile.log

echo 
echo -e "\e[0;49;1m-----------------------------------\e[0m" 
echo -e "\e[7;49;1mCongratulations! You have successfully compiled the model\e[0m" 
echo 
echo -e "\e[1mThere should now be a new directory called 'Run' containing the compiled binary wrf_hydro.exe and associated *.TBL files\e[0m" 
echo -e "\e[1mTemplate namelist files are also copied over from the template directory in the source code directory.\e[0m" 
echo -e "\e[1mTHESE NAMELISTS ARE TEMPLATES ONLY AND UNLIKE THE *.TBL FILES, REQUIRE SUBSTANTIAL EDITS BY THE USER.\e[0m" 

read progress 
echo -e "cd Run" 
read progress 
cd Run 
echo -e "ls" 
read progress 
ls
echo -e "\e[1mThese *.TBL files are needed later for running the model\e[0m" 
read progress 

echo 
echo -e "\e[0;49;1m-----------------------------------\e[0m" 
echo -e "\e[7;49;1mNext we will prepare to run the model\e[0m" 
echo -e "\e[1mFor this tutorial, we will run a simulation of the West Branch of the Croton River, NY during hurricane Irene, 2011-08-26 to 2011-09-02\e[0m" 
echo -e "\e[1mFirst we need to copy the files in the Run directory to our directory containing the domain and forcing files\e[0m" 
echo -e "\e[1mFor this tutorial, these files are located in /home/docker/domain/Croton_NY_0137462010\e[0m" 
read progress 
echo -e "cd /home/docker/domain/Croton_NY_0137462010" 
read progress 
cd /home/docker/domain/Croton_NY_0137462010 
echo -e "ls" 
read progress 
ls
echo -e "\e[1mNote there are 3 subfolders with the names NWM, Gridded, and Reach\e[0m" 
read progress 

echo 
echo -e "\e[1mThese prefixes denote the 3 general routing configuration schemes\e[0m" 
echo -e "\e[1mAlso, note that there is only 1 FORCING directory. The same forcing data can be used for each routing configuration\e[0m" 
echo -e "\e[1mWe will only be running National Water Model (NWM) routing for this tutorial, but a similar process can be repeated for the other two configurations\e[0m" 
echo -e "\e[1mGive it a go on your own after this tutorial!\e[0m" 
read progress 
echo -e "cd /home/docker/domain/Croton_NY_0137462010/NWM" 
read progress 
cd /home/docker/domain/Croton_NY_0137462010/NWM 
echo -e "ls" 
read progress 
ls

echo 
echo -e "\e[1mNow lets copy the necessary files from the RUN directory to our domain directory.\e[0m" 
echo -e "\e[1mNote that this is one of many ways to organize your files and more sophisticated methods are available.\e[0m" 
read progress 
echo -e "cp /home/docker/wrf_hydro_community_v*/Run/*.TBL ." 
read progress 
cp /home/docker/wrf_hydro_community_v*/Run/*.TBL . 
echo -e "cp /home/docker/wrf_hydro_community_v*/Run/wrf_hydro.exe ." 
read progress 
cp /home/docker/wrf_hydro_community_v*/Run/wrf_hydro.exe . 
echo -e "ls" 
read progress 
ls

echo 
echo -e "\e[0;49;1m-----------------------------------\e[0m" 
echo -e "\e[7;49;1mNext we will run the model\e[0m"
echo -e "\e[1mNote that there are many options and filepaths that need to be set in the two namelist files hydro.namelist and namelist.hrldas.\e[0m" 
echo -e "\e[1mHowever, for this tutorial these files have been prepared for you.\e[0m" 
echo -e "\e[1mWe will now run the model using mpirun with 2 cores\e[0m" 
read progress 
echo -e "mpirun -np 2 ./wrf_hydro.exe" 
read progress 
mpirun -np 2 ./wrf_hydro.exe echo -e "ls" ls

echo 
echo -e "\e[0;49;1m-----------------------------------\e[0m" 
echo -e "\e[7;49;1mCongratulations, you have successfully run the model\e[0m"
echo -e "\e[1mNow, try it on your own for the Gridded and Reach configurations, or continue on to our brief visualization tutorial\e[0m" 

echo 
echo -e "\e[0;49;1m-----------------------------------\e[0m" 
echo -e "\e[7;49;1mThis concludes the wrf_hydro_community introductory tutorial\e[0m"

