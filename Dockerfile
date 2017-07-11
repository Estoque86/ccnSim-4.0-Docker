FROM ubuntu:latest
MAINTAINER Michele Tortelli <michele.tortelli@telecom-paristech.fr>
LABEL Description="Docker image for ccnSim-v4.0 simulator"

RUN apt-get update

# General dependencies for Omnet++
# RUN apt-get install -y \
#   gcc \
#   g++ \
#   wget \
#   vim \
#   build-essential \
#   clang \
#   bison \
#   flex \
#   perl \
#   libxml2-dev \
#   zlib1g-dev \
#   default-jre \
#   tk-dev \
#   tcl-dev \
#   libwebkitgtk-1.0-0 \
#   xvfb

#tk-dev
#git
#tcl-dev 
#doxygen
#graphviz
#xvfb  // Display server

RUN apt-get install -y \
  wget \
  vim \
  subversion \
  apache2 \
  libapache2-svn \
  build-essential \
  clang \
  bison \
  flex \
  perl \
  libxml2-dev \
  zlib1g-dev \
  default-jre \
  libwebkitgtk-1.0-0 \
  xvfb


# OMNeT++ 5.0
# Create working directory
RUN mkdir -p /usr/omnetpp
WORKDIR /usr/omnetpp
# Fetch pre-compiled binaries and libs (already patched for ccnSim)
RUN svn export https://github.com/Estoque86/ccnSim-4.0-Docker/trunk/bin bin
RUN svn export https://github.com/Estoque86/ccnSim-4.0-Docker/trunk/lib lib

# Fetch Omnet++ source
# (Official mirror doesn't support command line downloads...)
## (YES) RUN wget https://github.com/ryankurte/docker-omnetpp/raw/master/omnetpp-5.0-src.tgz
# (NB) We need to put a .tgz file on our git 


## (YES) RUN tar -xf omnetpp-5.0-src.tgz

# Compilation requires path to be set
## (YES)ENV PATH $PATH:/usr/omnetpp/omnetpp-5.0/bin
## (YES)ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/omnetpp/omnetpp-5.0/lib

ENV PATH $PATH:/usr/omnetpp/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/omnetpp/lib

# Configure and compile omnet++
## (YES) RUN cd omnetpp-5.0 && \
## (YES)     xvfb-run ./configure WITH_TKENV=no WITH_QTENV=no && \
## (YES)     make

# Cleanup
## (YES) RUN apt-get clean && \
## (YES)   rm -rf /var/lib/apt && \
## (YES)   rm /usr/omnetpp/omnetpp-5.0-src.tgz

## ADD ccnSim (download, change directory, and compile)
RUN mkdir -p /usr/ccnSim
WORKDIR /usr/ccnSim

RUN wget https://github.com/Estoque86/ccnSim-4.0-Docker/raw/master/ccnSim-0.4.tgz
RUN tar -xf ccnSim-0.4.tgz
RUN cd ccnSim-0.4 && \
    xvfb-run ./scripts/makemake.sh && \
    make

# Cleanup
RUN apt-get clean && \
  rm -rf /var/lib/apt
