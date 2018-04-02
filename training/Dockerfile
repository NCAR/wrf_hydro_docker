###################################
# Image name: wrfhydro/training:c5_0_0
# Author: Joe Mills <jmills@ucar.edu>
# Date:  2018-02-05
###################################
FROM wrfhydro/domains:croton_NY as domain
FROM wrfhydro/dev:conda

MAINTAINER jmills@ucar.edu
USER root

RUN rm -r /home/docker/runTimeScripts

#Get the script to download the code release
COPY ./entrypoint.sh /.
RUN chmod 777 /entrypoint.sh

COPY --from=domain /home/docker/domain/croton_NY /home/docker/domain/croton_NY
RUN chmod -R 777 /home/docker/domain/

COPY ./introDemo.sh /home/docker/howto/
COPY ./walkthrough.md /home/docker/howto/
COPY ./walkthrough.html /home/docker/howto/

COPY ./plot_hydrograph.py /home/docker/utilities/
RUN chmod -R 777 /home/docker/utilities

USER docker
WORKDIR /home/docker

ENTRYPOINT ["/entrypoint.sh"]
CMD ["interactive"]