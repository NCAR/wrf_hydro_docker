###################################
# Image name: wrfhydro/training:c5_0_0
# Author: Joe Mills <jmills@ucar.edu>
# Date:  2018-05-22
###################################
FROM wrfhydro/dev:base

MAINTAINER jmills@ucar.edu
USER root

RUN mkdir /home/docker/wrf-hydro-training \
    && chmod -R 777 /home/docker/wrf-hydro-training
##################################
#get regridding scripts
RUN wget https://ral.ucar.edu/sites/default/files/public/ESMFregrid_NLDAS.tar_.gz \
	&& tar -xf ESMFregrid_NLDAS.tar_.gz \
	&& mv NLDAS /home/docker/wrf-hydro-training/regridding \
	&& rm ESMFregrid_NLDAS.tar_.gz

COPY ./gdrive_download.py gdrive_download.py
RUN chmod 777 gdrive_download.py

RUN mkdir /home/docker/wrf-hydro-training/regridding/data/ \
  && python gdrive_download.py --file_id 1yyfO2ofec49H4SqR-RuFly9mJPqs73Hw --dest_file /home/docker/wrf-hydro-training/regridding/data/nldas_forcing.tar.gz

RUN rm gdrive_download.py
# install NCL
RUN wget https://www.earthsystemgrid.org/dataset/ncl.640.dap/file/ncl_ncarg-6.4.0-Debian8.6_64bit_gnu492.tar.gz \
  && mkdir /usr/local/ncl-6.4.0 \
  && tar -xzf ncl_ncarg-6.4.0-Debian8.6_64bit_gnu492.tar.gz -C /usr/local/ncl-6.4.0 \
  && rm ncl_ncarg-6.4.0-Debian8.6_64bit_gnu492.tar.gz

ENV NCARG_ROOT=/usr/local/ncl-6.4.0
ENV PATH=$NCARG_ROOT/bin:$PATH

############################
## Python
#Install modules
RUN pip install jupyterlab jupyter_contrib_nbextensions ipython matplotlib h5py netcdf4 dask toolz xarray

#Get jupyter config
COPY ./jupyter_notebook_config.py /home/docker/.jupyter/
RUN chmod -R 777 /home/docker/.jupyter

############################
#Get the entrypoint script to download the code release, start jupyter, etc
COPY ./entrypoint.sh /.
RUN chmod 777 /entrypoint.sh
RUN chmod -R 777 /home/docker/wrf-hydro-training/

USER docker
WORKDIR /home/docker

ENTRYPOINT ["/entrypoint.sh"]
CMD ["interactive"]
