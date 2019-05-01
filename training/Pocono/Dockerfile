###################################
# Image name: wrfhydro/nwm-training:v2.0
# Author: Ryan Cabell <rcabell@ucar.edu>
# Date:  2019-04-24
###################################
FROM wrfhydro/dev:base as build

MAINTAINER rcabell@ucar.edu
USER root

RUN mkdir /home/docker/wrf-hydro-training && chown docker:docker /home/docker/wrf-hydro-training

# install NCL
RUN wget https://www.earthsystemgrid.org/dataset/ncl.640.dap/file/ncl_ncarg-6.4.0-Debian8.6_64bit_gnu492.tar.gz \
  && mkdir /usr/local/ncl-6.4.0 \
  && tar -xzf ncl_ncarg-6.4.0-Debian8.6_64bit_gnu492.tar.gz -C /usr/local/ncl-6.4.0 \
  && rm ncl_ncarg-6.4.0-Debian8.6_64bit_gnu492.tar.gz

ENV NCARG_ROOT=/usr/local/ncl-6.4.0
ENV PATH=$NCARG_ROOT/bin:$PATH

# install python modules
RUN pip install --upgrade pip && \
    pip install jupyterlab jupyter_contrib_nbextensions ipython \
    matplotlib h5py netcdf4 dask toolz xarray

ADD example_case.tgz /home/docker/wrf-hydro-training
RUN chown -R docker:docker /home/docker/wrf-hydro-training/example_case # && \
    chown -R docker:docker /home/docker/miniconda3

## SWITCH TO USER "DOCKER"

USER docker
WORKDIR /home/docker
ENV version=v5.1.0

# get regridding scripts
RUN wget https://ral.ucar.edu/sites/default/files/public/ESMFregrid_NLDAS.tar_.gz \
	&& tar -xf ESMFregrid_NLDAS.tar_.gz \
	&& mv NLDAS /home/docker/wrf-hydro-training/regridding \
	&& rm ESMFregrid_NLDAS.tar_.gz

COPY ./gdrive_download.py gdrive_download.py
#RUN chmod +x gdrive_download.py

RUN mkdir /home/docker/wrf-hydro-training/regridding/data/ \
  && python gdrive_download.py --file_id 1yyfO2ofec49H4SqR-RuFly9mJPqs73Hw \ 
  --dest_file /home/docker/wrf-hydro-training/regridding/data/nldas_forcing.tar.gz

RUN rm gdrive_download.py

RUN git clone --branch ${version} https://github.com/NCAR/wrf_hydro_nwm_public
RUN mv /home/docker/wrf_hydro_nwm_public /home/docker/wrf-hydro-training/wrf_hydro_nwm_public

RUN git clone --branch RFC_Training https://github.com/NCAR/wrf_hydro_training
RUN mv /home/docker/wrf_hydro_training/lessons/training /home/docker/wrf-hydro-training/lessons
RUN rm -rf /home/docker/wrf_hydro_training/

### second stage build

FROM wrfhydro/dev:base
USER docker
WORKDIR /home/docker

COPY --from=build --chown=docker:docker /home/docker /home/docker
COPY --chown=docker:docker ./entrypoint.sh /.
COPY --chown=docker:docker ./jupyter_notebook_config.py /home/docker/.jupyter/

ENTRYPOINT ["/entrypoint.sh"]
CMD ["interactive"]
