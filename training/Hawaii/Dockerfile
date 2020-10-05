###################################
# Image name: wrfhydro/hawaii-training
# Author: Katelyn FitzGerald <katelynw@ucar.edu>
# Date:  2020-09-01
###################################
FROM wrfhydro/dev:base as build

MAINTAINER katelynw@ucar.edu
USER root

RUN mkdir /home/docker/wrf-hydro-training \
    && chown docker:docker /home/docker/wrf-hydro-training

# install Python modules

RUN conda install nodejs

RUN pip install --upgrade pip && \
    pip install jupyterlab jupyter_contrib_nbextensions ipython \
    matplotlib h5py netcdf4 dask toolz xarray \
    numpy cython pandas psutil

RUN conda install -c conda-forge xrviz

RUN jupyter labextension install @jupyterlab/toc
RUN jupyter labextension install @pyviz/jupyterlab_pyviz

COPY --chown=docker:docker ./entrypoint.sh /.
COPY --chown=docker:docker ./jupyter_notebook_config.py /home/docker/.jupyter/

ADD example_case.tar.gz /home/docker/wrf-hydro-training
RUN chown -R docker:docker /home/docker/wrf-hydro-training/example_case

############################
## SWITCH TO USER "DOCKER"

USER docker
WORKDIR /home/docker

RUN git clone --single-branch --branch v5.2.0 https://github.com/NCAR/wrf_hydro_nwm_public \
    && mv /home/docker/wrf_hydro_nwm_public /home/docker/wrf-hydro-training/wrf_hydro_nwm_public
    
RUN git clone -v --single-branch --branch Hawaii_Training https://github.com/NCAR/wrf_hydro_training \
     && mv  /home/docker/wrf_hydro_training/lessons/training /home/docker/wrf-hydro-training/lessons \
     && rm  -rf /home/docker/wrf_hydro_training

RUN chmod -R ugo-s /home/docker/wrf-hydro-training/example_case && \
    chmod -R o-w /home/docker/wrf-hydro-training/example_case && \
    chmod o-w /home/docker

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/bin:/home/docker/miniconda3/bin
ENV SHELL=bash
ENTRYPOINT ["/entrypoint.sh"]
CMD ["interactive"]
