FROM wrfhydro/dev:base
USER docker
WORKDIR /home/docker

ENV VERSION=5.3.0
RUN wget https://github.com/NCAR/wrf_hydro_nwm_public/archive/refs/tags/v${VERSION}.tar.gz \
    && tar zxf v${VERSION}.tar.gz \
    && cd wrf_hydro_nwm_public-${VERSION} \
    && cmake -B build \
    && make -C build -j
