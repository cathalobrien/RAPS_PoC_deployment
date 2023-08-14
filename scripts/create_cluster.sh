cd "$(dirname "$0")" #ensure we are in the RAPS_PoC_deployment/scripts dir
cd ../cluster-configs

set -ue

#Create and Launch cluster
clusterName="hbv3-cluster"
clusterType="alma_slurm_singleQ"
templateFile="alma_slurm_singleQ.txt"
params="params.json" #gotten by launching matching vm via web UI and running "cyclecloud export_parameters cluster_name > params.json"

#subnet name depends on RG which has random chars, therefore query TF for rg name then update params.json
rg_name=`cd ../deploy-cyclecloud ; terraform output rg_name | tr -d '"'`
subnet_name=${rg_name}/raps-poc-deployment-network/raps-poc-deployment-subnet
sed -i -e "/SubnetId/c\  \"SubnetId\":\"${subnet_name}\"" $params

cyclecloud import_cluster $clusterName --force -c $clusterType -f $templateFile -p $params
echo "Creating $clusterName based on $clusterType in $templateFile"
cyclecloud start_cluster hbv3-cluster
echo "wait for cluster to start by querying show_cluster once a min"

#should take ~5 mins
while ! cyclecloud show_cluster hbv3-cluster | grep -q Started; do
#if cyclecloud show_cluster hbv3-cluster | grep Started; then echo "cluster has started"; else echo "cluster isnt ready"; fi;
echo "not ready yet..."
sleep 1m
done
echo "Cluster has started!"

user=hpc_admin
pub_key=~/RAPS_PoC_deployment/.ssh/cc_key.pub
cycleserver_ip=`cd ../deploy-cyclecloud ; terraform output public_ip_address | tr -d '"'`
echo "Adding public key to user $user so you can connect via commandline"
bash scripts/update_pub_key.sh $user $pub_key $cycleserver_ip

echo "configuring git on the scheduler so that raps and repos can be cloned"
scheduler_ip=`cyclecloud show_nodes -c hbv3-cluster --output="%(PublicIp)s"`
github_key=~/.ssh/github
bash scripts/configure_git.sh $scheduler_ip $github_key

echo "cloning raps and raps-poc (contains azure-specific build and benchmark scripts for raps and dwarves)"
bash scripts/initalise_raps.sh $scheduler_ip

#creation of lustre needs to know rg so send it over here
bash sendAzureInfo.sh $scheduler_ip

priv_key=${pub_key%.pub} #remove .pub 
echo "Now you can connect with 'cyclecloud connect scheduler -c $clusterName -k $priv_key'"
