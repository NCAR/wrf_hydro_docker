###################################
# Image name: wrfhydro/training:c5_0_0
# Author: Joe Mills <jmills@ucar.edu>
# Date:  2018-05-22
###################################
FROM wrfhydro/wps

MAINTAINER jmills@ucar.edu
USER root

RUN rm -r /home/docker/runTimeScripts

#Get the entrypoint script to download the code release, jupyter, etc
COPY ./entrypoint.sh /.
RUN chmod 777 /entrypoint.sh

#Get jupyter config
COPY ./jupyter_notebook_config.py /home/docker/.jupyter/
RUN chmod -R 777 /home/docker/.jupyter

# Copy in the domain
#COPY --from=domain /home/docker/domain/croton_NY /home/docker/domain/croton_NY
#RUN chmod -R 777 /home/docker/domain/

USER docker
WORKDIR /home/docker

ENTRYPOINT ["/entrypoint.sh"]
CMD ["interactive"]