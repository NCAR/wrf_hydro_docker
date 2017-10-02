# WRF-Hydro Development Docker

The intent of this docker container is to enable compiling and running
of WRF-Hydro on the HOST without the need to explicitly enter
the docker container. The target audience is developers of the
WRF-Hydro model.

More specifically, code and the run directories are mounted to the container
by shell commands which are presented as function in
`wrf_hydro_tools`. (These functions export working directories and the
HOST user's environment to the docker container without any work on
the user's part).

This approach allows source code to be edited/developed in
applications native to the HOST. It emulates the development process
on a linux environment very closely. It eliminates the need to install
the source code in the docker container, allowing code changes and
development to persist on the HOST as you'd expect.

The docker container also has an iteractive mode for flexibilty.

# Caveats

Unfortunately, the interaction between the HOST filesystem and the
compilation is not seamless. The code will not currently compile in
place. Therefore the source code is copied into the container where it
is compiled. After successful compilation, the resulting binary is
moved back to the HOST system. However, the intermediate,
c-preprocessed files are not moved back to the host. So the state of
the source repo (the untracked files) remains unchanged.  

# Requirements

The `wrf_hydro_tools` repository must be installed with the proper
configuration of the `~/.wrf_hydro_tools file`. To access functions defined in
`wrf_hydro_docker`, the path to `wrf_hydro_docker` must be specifed
in addtion to the requirement of the path to `wrf_hydro_tools` by
itself.  E.g. the following are my choice of location on the machine
where I use docker:

```
jamesmcc@chimayo[541]:~> cat ~/.wrf_hydro_tools
wrf_hydro_tools=~/WRF_Hydro/wrf_hydro_tools
wrf_hydro_docker=~/WRF_Hydro/wrf_hydro_docker
```

# Compile Mode
The function in `wrf_hydro_tools`
```
compile_docker
```
calls `wrf_hydro_docker/development/compile_docker.sh`. The header
of that file has details:
```
# Purpose: Pass the native OS environment variables and
#          the working directory to a docker for compile.
# Arguments:
#   1) the name of the docker container image (optional, default=wrf_hydro_dev)
# Dependencies:
#   wrf_hydro_tools repository installed locally.
# Usage:
# ./compile_docker.sh [some_other_image]
```
## Usage Description:
Run as a substitute for the standard `./compile_NoahMP.sh`
    1. Call it from `wrf_hydro_model/trunk/NDHMS` (actually anywhere in a
       model repo will work).
    2. NOTE: it does not use setEnvars.sh. Compile options are set in the calling
       environment. This can be done easily with the `wrf_hydro_tools`
       function `setHenv`.

# Run Mode
The function in `wrf_hydro_tools`
```
run_docker
```
calls `wrf_hydro_docker/development/run_docker.sh`. The header
of that file has details:
```
# Purpose: Run WRF-Hydro using MPI in a docker container in-place on host.
#          
# Arguments:
#    1: number of processors/cores, required.
#    2: the binary, required.
#    3: the name of the docker container image (optional, default=wrf_hydro_dev)
#
# Note: standard error and standard out are both teed, so they appear in terminal and
#       on file, to wrf_hydro.stdout and wrf_hydro.stderr, respectively.
#
# Usage:
# ./run_docker.sh 4 wrf_hydro.exe [some_other_image]
```
## Usage Description:
Run as a substitute for mpiexec... sort of. Syntax is slightly
different (no -n or -np argument and you dong have to `./` the binary)
and standard output and error are handled for you with tee so that you
also see the output on screen while it is running.

Note that the `run_docker` command currently mounts OSX `/Users/` to `/Users` in
the container.

# Interactive Mode
The function in `wrf_hydro_tools`
```
interactive_docker
```
calls `wrf_hydro_docker/development/interactive_docker.sh`. The header
of that file has details:
```
# Purpose: Pass the native OS environment variables and
#          the working directory to a docker for compile.
# Arguments:
#   1) the name of the docker container image (optional, default=wrf_hydro_dev)
# Dependencies:
#   wrf_hydro_tools repository installed locally.
# Usage:
# ./interactive_docker.sh [some_other_image]
```
## Usage Description:
Basically: enter the container at the same location where the command
is issued. The `interactive_docker` command currently mounts OSX `/Users/` to `/Users` in
the container. The initialization (entrypoint) script puts you in the
working directory from which the command was called. 
