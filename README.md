# RAPS\_PoC\_deployment
Project which creates everything you need to deploy HPC clusters on Azure and to begin testing ECMWF codes.

## 1: Install required programs
First, install the azure cli and terraform if required. Terraform is a program which can deploy cloud instances using code instead of a GUI  and it requires the azure CLI to be able to deploy Azure instances. \
the script "scripts/install\_prereqs.sh" will try install terraform and the azure cli for you. If succseful, you will be prompted to log in.


## 2: Deploy a Cyclecloud host server
Cyclecloud is an azure tool for automating the creation and deployment of HPC clusters. It is a server with a web front-end which you can use to interactively create clusters. \
"deploy-cyclecloud/" contains a terraform project which will deploy a cyclecloud host server. Create your cyclecloud host as outlined in "deploy-cyclecloud/README.md" or by using the script "scripts/deploy\_cyclecloud\_host"


## 3: Configure the Cyclecloud CLI
There is also a CLI for cyclecloud which is used  to upload custom cluster definition files. \ 
The directory "cluster-configs/" contains a template file which defines a cluster for testing ECMWF workloads on the Azure cloud. \
The script "scripts/install\_cyclecloud\_cli.sh" installs and configures the CC cli. It also uploads the afforementioned template \

The script ends by outputing the web address for the Cyclecloud GUI, as well as the username and password required to log in

## 4: Launch a Cluster
Navigate to the URL outputed by "scripts/install\_cyclecloud\_cli.sh" and log in. Click the "+" button in the bottom left corner to create a new cluster. Select the template called "alma\_slurm\_singleQ". Most options are preloaded, simply fill in a name and select a subnet.

## 5: create and launch a cluster via the cyclecloud gui


## TODO
make terraform create an subnet and preload this in the cluster template \
change the terraform prefix so I can track them easier, also add tags for the same reson \
test if this code supports multiple parallel CC deployments, if not then add random numbers to the prefix so that multiple can be created \
add an option to optionally create CC host and instead specify URL of an existing CC \

public key isnt being aded to hpc\_admin account correctly
i guess i have to get the priv key into this repo somehow too

at the moment I have to manually add the public key via web UI in order to connect
then connect with: cyclecloud connect scheduler -c slurm-test -k ~/RAPS\_PoC\_deployment/.ssh/cc\_key
