FROM wrfhydro/dev:base
MAINTAINER Joe Mills <jmills@ucar.edu>

USER root

#Install R
RUN apt-get update \
    && apt-get install -yq --no-install-recommends \
    r-base-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev

#Install packages required by devtools
RUN Rscript -e "install.packages(c('curl','httr','git2r'),repos='http://cran.us.r-project.org')"

#Install devtools
RUN Rscript -e "install.packages('devtools',repos='http://cran.us.r-project.org')"

# Install some suggested packages
RUN Rscript -e "install.packages(c('doMC','foreach','rgdal','rgeos','dplyr'),repos='http://cran.us.r-project.org')"

# Install rwrfhydro
RUN Rscript -e "devtools::install_github('NCAR/rwrfhydro')"

