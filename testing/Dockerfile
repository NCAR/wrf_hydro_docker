###################################
# WRF-Hydro Development docker
# Purpose:
#   Encapsulate the tools required for testing WRF-Hydro
# Authors: James McCreight, Joe Mills
# Email:  jamesmcc-at-ucar.edu, jmills@-at-car.edu
# Date:  11.2.2017
###################################

FROM wrfhydro/gcc_default AS builder

FROM wrfhydro/dev
COPY --from=builder / /
## JLM: I dont understand the failure of libmpi.so.12
## JLM: `ldd wrf_hydro...exe` only implies the following. 
#COPY --from=builder /usr /usr
#COPY --from=builder /lib/x86_64-linux-gnu/ /lib/x86_64-linux-gnu/

MAINTAINER jamesmcc

###################################
USER root
###################################
## wrf-hydro development docker interface script
COPY ./entrypoint.sh /.

###################################
## create docker user
RUN rm -rf /home/docker
RUN useradd -ms /bin/bash docker
RUN usermod -aG sudo docker

WORKDIR /home/docker

###################################
# DATA for test.
# Eventually, have a service that will pull data on the fly.
COPY test.files.frng.nwm test.files.frng.nwm
RUN chmod -R 777 /home/docker/test.files.frng.nwm

###################################
USER docker

###################################
# wrf_hydro_nwm repo
# circleCI: cheked out by .circleci/config.yml
# local   : entrypoint checks out the code 
# JLM: how to give it specific commit?

###################################
# wrf_hydro_tools repo
# circleCI: cheked out by .circleci/config.yml
# local   : entrypoint checks out the code
# JLM: how to give it a specific commit?


ENTRYPOINT ["/entrypoint.sh"]
CMD ["interactive"]