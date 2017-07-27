This is the GitHub repository containing the (stripped down and already patched) Omnetpp-5.0 and ccnSim-0.4 tarballs as well as the Dockerfile needed to build the Docker image that is available at [https://hub.docker.com/r/nonsns/ccnsim-0.4/](DockerHub)

This is not ment to be used by a final user, so rush to [https://hub.docker.com/r/nonsns/ccnsim-0.4/](DockerHub) instead!  
The rest of this file contains a minimum set of instructions useful to [create](#create) and [use](#use) the DockerHub images.

---

# Instructions to install Docker on your platform

For Microsoft Windows, please install one of the folloiwng OSes and come back later.

For OS X, please follow instructions at: https://docs.docker.com/docker-for-mac/install/

For Ubuntu 16.04, add the GPG key for the official Docker repository to the system:

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

Add the Docker repository to APT sources:

    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

Update the package database with the Docker packages from the newly added repo:
    
    sudo apt-get update

Make sure you are about to install from the Docker repo instead of the default Ubuntu 16.04 repo:

    apt-cache policy docker-ce

Now you can install Docker:

    sudo apt-get install -y docker-ce

Follow instructions in the usual guides to let Docker run without super user privileges:
* https://docs.docker.com/engine/installation/linux/linux-postinstall/

Note: We cannot absolutely provide help on installing and setting up Docker for your favorite distribution!

---

# Instructions to create the ccnSim-0.4 container <a id="#create"></a>

These instructions are ment for the ccnSim contributors; they are not expected to be useful for the ccnSim users, which should instead check the instructions on how to [use](#use) the DockerHub images.

## Build the image from the Dockerfile 


## Debug the process  


## Push the image to the repository

Ultimately, once the image is ready you can push it to DockerHub with:

    docker login

    docker tag ccnsim-0.4-docker nonsns/ccnsim-0.4

    docker pull nonsns/ccnsim-0.4


---

# Instructions to use a ccnSim-0.4 container <a id="#use"></a>

These instructions will guide you through setting up the Docker environment to quickly launch ccnSim-0.4 simulation without (the hassle of patching Omnetpp, downloading the required librairies,  compiling the code, etc.)  using the ccnSim-0.4 image hosted on DockerHub  https://hub.docker.com/r/nonsns/ccnsim-0.4/

Note: The container does not support the graphical interface. But, trust us, you do not need it anyway ;)

##  Fetch ccnSim Docker image


Simply issue this command to load the image in your system:

    docker pull nonsns/ccnsim-0.4


You can check that the image is correctly imported by typing:

    docker images 


##  Setup your environment 

Create the working directory (e.g., ccnsim-0.4 in the example) and the 3 subfolders where the results will be written 

    mkdir ccnsim-0.4 && cd ccnsim-0.4 && mkdir results logs infoSim

Test that the ccnSim container works by running it in “interactive” mode, i.e., giving you access to a bash shell in the ccnsim-0.4 folder from which simulations can be launched. The next command also specifyes three “volumes” (i.e., the just created logs, results and infoSim folders) which will be mounted from the local directory on the host machine (so that you can access simulation results also from the host). 

    docker run -ti -v $(pwd)/infoSim:/usr/ccnSim/ccnSim-0.4/infoSim/ -v $(pwd)/results:/usr/ccnSim/ccnSim-0.4/results/ -v $(pwd)/logs:/usr/ccnSim/ccnSim-0.4/logs/ nonsns/ccnsim-0.4 /bin/bash



## Launch a sample simulation

From the container command line, you can launch a simulation. For the sake of simplicity, we are going to simulate a relatively small-scale scenario (M=1e8 contents, C=1e5 cache, 15-nodes tree topology, etc.): 

    ./runsim_script_ED_TTL.sh tree 8 1 spr lce ttl 1 1e5 1e5 1e8 1e8 20.0 IRM IRM 0 0 cold naive 0.75 1e4

You may wish to check the [ccnSim-0.4 manual](http://perso.telecom-paristech.fr/~drossi/index.php?n=Software.CcnSim?action=downloadman&upname=ccnSim-v0.4-Manual.pdf) or the script above for a complete description of the simulation process and details of the parameters.

If the simulation takes too long, you can detach from the current terminal with Ctrl+p, Ctrl+q. To reattach later, 
run the following command to get the ID of the running container:

    docker ps 
    
Then reattach:

    docker attach containerID

And to definitively quit simply type:  

    exit 

## Automate simulation 

While the above process is useful to start your first simulation, it is significantly more productive to avoid the interactive shell and directly run the script you need with the parameter you want:

    docker run -ti -v $(pwd)/infoSim:/usr/ccnSim/ccnSim-0.4/infoSim/ -v $(pwd)/results:/usr/ccnSim/ccnSim-0.4/results/ -v $(pwd)/logs:/usr/ccnSim/ccnSim-0.4/logs/ nonsns/ccnsim-0.4 bash ./runsim_script_ED_TTL.sh tree 8 1 spr lce ttl 1 1e5 1e5 1e8 1e8 20.0 IRM IRM 0 0 cold naive 0.75 1e4 
    
    
You can find simulation output in the infoSim, results and log folders in your current working directory.
     

## Have fun!

This is all you need to launch a ccnSim-0.4 container.   Now, to really make use of ccnSim-0.4, check its [ccnSim-0.4 manual](http://perso.telecom-paristech.fr/~drossi/index.php?n=Software.CcnSim?action=downloadman&upname=ccnSim-v0.4-Manual.pdf)


