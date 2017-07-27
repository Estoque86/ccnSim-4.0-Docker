FROM ubuntu:latest  
MAINTAINER Michele Tortelli <michele.tortelli@telecom-paristech.fr>
LABEL Description="Docker image for ccnSim-v4.0 simulator"


# General dependencies and libraries
RUN apt-get update && \
  apt-get install -y \
  wget \
  vim \
  bc \
  time \
  build-essential \
  gcc \
  g++ \
  bison \
  flex \
  perl \
  python-dev \
  libxml2-dev \
  libxslt-dev \
  libbz2-dev \
  zlib1g-dev \
  default-jre \
  libwebkitgtk-1.0-0 \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get remove xserver-xorg-core \
  && apt-get autoremove

# Set env variables
ENV PATH $PATH:/usr/omnetpp/omnetpp-5.0/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/omnetpp/omnetpp-5.0/lib

### OMNeT++ 5.0 ###
# Create working directory and fetch "reduced" Omntepp-5.0 (no ide and samples)
RUN mkdir -p /usr/omnetpp
WORKDIR /usr/omnetpp
RUN wget https://github.com/TeamRossi/ccnSim-0.4-docker/raw/master/omnetpp-5.0.tgz && \
    tar -xf omnetpp-5.0.tgz && \
    rm omnetpp-5.0.tgz && \
    cd /usr/omnetpp/omnetpp-5.0 && \
    ./configure && \
    make

### Boost Libraries ###
RUN mkdir -p /usr/boost
WORKDIR /usr/boost
RUN wget http://sourceforge.net/projects/boost/files/boost/1.57.0/boost_1_57_0.tar.gz && \
    tar -zxvf boost_1_57_0.tar.gz && \
    rm boost_1_57_0.tar.gz && \
    cd boost_1_57_0 && \
    ./bootstrap.sh && \
    cd /usr/boost/boost_1_57_0 && \
    ./b2 install && \
    cd /usr && \
    rm -r /usr/boost/

### ccnSim-0.4 ###
RUN mkdir -p /usr/ccnSim
WORKDIR /usr/ccnSim
RUN wget https://github.com/TeamRossi/ccnSim-0.4-docker/raw/master/ccnSim-0.4.tgz && \
    tar -zxvf ccnSim-0.4.tgz && \
    rm ccnSim-0.4.tgz && \
    cd /usr/ccnSim/ccnSim-0.4 && \
    ./scripts/makemake.sh && \
    cd /usr/ccnSim/ccnSim-0.4 && \
    make

WORKDIR /usr/ccnSim/ccnSim-0.4

# Cleanup
RUN apt-get clean && \
  rm -rf /var/lib/apt /tmp/* /var/tmp/*