###################################
# Image name: wrfhydro/training:c5_0_0
# Author: Joe Mills <jmills@ucar.edu>
# Date:  2018-05-22
###################################
FROM wrfhydro/wps

MAINTAINER jmills@ucar.edu
USER root

RUN rm -r /home/docker/runTimeScripts

#Get create_wrfinput.r
RUN mkdir /home/docker/wrf-hydro-training
RUN chmod -R 777 /home/docker/wrf-hydro-training
COPY ./create_wrfinput.R /home/docker/wrf-hydro-training/wrf_hydro_model_tools/create_wrfinput.R

#Get the entrypoint script to download the code release, start jupyter, etc
COPY ./entrypoint.sh /.
RUN chmod 777 /entrypoint.sh

############################
## Python
#Install modules
RUN conda install -y jupyterlab jupyter_contrib_nbextensions

#Get jupyter config
COPY ./jupyter_notebook_config.py /home/docker/.jupyter/
RUN chmod -R 777 /home/docker/.jupyter

#Update nc-config with manually edited one to fix miniconda path bug
RUN rm /home/docker/miniconda3/bin/nc-config
COPY ./nc-config /home/docker/miniconda3/bin/nc-config
RUN chmod 777 /home/docker/miniconda3/bin/nc-config

############################
## R
#install R and libraries
RUN apt-get update \
    && apt-get install -yq --no-install-recommends \
    r-base \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget http://cirrus.ucsd.edu/~pierce/ncdf/ncdf4_1.13.tar.gz \
	&& R CMD INSTALL ncdf4_1.13.tar.gz --configure-args="--with-nc-config=/home/docker/miniconda3/bin/nc-config" \
	&& rm ncdf4_1.13.tar.gz

RUN Rscript -e 'install.packages(c("optparse"), repos="https://cran.rstudio.com")'

############################

USER docker
WORKDIR /home/docker

ENTRYPOINT ["/entrypoint.sh"]
CMD ["interactive"]