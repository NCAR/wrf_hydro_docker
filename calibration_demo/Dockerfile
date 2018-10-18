###################################
# Author: Joe Mills <jmills@ucar.edu>
# Date:  9.27.2017
###################################
#
# This Dockerfile compiles WRF and WPS from source using the bare-bones requirements for training purposes.
# See https://ral.ucar.edu/projects/ncar-docker-wrf for more complete WRF and WPS docker builds with additional functionality

FROM wrfhydro/dev:base

MAINTAINER jmills@ucar.edu
USER root

############################
## Python
WORKDIR /home/docker

#Fetch latest miniconda and install
RUN wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh \
    && bash Miniconda2-latest-Linux-x86_64.sh -b -p /home/docker/miniconda2 \
    && rm Miniconda2-latest-Linux-x86_64.sh

#Set environment variables
ENV PATH="/home/docker/miniconda2/bin:${PATH}"

#Setup environment
RUN conda update conda

#Install modules
RUN conda install -c conda-forge -y jupyterlab jupyter_contrib_nbextensions ipython hdf5 netcdf4 numpy pandas psutil

#Get jupyter config
COPY ./jupyter_notebook_config.py /home/docker/.jupyter/
RUN chmod -R 777 /home/docker/.jupyter

############################
## R
#install R and libraries

RUN conda install -c r r
RUN Rscript -e 'install.packages(c("data.table","ggplot2","ncdf4","plyr","boot","sensitivity","randtoolbox","gridExtra"), repos="https://cran.rstudio.com")'
############################

RUN mkdir /home/docker/wrf-hydro-training

############################
## WRF-Hydro code and testcast for v5.0.2
RUN version=v5.0.2 \
    && release=$(curl -s https://api.github.com/repos/NCAR/wrf_hydro_nwm_public/releases/tags/$version) \
    && git clone --branch $version https://github.com/NCAR/wrf_hydro_nwm_public \
    && mv /home/docker/wrf_hydro_nwm_public /home/docker/wrf-hydro-training/wrf_hydro_nwm_public \
    && exampleCaseURL=$(echo "$release" | grep 'testcase' | grep "browser_download_url" | cut -d : -f 2,3 |  tr -d \") \
    && echo "$exampleCaseURL" | wget -qi -

RUN tar -xf *testcase*.tar.gz \
    && rm *testcase*.tar.gz \
    && mv /home/docker/example_case /home/docker/wrf-hydro-training/example_case

############################
## Calib workflow code for v5.0.2
RUN git clone --branch v5.0_release https://github.com/NCAR/PyWrfHydroCalib.git \
&& mv PyWrfHydroCalib /home/docker/wrf-hydro-training/PyWrfHydroCalib

############################
#Get the entrypoint script to start jupyter
COPY ./entrypoint.sh /.
RUN chmod 777 /entrypoint.sh

RUN chmod -R 777 /home/docker/wrf-hydro-training/

USER docker
WORKDIR /home/docker

#Make a temp directory needed for matplotlib

ENTRYPOINT ["/entrypoint.sh"]
CMD ["interactive"]

