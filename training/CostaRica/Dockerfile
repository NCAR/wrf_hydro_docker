###################################
# Image name: wrfhydro/costarica-training
# Author: Ryan Cabell <rcabell@ucar.edu>
# Date:  2019-04-24
###################################
FROM wrfhydro/dev:base as build

MAINTAINER rcabell@ucar.edu
USER root

RUN mkdir /home/docker/wrf-hydro-training && chown docker:docker /home/docker/wrf-hydro-training

# install python modules
RUN pip install --upgrade pip && \
    pip install jupyterlab jupyter_contrib_nbextensions ipython \
    matplotlib h5py netcdf4 dask toolz xarray \
    numpy pandas psutil

# Modifying PATH to place conda stuff at the end. 
#ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/bin:/home/docker/miniconda3/bin
RUN apt update && apt install -y r-base-core libcurl4-gnutls-dev libssl-dev libxml2-dev \
        && wget http://cirrus.ucsd.edu/~pierce/ncdf/ncdf4_1.13.tar.gz \
        && R CMD INSTALL ncdf4_1.13.tar.gz  \
        && rm ncdf4_1.13.tar.gz \
        && Rscript -e 'install.packages(c("devtools","data.table","ggplot2","plyr","boot","sensitivity","randtoolbox","gridExtra","raster","IRkernel"), repos="https://cran.rstudio.com")' \
        && Rscript -e 'devtools::install_github("NCAR/rwrfhydro")'

# install NCL
RUN wget https://www.earthsystemgrid.org/dataset/ncl.640.dap/file/ncl_ncarg-6.4.0-Debian8.6_64bit_gnu492.tar.gz \
  && mkdir /usr/local/ncl-6.4.0 \
  && tar -xzf ncl_ncarg-6.4.0-Debian8.6_64bit_gnu492.tar.gz -C /usr/local/ncl-6.4.0 \
  && rm ncl_ncarg-6.4.0-Debian8.6_64bit_gnu492.tar.gz

ENV NCARG_ROOT=/usr/local/ncl-6.4.0
ENV PATH=$NCARG_ROOT/bin:$PATH

COPY --chown=docker:docker ./entrypoint.sh /.
COPY --chown=docker:docker ./jupyter_notebook_config.py /home/docker/.jupyter/

ADD example_case.tgz /home/docker/wrf-hydro-training
RUN chown -R docker:docker /home/docker/wrf-hydro-training/example_case # && \
    chown -R docker:docker /home/docker/miniconda3

############################
## SWITCH TO USER "DOCKER"

USER docker
WORKDIR /home/docker
ENV version=v5.1.0

# get regridding scripts
RUN wget https://ral.ucar.edu/sites/default/files/public/ESMFregrid_GLDAS.tar_.gz \
	&& tar -xf ESMFregrid_GLDAS.tar_.gz \
	&& mv GLDAS /home/docker/wrf-hydro-training/regridding \
	&& rm ESMFregrid_GLDAS.tar_.gz

# COPY ./gdrive_download.py gdrive_download.py
# RUN chmod +x gdrive_download.py
#
# RUN mkdir /home/docker/wrf-hydro-training/regridding/data/ \
#  && python gdrive_download.py --file_id 1yyfO2ofec49H4SqR-RuFly9mJPqs73Hw \ 
#  --dest_file /home/docker/wrf-hydro-training/regridding/data/gldas_forcing.tar.gz
#
# RUN rm gdrive_download.py

RUN git clone --single-branch --branch v5.1.1-beta https://github.com/NCAR/wrf_hydro_nwm_public \
    && mv /home/docker/wrf_hydro_nwm_public /home/docker/wrf-hydro-training/wrf_hydro_nwm_public
    
# Modifying PATH to place conda stuff at the end.
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/bin:/home/docker/miniconda3/bin
ENV NCARG_ROOT=/usr/local/ncl-6.4.0
ENV PATH=$NCARG_ROOT/bin:$PATH

### second stage build

# FROM wrfhydro/dev:base

## R
#install R and libraries
#USER root 
#
#COPY --from=build --chown=docker:docker /home/docker /home/docker
#
#USER docker
#WORKDIR /home/docker

RUN Rscript -e 'IRkernel::installspec()'

RUN git clone -v --single-branch --branch CostaRica_Training https://github.com/NCAR/wrf_hydro_training \
     && mv  /home/docker/wrf_hydro_training/lessons/training /home/docker/wrf-hydro-training/lessons \
     && rm  -rf /home/docker/wrf_hydro_training

RUN chmod -R ugo-s /home/docker/wrf-hydro-training/example_case && \
    chmod -R o-w /home/docker/wrf-hydro-training/example_case && \
    chmod o-w /home/docker

ENTRYPOINT ["/entrypoint.sh"]
CMD ["interactive"]
