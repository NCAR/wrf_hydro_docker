###################################
# Author: James McCreight <jamesmcc -at- ucar.edu>
# Date:  11.1.17
###################################

FROM wrfhydro/dev:base

MAINTAINER jamesmcc

# base install of ford (not trying hard to optimize): 
# with python-pydot + python-pydot-ng + graphviz 

####################################
########## ROOT USER  ##############

USER root

     #https://www.saltycrane.com/blog/2010/02/how-install-pip-ubuntu/

RUN apt-get install -yq --no-install-recommends software-properties-common \
    && apt-add-repository universe \
    && apt-get update \
    && apt-get install -yq --no-install-recommends \
    python-pip \
    python-dev \
    build-essential \
    python-setuptools \
    python-pydot \
    python-pydot-ng \
    graphviz \
    && pip install --upgrade pip \
    && pip install --upgrade virtualenv \
    && pip install ford
