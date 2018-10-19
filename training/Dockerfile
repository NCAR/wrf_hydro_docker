###################################
# Image name: wrfhydro/training:v5_0_3
# Author: Joe Mills <jmills@ucar.edu>
# Date:  2018-05-22
###################################
FROM wrfhydro/dev:base

MAINTAINER jmills@ucar.edu

#####################
### ROOT USER
#####################

USER root

############################
# Copy all files and set permissions
RUN mkdir /home/docker/.jupyter
COPY ./jupyter_notebook_config.py /home/docker/.jupyter/
RUN chmod -R 777 /home/docker/.jupyter

RUN mkdir /home/docker/wrf-hydro-training
COPY ./create_wrfinput.R /home/docker/wrf-hydro-training/wrf_hydro_model_tools/create_wrfinput.R
RUN chmod -R 777 /home/docker/wrf-hydro-training

COPY ./entrypoint.sh /.
RUN chmod -R 777 /home/docker/wrf-hydro-training

#####################
### docker USER
#####################

USER docker
############################
## Python
#Install modules
RUN pip install jupyterlab jupyter_contrib_nbextensions ipython netcdf4 xarray

############################
## R
#install R and libraries

RUN conda install -c r r
RUN Rscript -e 'install.packages(c("optparse","ncdf4"), repos="https://cran.rstudio.com")'


USER docker
WORKDIR /home/docker

ENTRYPOINT ["/entrypoint.sh"]
CMD ["interactive"]