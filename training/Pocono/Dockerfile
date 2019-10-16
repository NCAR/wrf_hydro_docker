###################################
# Image name: wrfhydro/nwm-training:v2.0
# Author: Ryan Cabell <rcabell@ucar.edu>
# Date:  2019-04-24
###################################
FROM wrfhydro/dev:base as build

MAINTAINER rcabell@ucar.edu
USER root

RUN mkdir /home/docker/nwm-training && chown docker:docker /home/docker/nwm-training

# install NCL
#RUN wget https://www.earthsystemgrid.org/dataset/ncl.640.dap/file/ncl_ncarg-6.4.0-Debian8.6_64bit_gnu492.tar.gz \
#  && mkdir /usr/local/ncl-6.4.0 \
#  && tar -xzf ncl_ncarg-6.4.0-Debian8.6_64bit_gnu492.tar.gz -C /usr/local/ncl-6.4.0 \
#  && rm ncl_ncarg-6.4.0-Debian8.6_64bit_gnu492.tar.gz

#ENV NCARG_ROOT=/usr/local/ncl-6.4.0
#ENV PATH=$NCARG_ROOT/bin:$PATH

# install python modules

RUN conda install nodejs

RUN pip install --upgrade pip && \
    pip install jupyterlab jupyter_contrib_nbextensions ipython \
    matplotlib h5py netcdf4 dask toolz xarray \
    numpy pandas psutil

RUN jupyter labextension install @jupyterlab/toc

ADD example_case.tgz /home/docker/nwm-training
RUN chown -R docker:docker /home/docker/nwm-training/example_case # && \
    chown -R docker:docker /home/docker/miniconda3

# Modifying PATH to place conda stuff at the end. 
#ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/bin:/home/docker/miniconda3/bin

############################
## SWITCH TO USER "DOCKER"

USER docker
WORKDIR /home/docker
ENV version=v5.1.0

# get regridding scripts
#RUN wget https://ral.ucar.edu/sites/default/files/public/ESMFregrid_NLDAS.tar_.gz \
#	&& tar -xf ESMFregrid_NLDAS.tar_.gz \
#	&& mv NLDAS /home/docker/nwm-training/regridding \
#	&& rm ESMFregrid_NLDAS.tar_.gz

#COPY ./gdrive_download.py gdrive_download.py
#RUN chmod +x gdrive_download.py

#RUN mkdir /home/docker/nwm-training/regridding/data/ \
#  && python gdrive_download.py --file_id 1yyfO2ofec49H4SqR-RuFly9mJPqs73Hw \ 
#  --dest_file /home/docker/nwm-training/regridding/data/nldas_forcing.tar.gz

#RUN rm gdrive_download.py

RUN git clone --single-branch --branch rfc_training https://github.com/aubreyd/wrf_hydro_nwm_public \
    && mv /home/docker/wrf_hydro_nwm_public /home/docker/nwm-training/wrf_hydro_nwm_public

RUN git clone --single-branch --branch RFC_Training https://github.com/NCAR/wrf_hydro_training \
     && mv /home/docker/wrf_hydro_training/lessons/training /home/docker/nwm-training/lessons \
     && rm -rf /home/docker/wrf_hydro_training

# Obtain the latest calibration workflow code. 
RUN git clone --single-branch https://github.com/logankarsten/PyWrfHydroCalib \
    && mv /home/docker/PyWrfHydroCalib /home/docker/nwm-training/PyWrfHydroCalib

# Modifying PATH to place conda stuff at the end.
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/bin:/home/docker/miniconda3/bin

### second stage build

FROM wrfhydro/dev:base

## R
#install R and libraries
USER root 

COPY --from=build --chown=docker:docker /home/docker /home/docker
COPY --chown=docker:docker ./entrypoint.sh /.
COPY --chown=docker:docker ./jupyter_notebook_config.py /home/docker/.jupyter/

RUN apt update && apt install -y r-base-core libcurl4-gnutls-dev libssl-dev libxml2-dev \
        && wget http://cirrus.ucsd.edu/~pierce/ncdf/ncdf4_1.13.tar.gz \
        && R CMD INSTALL ncdf4_1.13.tar.gz  \
        && rm ncdf4_1.13.tar.gz \
        && Rscript -e 'install.packages(c("devtools","data.table","ggplot2","plyr","boot","sensitivity","randtoolbox","gridExtra","raster","IRkernel"), repos="https://cran.rstudio.com")' \
        && Rscript -e 'devtools::install_github("NCAR/rwrfhydro")'

USER docker
WORKDIR /home/docker

RUN Rscript -e 'IRkernel::installspec()'
RUN chmod -R ugo-s /home/docker/nwm-training/example_case && \
    chmod -R o-w /home/docker/nwm-training/example_case && \
    chmod o-w /home/docker

ENTRYPOINT ["/entrypoint.sh"]
CMD ["interactive"]
