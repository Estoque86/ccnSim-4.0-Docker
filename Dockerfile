FROM ubuntu:latest
MAINTAINER Michele Tortelli <michele.tortelli@telecom-paristech.fr>
LABEL Description="Docker image for ccnSim-v4.0 simulator"

RUN apt-get update

# General dependencies for Omnet++
RUN apt-get install -y \
  gcc \
  g++ \
  wget \
  vim \
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

#tk-dev
#git
#tcl-dev 
#doxygen
#graphviz
#xvfb  // Display server

  
# QT4 components (Graphical interface)
# RUN apt-get install -y \
#   qt4-qmake \
#   libqt4-dev \
#   libqt4-opengl-dev \
#   openscenegraph \
#   libopenscenegraph-dev \
#   openscenegraph-plugin-osgearth \
#   osgearth \
#   osgearth-data \
#   libosgearth-dev

# OMNeT++ 5.0

# Create working directory
RUN mkdir -p /usr/omnetpp
WORKDIR /usr/omnetpp

# Fetch Omnet++ source
# (Official mirror doesn't support command line downloads...)
RUN wget https://github.com/ryankurte/docker-omnetpp/raw/master/omnetpp-5.0-src.tgz
# (NB) We need to put a .tgz file on our git 


RUN tar -xf omnetpp-5.0-src.tgz

# Compilation requires path to be set
ENV PATH $PATH:/usr/omnetpp/omnetpp-5.0/bin

# Configure and compile omnet++
RUN cd omnetpp-5.0 && \
    xvfb-run ./configure WITH_TKENV=no WITH_QTENV=no && \
    make

# Cleanup
RUN apt-get clean && \
  rm -rf /var/lib/apt && \
  rm /usr/omnetpp/omnetpp-5.0-src.tgz
