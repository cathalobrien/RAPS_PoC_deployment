cd "$(dirname "$0")" #ensure we are in the RAPS_PoC_deployment/scripts dir
cd ../cluster-configs

set -ue

user="hpcuser"

#Create and Launch cluster
clusterName="ifs1"
clusterType="slurm_multi_queues"
templateFile="slurm_multi_queues.txt"
params="params.json" #gotten by launching matching vm via web UI and running "cyclecloud export_parameters cluster_name > params.json"

#subnet name depends on RG which has random chars, therefore query TF for rg name then update params.json
rg_name=`cd ../deploy-cyclecloud ; terraform output rg_name | tr -d '"'`
subnet_name=${rg_name}/raps-poc-deployment-network/raps-poc-deployment-subnet
sed -i -e "/SubnetId/c\  \"SubnetId\":\"${subnet_name}\"" $params || (jq --arg subnet_name $subnet_name '.SubnetId = $subnet_name' $params > $params.tmp && mv $params.tmp $params)

cyclecloud import_cluster $clusterName --force -c $clusterType -f $templateFile -p $params
echo "Creating $clusterName based on $clusterType in $templateFile"
cyclecloud start_cluster $clusterName
echo "wait for cluster to start by querying show_cluster once a min"

#should take ~5 mins
while ! cyclecloud show_cluster $clusterName | grep -q Started; do
#if cyclecloud show_cluster hbv3-cluster | grep Started; then echo "cluster has started"; else echo "cluster isnt ready"; fi;
echo "not ready yet..."
sleep 60 #1m doesnt work on mac
done
echo "Cluster has started!"

source ../config.env #load  username
user=$cyclecloud_username
pub_key=../.ssh/cc_key.pub
cycleserver_ip=`cd ../deploy-cyclecloud ; terraform output public_ip_address | tr -d '"'`
echo "Adding public key to user $user so you can connect via commandline"
bash scripts/update_pub_key.sh $user $pub_key $cycleserver_ip

echo "upload priv key onto scheduler so that you can ssh onto compute nodes"
scheduler_ip=`cyclecloud show_nodes -c $clusterName --output="%(PublicIp)s"`
priv_key=${pub_key%.pub} #remove .pub 
scp -o StrictHostKeychecking=no -i $priv_key $priv_key $user@$scheduler_ip:~/.ssh 

echo "configuring git on the scheduler so that raps and repos can be cloned"
bash scripts/configure_git.sh $scheduler_ip

echo "installing and logging into Azure CLI on cluster"
bash scripts/install_az_cli.sh $scheduler_ip

#creation of lustre needs to know rg so send it over here
bash scripts/sendAzureInfo.sh $scheduler_ip

#echo "cloning raps and raps-poc (contains azure-specific build and benchmark scripts for raps and dwarves)"
#bash scripts/initalise_raps.sh $scheduler_ip

echo "Now you can connect with 'cyclecloud connect scheduler -c $clusterName -k RAPS_PoC_deployment/.ssh/cc_key'"
echo "Once you connect to your cluster, you can create an LFS instance mounted at //lustre' using 'bash ~/raps-poc/lustre/create_lustre.sh'"
echo "That will take ~10 mins to deploy. Once complete, you can run the IFS using Slurm batch scripts in '~/raps/bin/SLURM/azure/hbv*'"

