# MAINTAINER oatkrittin@gmail.com
FROM ubuntu:16.04

# Installation instructions: https://github.com/DReichLab/EIG

ENV EIGENSOFT_HOME      /usr/local/eigensoft
ENV PATH                $EIGENSOFT_HOME/bin:$PATH
ENV ZIPPED_REPO_NAME    EIG-master 

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y universe && \
    apt-get install -y unzip wget build-essential libgsl-dev libopenblas-dev liblapacke-dev && \
    apt-get install -y gnuplot ghostscript && \
    wget https://github.com/DReichLab/EIG/archive/master.zip && \
    unzip master.zip -d $ZIPPED_REPO_NAME && \
    mv $ZIPPED_REPO_NAME/* $EIGENSOFT_HOME && \
    rm master.zip && \
    cd ${EIGENSOFT_HOME}/src && \
    make LDLIBS="-llapacke" install && \
    DEBIAN_FRONTEND=noninteractive apt-get autoremove -y unzip wget && \
    rm -rf /var/lib/apt/lists/*

# Fixed not found global perl
RUN sed -i "/\/usr\/local\/bin\/perl/c\\\#\!\/usr\/bin\/perl -w" ${EIGENSOFT_HOME}/bin/ploteig

# Fixed Error using ploteig https://github.com/DReichLab/EIG/issues/13
RUN sed -i "/fixgreen/c\\" ${EIGENSOFT_HOME}/bin/ploteig
