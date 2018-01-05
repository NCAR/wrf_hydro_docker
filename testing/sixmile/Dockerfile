###################################
# WRF-Hydro Development docker
# Purpose:
#   Encapsulate the tools required for testing WRF-Hydro
# Authors: James McCreight, Joe Mills
# Email:  jamesmcc-at-ucar.edu, jmills@-at-car.edu
# Date:  11.2.2017
###################################

FROM wrfhydro/domains:sixmile AS DOMAIN

FROM wrfhydro/dev 

MAINTAINER jamesmcc

###################################
USER root
    
WORKDIR /root

###################################
## Testing interface script and garnish
COPY ./entrypoint.sh /.
COPY ./gnu.txt /.

###################################
# DOMAIN DATA for test.
COPY --from=DOMAIN /test_domain test_domain

ENTRYPOINT ["/entrypoint.sh"]
CMD [""]