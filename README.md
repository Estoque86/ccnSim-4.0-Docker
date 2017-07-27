# Instructions to use a ccnSim-0.4 container 

These instructions will guide you through setting up the Docker environment to quickly launch ccnSim-0.4 simulation without the hassle of patching Omnetpp, downloading the required librairies,  compiling the code, etc. 

You can use a local copy of the container, or the image hosted on DockerHub  https://hub.docker.com/r/nonsns/ccnsim-0.4/


## Install Docker on your platform

* OS X 
Please follow instructions at: https://docs.docker.com/docker-for-mac/install/

* Ubuntu 16.04 
 
Add the GPG key for the official Docker repository to the system:
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo \
apt-key add -

Add the Docker repository to APT sources:
$ sudo add-apt-repository "deb [arch=amd64] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

Update the package database with the Docker packages from the newly added repo:
$ sudo apt-get update

Make sure you are about to install from the Docker repo instead of the default Ubuntu 16.04 repo:
$ apt-cache policy docker-ce

Install Docker:
$ sudo apt-get install -y docker-ce


##  Fetch ccnSim Docker image

* Local copy 
http://perso.telecom-paristech.fr/~tortelli/documents/dk-ccnsim-04.tar.gz

* Docket hub 
no need to install 


## Load the fetched image

* OS X
$ gunzip -c dk-ccnsim-04.tar.gz | sudo docker load

* Ubuntu
$ zcat dk-ccnsim-04.tar.gz | sudo docker load

In both platforms, you should be able to see the imported image by typing:
$ sudo docker images 


##  Create your working directory

$ mkdir ccnsim-0.4
$ cd ccnsim-0.4
$ mkdir results logs infoSim


## Run the ccnSim container

* DockerHub

$ sudo docker run -ti -v $(pwd)/infoSim:/usr/ccnSim/ccnSim-0.4/infoSim/ -v $(pwd)/results:/usr/ccnSim/ccnSim-0.4/results/ -v $(pwd)/logs:/usr/ccnSim/ccnSim-0.4/logs/ nonsns/ccnsim-0.4 /bin/bash

* Local image

$ sudo docker run -ti -v $(pwd)/infoSim:/usr/ccnSim/ccnSim-0.4/infoSim/ -v $(pwd)/results:/usr/ccnSim/ccnSim-0.4/results/ -v $(pwd)/logs:/usr/ccnSim/ccnSim-0.4/logs/ ccnSim-0.4-dockerimage.tar.gz /bin/bash

With the command above we launch the ccnSim container in “interactive” mode, by specifying three “volumes” (i.e., logs, results, infoSim) which will be mounted from the local directory on the host machine each time the container is launched. 
Therefore, at each startup of the ccnSim container, files present in the specified volumes will be copied inside the respective directories of the container. 

## Launch a sample simulation

We are going to simulate a relatively small scenario (M=108 contents, tree topology).

$ ./runsim_script_ED_TTL.sh tree 8 1 spr lce ttl 1 1e6 1e6 1e9 1e9 20.0 IRM IRM 0 0 cold naive 0.75 1e5

Please have look at the ccnSim-0.4 manual (http://perso.telecom-paristech.fr/~drossi/index.php?n=Software.CcnSim?action=downloadman&upname=ccnSim-v0.4-Manual.pdf) for a complete description of the simulation process.

## Detach/Attach 

$ Ctrl+p, Ctrl+q
$ sudo docker ps (you should see the running container)
$ sudo docker attach containerID

$ exit (will exit the container prompt and stop the respective process)

## Have fun!

This is all you need to launch a ccnSim-0.4 container.   Now, to really make use of ccnSim-0.4, check its manual


