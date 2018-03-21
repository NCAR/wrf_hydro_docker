# This example works on OS X.
# (Should work on windows, since nothing needs to come out
#  of the container, but it is untested on windows.)

# *******************************************************
# All configuration (should be) here:
# *******************************************************
# Where the hyro-dart repo is located on your host system
DART_DIR=/Users/jamesmcc/WRF_Hydro/wrf_hydro_dart/
# Where wrf_hydro_nwm is on your host system
WRF_HYDRO_DIR=/Users/jamesmcc/WRF_Hydro/wrf_hydro_nwm_myFork
# Note that the code from WRF_HYDRO_DIR is COPIED to docker because there is
# some issue where WRF-Hydro can NOT be compiled in a mounted
# drive in docker. 
# *******************************************************
# End configuration.
# *******************************************************


#######################################################
## OUTSIDE DOCKER (OS X terminal)

docker pull wrfhydro/dev:conda
docker pull wrfhydro/domains_dart:sixmile_channel-only

# Create a new data container from the sixmile_channel-only.
# Call it something slightly different to emphasise that the created container is a copy.
docker create --name sixmile_channel-only_test wrfhydro/domains_dart:sixmile_channel-only

# These are where the dart repo and nwm repos will be mounted
# on the docker file system.
DART_DIR_DOCKER=/home/docker/wrf_hydro_dart
# The WRF_HYDRO_DIR_DOCKER mount point emphasises that we should
# not write here (though permissions may be available). A copy
# will be made into a non-mounted docker dir if WRF-Hydro needs built.
WRF_HYDRO_DIR_DOCKER=/wrf_hydro_nwm

# Currently my fix to channel-only is not in the upstream master. So this
# chunk is temporary until I have it fully tested and merged.... 
cd $WRF_HYDRO_DIR
git fetch upstream
git checkout upstream/channel_only_fix_private_v5

# Start docker with relevant information for your system
docker run -it \
       -e DART_DIR=$DART_DIR_DOCKER \
       -v $DART_DIR:$DART_DIR_DOCKER \
       -v $WRF_HYDRO_DIR:$WRF_HYDRO_DIR_DOCKER \
       --volumes-from sixmile_channel-only_test \
       wrfhydro/dev:conda 


#######################################################
# INSIDE DOCKER

# WRF-Hydro (if necessary): config, compile.
rm -rf /home/docker/wrf_hydro_nwm
# Note that the code from WRF_HYDRO_DIR is COPIED to docker because there is
# some issue where WRF-Hydro can NOT be compiled in a mounted
# drive in docker. 
cp -r /wrf_hydro_nwm /home/docker/.
cd /home/docker/wrf_hydro_nwm/trunk/NDHMS
./configure gfort
export WRF_HYDRO=1
export HYDRO_D=0
export SPATIAL_SOIL=1
export WRFIO_NCD_LARGE_FILE_SUPPORT=1
export WRF_HYDRO_RAPID=0
export NCEP_WCOSS=0
export WRF_HYDRO_NUDGING=0
./compile_offline_NoahMP.sh
cp Run/wrf_hydro.exe /home/docker/domain_dart/sixmile_channel-only/.
cd /home/docker/domain_dart/sixmile_channel-only/

# DART (if necessary): compile
cd /home/docker/wrf_hydro_dart/mkmf
ln -sf mkmf.template.gfortran_5.4.0_docker mkmf.template
cd /home/docker/wrf_hydro_dart/models/wrfHydro/work
./quickbuild.csh

# Sixmile test run
cd /home/docker/domain_dart/sixmile_channel-only/
./setup_filter.csh forceCopyAll
./setup_filter.csh forceCopyAll ## again, with feeling.
./run_filter.csh


# TO EXIT DOCKER (commented to avoid accidential exit of docker)
# exit

#######################################################
# OUTSIDE DOCKER

# You can NOT run the following command for as long as you want. The data
#   container should stay available under that name and the data will
#   persist, even if you restart docker or you computer (as far as i have seen).
# THIS DESTROYS THE CONTAINER AND THE DATA IN IT. CONSIDER THAT.
docker rm -v sixmile_channel-only_test


