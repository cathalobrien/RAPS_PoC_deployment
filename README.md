# RAPS\_PoC\_deployment
Project which creates everything you need to deploy HPC clusters on Azure and to begin testing ECMWF codes.

## 1: Install required programs
First, install the azure cli and terraform. Terraform is a program which can deploy cloud instances using code instead of a GUI  and it requires the azure CLI to be able to deploy Azure instances. \
the script "scripts/install\_prereqs.sh" will try install terraform and the azure cli for you. If succseful, you will be prompted to log in.

There is a script "scripts/make\_keys.sh" which geenerates an ssh keypair and stores them into this repo under ".ssh". These keys are used to connect to your clusters.

## 2: Deploy a Cyclecloud host server
Cyclecloud is an azure tool for automating the creation and deployment of HPC clusters. It is a server with a web front-end which you can use to interactively create clusters. \
"deploy-cyclecloud/" contains a terraform project which will deploy a cyclecloud host server. Create your cyclecloud host as outlined in "deploy-cyclecloud/README.md" or by using the script "scripts/deploy\_cyclecloud\_host"

you need to provide Azure Service Principal details as well as cluster username and password in the config.env before executing the deploy\_cyclecloud\_host.sh script. To get SP credentials, you can use the script "scripts/create\_sp.sh". The password likely needs to have a scpecial character, number and uppercase character.

## 3: Configure the Cyclecloud CLI
There is also a CLI for cyclecloud which is used  to upload custom cluster definition files and interact with your clusters locally.\ 
The directory "cluster-configs/" contains a template file which defines a cluster for testing ECMWF workloads on Azure. 
The script "scripts/install\_cyclecloud\_cli.sh" installs and configures the CC cli. It also uploads the afforementioned template 

The script ends by outputing the web address for the Cyclecloud GUI, as well as the username and password required to log in.

## 4: Launch a Cluster
Navigate to the URL outputed by "scripts/install\_cyclecloud\_cli.sh" and log in. Click the "+" button in the bottom left corner to create a new cluster. Select the template called "alma\_slurm\_singleQ". Most options are preloaded, simply fill in a name and select a subnet.

Alternatively, there's now a script "scripts/create\_cluster.sh" which will create and launch a cluster based on the ECMWF-specific VMI containing hbv3 instances via the command line. The scheduler node will take around 5 mins to launch. The script will then configure the scheduler, by adding a public key so you can connect, uploading a private key which can be used to clone git repos and then cloning raps and some other repos. Make sure you provide an absolute path to a github key in the config.env script before running thus script.
Then you can connect using "cyclecloud connect scheduler -c hbv3-cluster -k ~/RAPS\_PoC\_deployment/.ssh/cc\_key".

The script will wait until the cluster is finished creating. At that point it will upload your git key, clone some repos containing ECMWF-specific codes and slurm scripts. Once all this is done the script will output the cyclecloud command needed to connect to your new cluster.

## 5: pre-reqs before running IFS
Once you log onto the scheduler node of your new cluster, you should see some existing directories in your home directory. "raps-poc" contains scripts to build the IFS and IFS dwarves, as well as scripts to setup Lustre and link lustre to your new cluster. "raps", "dwarves" and "ifs-bundle-CY48R1" contain source code for their respective projects. 

To start running IFS, first you need to setup Lustre so you can access the IFS input data. Go to "~/raps-poc/lustre" and run the scripts "install\_prereqs.sh" (just installs azure cli) and then "create\_lustre.sh". This script deploys Lustre in Azure, configures firewalls so that it can talk to the blob storage containing the input data, preloads the data into lustre, mounts the LFS onto the scheduler and finally fixes the broken symlinks etc in the LFS.

Next, go to "~/raps" and source initbm

Finally you can navigate to "~/raps/bin/SLURM/azure/hbv3" and you will see some example slurm scripts. Currently only "io_ens_tco319.hb3.slurm" is known to work. 

# TODO
move az cli install on cluster from lustre initalisation to image build process
