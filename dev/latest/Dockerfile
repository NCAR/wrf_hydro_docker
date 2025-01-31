FROM wrfhydro/dev:base
USER root

# install dependencies
RUN apt-get update \
    && apt-get install -yq --no-install-recommends \
    bc \
    gdal-bin \
    libgdal-dev \
    libpng-dev \
    libssl-dev \
    libswitch-perl \
    libxml2-dev \
    locales \
    m4 \
    nodejs \
    pkg-config \
    python3-dask \
    python3-geopandas \
    python3-ipython \
    python3-ipywidgets \
    python3-h5py \
    python3-mpi4py \
    python3-matplotlib \
    python3-netcdf4 \
    python3-numpy \
    python3-pyproj \
    python3-rasterio \
    python3-toolz \
    python3-xarray \
    r-base-core \
    valgrind \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && update-alternatives --config csh

# cleanup
RUN rm -rf /tmp/*
RUN chmod -R 777 /home/docker/

# Miniconda and remaining Python packages
WORKDIR /home/docker
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash Miniconda3-latest-Linux-x86_64.sh -b -p /home/docker/miniconda3 \
    && rm Miniconda3-latest-Linux-x86_64.sh \
    && chown -R docker:docker /home/docker/miniconda3
ENV PATH="/home/docker/miniconda3/bin:${PATH}"
RUN conda install -y -c conda-forge \
    bash_kernel \
    conda-project \
    esmpy \
    gdown \
    hvplot \
    ipyleaflet \
    ipympl \
    jupyterlab \
    jupyter_contrib_nbextensions \
    whitebox \
    xrviz

# R packages
RUN wget https://cran.r-project.org/src/contrib/ncdf4_1.23.tar.gz \
        && R CMD INSTALL ncdf4_1.23.tar.gz  \
        && rm ncdf4_1.23.tar.gz \
        && Rscript -e 'install.packages(c("optparse","stringr","plyr"), repos="https://cran.rstudio.com")'

# # Jupyter configuration script
# COPY ./jupyter_notebook_config.py /home/docker/.jupyter/
# RUN chmod -R 777 /home/docker/.jupyter

USER docker
WORKDIR /home/docker
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/bin:/home/docker/miniconda3/bin
ENV SHELL=bash
