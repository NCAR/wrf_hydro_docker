###################################
# Image name: wrfhydro/training:c5_0_0
# Author: Joe Mills <jmills@ucar.edu>
# Date:  2018-05-22
###################################
FROM wrfhydro/wps

MAINTAINER jmills@ucar.edu
USER root

##################################
# Geospatial
#Get create_wrfinput.r
RUN mkdir /home/docker/wrf-hydro-training
RUN chmod -R 777 /home/docker/wrf-hydro-training
COPY ./create_wrfinput.R /home/docker/wrf-hydro-training/wrf_hydro_model_tools/create_wrfinput.R

#get regridding scripts
RUN wget https://ral.ucar.edu/sites/default/files/public/ESMFregrid_NLDAS.tar_.gz \
	&& tar -xf ESMFregrid_NLDAS.tar_.gz \
	&& mv NLDAS /home/docker/wrf-hydro-training/regridding \
	&& rm ESMFregrid_NLDAS.tar_.gz

COPY ./gdrive_download.py gdrive_download.py
RUN chmod 777 gdrive_download.py

RUN mkdir /home/docker/wrf-hydro-training/regridding/data/ \
  && python gdrive_download.py --file_id 1PrDTA-hMFNqQrDag1Dm7tX1rT1gQ_25e --dest_file /home/docker/wrf-hydro-training/regridding/data/nldas_forcing.tar.gz

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
RUN pip install jupyterlab jupyter_contrib_nbextensions

#Get jupyter config
COPY ./jupyter_notebook_config.py /home/docker/.jupyter/
RUN chmod -R 777 /home/docker/.jupyter

############################
## R
#install R and libraries

RUN apt-get update \
    && apt-get install -yq --no-install-recommends \
    r-base \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget http://cirrus.ucsd.edu/~pierce/ncdf/ncdf4_1.13.tar.gz \
	&& R CMD INSTALL ncdf4_1.13.tar.gz  \
	&& rm ncdf4_1.13.tar.gz

RUN Rscript -e 'install.packages(c("optparse"), repos="https://cran.rstudio.com")'

############################
#Get the entrypoint script to download the code release, start jupyter, etc
COPY ./entrypoint.sh /.
RUN chmod 777 /entrypoint.sh

RUN chmod -R 777 /home/docker/wrf-hydro-training/

USER docker
WORKDIR /home/docker

ENTRYPOINT ["/entrypoint.sh"]
CMD ["interactive"]