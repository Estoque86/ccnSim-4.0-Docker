#FROM ubuntu:latest  
# To be replaced with a specific version of Ubuntu
FROM phusion/baseimage:0.9.22
MAINTAINER Michele Tortelli <michele.tortelli@telecom-paristech.fr>
LABEL Description="Docker image for ccnSim-v4.0 simulator"

CMD ["/sbin/my_init"]

#RUN apt-get update

# General dependencies for Omnet++

#tk-dev
#git
#tcl-dev 
#doxygen
#graphviz
#xvfb  // Display server
#  subversion \
#  apache2 \
#  libapache2-svn \
# clang
# xvfb


RUN apt-get install -y \
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
  libwebkitgtk-1.0-0 


# OMNeT++ 5.0
# Create working directory
RUN mkdir -p /usr/omnetpp
WORKDIR /usr/omnetpp
# Fetch Reduced Omntepp-5.0 (no ide and samples)
RUN wget https://github.com/Estoque86/ccnSim-4.0-Docker/raw/master/omnetpp-5.0.tgz && \
    tar -xf omnetpp-5.0.tgz && rm omnetpp-5.0.tgz

# Set env variables
ENV PATH $PATH:/usr/omnetpp/omnetpp-5.0/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/omnetpp/omnetpp-5.0/lib

# Configure and compile omnet++
RUN cd omnetpp-5.0 && \
    ./configure && \
    make

# Install Boost Libraries
RUN mkdir -p /usr/boost
WORKDIR /usr/boost
RUN wget http://sourceforge.net/projects/boost/files/boost/1.57.0/boost_1_57_0.tar.gz && \
    tar -zxvf boost_1_57_0.tar.gz && \
    rm boost_1_57_0.tar.gz && \
    cd boost_1_57_0 && \
    ./bootstrap.sh && \
    cd /usr/boost/boost_1_57_0 && \
    ./b2 install
#WORKDIR /usr/boost/boost_1_57_0
#RUN ./b2 install

## ccnSim-v0.4
RUN mkdir -p /usr/ccnSim
WORKDIR /usr/ccnSim

RUN wget https://github.com/Estoque86/ccnSim-4.0-Docker/raw/master/ccnSim-0.4.tgz && \
    tar -zxvf ccnSim-0.4.tgz && \
    rm ccnSim-0.4.tgz && \
    cd /usr/ccnSim/ccnSim-0.4 && \
    ./scripts/makemake.sh && \
    cd /usr/ccnSim/ccnSim-0.4 && \
    make

#WORKDIR /usr/ccnSim/ccnSim-0.4
#RUN ./scripts/makemake.sh 
#RUN make

## (NB) Check why Tc file was empty    

# Cleanup
RUN apt-get clean && \
  rm -rf /var/lib/apt /tmp/* /var/tmp/*