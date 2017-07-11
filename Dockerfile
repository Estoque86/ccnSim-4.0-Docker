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
  gcc \
  g++ \
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
# Fetch Reduced Omntepp-5.0 (no ide and samples)
RUN wget https://github.com/Estoque86/ccnSim-4.0-Docker/raw/master/omnetpp-5.0.tgz
RUN tar -xf omnetpp-5.0.tgz

# Set env variables
ENV PATH $PATH:/usr/omnetpp/omnetpp-5.0/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/omnetpp/omnetpp-5.0/lib

# Configure and compile omnet++
RUN cd omnetpp-5.0 && \
    xvfb-run ./configure && \
    make

# Install Boost Libraries
RUN mkdir -p /usr/boost
WORKDIR /usr/boost
RUN wget http://sourceforge.net/projects/boost/files/boost/1.57.0/boost_1_57_0.tar.gz
RUN tar -zxvf boost_1_57_0.tar.gz
RUN cd boost_1_57_0 && \
    xvfb-run ./bootstrap.sh 
RUN xvfb-run ./b2 install

## ccnSim-v0.4
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

# Cleanup
## (YES) RUN apt-get clean && \
## (YES)   rm -rf /var/lib/apt && \
## (YES)   rm /usr/omnetpp/omnetpp-5.0-src.tgz