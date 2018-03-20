FROM wrfhydro/dev:base

MAINTAINER jamesmcc@ucar.edu

####################################
########## ROOT USER  ##############
####################################
USER root

###########################
#Install python3 miniconda

#remove old python3
RUN rm -rf /usr/bin/python3

####################################
######### docker user ###########
####################################
USER docker

#Fetch latest miniconda and install
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash Miniconda3-latest-Linux-x86_64.sh -b -p /home/docker/miniconda3 \
    && rm Miniconda3-latest-Linux-x86_64.sh

#Set environment variables
ENV PATH="/home/docker/miniconda3/bin:${PATH}"

#Install modules
RUN conda install -y xarray netcdf4 dask
RUN pip install f90nml deepdiff

#Install plotnine, this funky error catch has to be done because of a known conda bug
#If the command is run twice it succeeds on the second try
#Will be fixed in conda version 4.4.11. See https://github.com/conda/conda/issues/6811
RUN conda install -c conda-forge -y --no-update-deps plotnine; exit 0
RUN conda install -c conda-forge -y --no-update-deps plotnine

WORKDIR /home/docker
ENTRYPOINT ["/interface.sh"]
CMD ["interactive"]