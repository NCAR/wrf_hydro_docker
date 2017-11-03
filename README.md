# wrf_hydro_docker
Docker containers for wrf_hydro modeling system

## ubuntu
The base ubuntu distribution version used for some of the other
containers.

## nco
nco = ubuntu + 
Installs nco and nvciew ontop of the ubuntu container.

## ncl
ncl = nco +

## gcc_default
gcc\_default = ubuntu +
Brings in necessary compiling tools and libraries using the default
gcc on the base ubuntu: gfortran, MPICH, netcdf4, etc.

## dev
dev = gcc_default + nco +
An environment for interactive development on the HOST machine. See
the README in dev/. Includes interfaces for compiling and running
wrf\_hydro which mount HOST system files and relay HOST system
envrionment variables. Combines the compilation capabilities with nco
installs. 

## gcc_8.0
Still working on this.

## testing
testing = dev + 
Still working on this

