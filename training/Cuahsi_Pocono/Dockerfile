FROM wrfhydro/training:v5.2.0-rc1
USER root
WORKDIR /home/docker
RUN rm -rf GIS_Training
RUN rm -rf wrf-hydro-training
RUN mkdir /home/docker/wrf-hydro-training \
        && chmod -R 777 /home/docker/wrf-hydro-training \
        && mkdir /home/docker/GIS_Training \
        && chmod -R 777 /home/docker/GIS_Training
RUN conda install whitebox -c conda-forge
RUN ln -s /usr/lib/x86_64-linux-gnu/liblapack.so.3 /usr/lib/x86_64-linux-gnu/liblapack.so
RUN ln -s /usr/lib/x86_64-linux-gnu/libblas.so.3 /usr/lib/x86_64-linux-gnu/libblas.so
USER docker
COPY ./jupyter_notebook_config.py /home/docker/.jupyter
EXPOSE 8888
USER root
COPY ./entrypoint.sh /.
RUN chmod 777 /entrypoint.sh
USER docker
ENTRYPOINT ["/entrypoint.sh"]
CMD ["interactive"]
