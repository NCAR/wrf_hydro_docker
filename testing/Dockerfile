###################################
# WRF-Hydro Development docker
# Purpose:
#   Encapsulate the tools required for testing WRF-Hydro
# Authors: James McCreight, Joe Mills
# Email:  jamesmcc-at-ucar.edu, jmills@-at-car.edu
# Date:  11.2.2017
###################################

FROM wrfhydro/gcc_default AS compiler


FROM wrfhydro/dev
COPY --from=compiler / /
## JLM: I dont understand the failure of libmpi.so.12
## JLM: `ldd wrf_hydro...exe` only implies the following. 
#COPY --from=builder /usr /usr
#COPY --from=builder /lib/x86_64-linux-gnu/ /lib/x86_64-linux-gnu/

MAINTAINER jamesmcc

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

###################################
# DATA for test.
# Eventually, have a service that will pull data on the fly.
COPY test.files.frng.nwm test.files.frng.nwm

###################################
## wrf-hydro development docker interface script
#COPY ./entrypoint.sh /.

###################################
## create docker user
RUN useradd -ms /bin/bash docker
RUN usermod -aG sudo docker

####################################
######### docker user ###########
####################################
USER docker
#RUN cp /interface.sh ~/.
RUN cd $HOME
ENTRYPOINT ["/interface.sh"]
CMD ["interactive"]