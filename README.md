# wrf_hydro_docker
##Docker containers for wrf_hydro modeling system. 

The containers are additive, to keep them small and modular. Build
scripts dont currently build all the dependencies on request, but they could.

Containers to be shared on docker hub are currently built to
wrfhydro/containername. They can be pulled directly from there without
need for these Dockerfiles. Their additive nature helps minimize the
amount of redundant data coming across the network.

## ubuntu
wrfhydro/ubuntu = phusion/baseimage 

The base ubuntu distribution version used for some of the other
containers. Currently this is taken from phusion/baseimage, which is
built on ubuntu 16.04

## nco
wrfhydro/nco = wrfhydro/ubuntu +   

Installs nco and nvciew ontop of the ubuntu container.

## ncl
wrfhydro/ncl = wrfhydro/nco +  

A data container for ncl

## gcc_default
wrfhydro/gcc\_default = wrfhydro/ubuntu +  

Brings in necessary compiling tools and libraries using the default
gcc on the base ubuntu: gfortran, MPICH, netcdf4, etc.

## dev
wrfhydro/dev = wrfhydro/gcc_default + wrfhydro/nco +  

An environment for interactive development on the HOST machine. See
the README in dev/. Includes interfaces for compiling and running
wrf\_hydro which mount HOST system files and relay HOST system
envrionment variables. Combines the compilation capabilities with nco
installs. 

## gcc_7
wrfhydro/gcc\_7 = wrfhydro/gcc_default +  

This upgrades the gcc_default for the ubuntu docker to gcc-7, whatever
the current choice is under apt. Then it builds MPICH 3.2 on top of
that.

Currently NOT building NETCDF ontop of gcc-7.

## gcc_8.0
wrfhydro/gcc\_8 = wrfhydro/gcc_7 + 

(In progress.)

This docker installs open-coarrays which builds gcc_8
(teams-20170919.tar.gz) and I believes also installs MPICH. 

Then netcdf is build on the gcc_8 install.


## testing
wrfhydro/testing = dev +   

(In progress.)

## rwrfhydro
?? Additive?

A container just for running command-line R. 

## rwrfhydro-studio
Not yet additive.

A container for Rstudio in additon to rwrfhyro

## ford
wrfhydro/ford = gcc_default + 

A container for running FORD + graphviz and generating documentation.

## data_sixmile
wrfhydro/data\_sixmile = ubuntu +

A container for shipping the sixmile domain and populating a docker
data volume. 

## CI_images
Not yet additive.

## WPS_docker
Not yet additive.
