###################################
# Image name: wrfhydro/training:c5_0_0
# Author: Joe Mills <jmills@ucar.edu>
# Date:  2018-05-22
###################################
FROM wrfhydro/domains:croton_NY as domain
FROM wrfhydro/dev:conda as dev_conda
FROM wrfhydro/wps

MAINTAINER jmills@ucar.edu
USER root

RUN rm -r /home/docker/runTimeScripts

#Get the script to download the code release
COPY ./entrypoint.sh /.
RUN chmod 777 /entrypoint.sh

# Copy in the domain
COPY --from=domain /home/docker/domain/croton_NY /home/docker/domain/croton_NY
RUN chmod -R 777 /home/docker/domain/

# Copy in miniconda
COPY --from=dev_conda /home/docker/miniconda3 /home/docker/miniconda3
#RUN chmod -R 777 /home/docker/miniconda3

# Add python to path
RUN export PATH=/home/docker/miniconda3/bin:$PATH

USER docker
WORKDIR /home/docker

ENTRYPOINT ["/entrypoint.sh"]
CMD ["interactive"]