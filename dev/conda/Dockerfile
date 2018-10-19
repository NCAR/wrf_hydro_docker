FROM wrfhydro/dev:base

MAINTAINER jamesmcc@ucar.edu

#Install modules
RUN conda install -c conda-forge -y jupyterlab cartopy rasterio netcdf4 dask f90nml deepdiff \
xarray plotnine boltons jupyter_contrib_nbextensions termcolor
RUN pip install pytest pytest-datadir-ng pytest-html wrfhydropy
