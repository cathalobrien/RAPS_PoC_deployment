echo "usage bash setupArbCluster.sh cluster-name github_key"

cd "$(dirname "$0")"/..
echo "upload priv key onto scheduler so that you can ssh onto compute nodes"
scheduler_ip=`cyclecloud show_nodes -c $1 --output="%(PublicIp)s"`
priv_key=../.ssh/cc_key
scp -o StrictHostKeychecking=no -i $priv_key $priv_key hpc_admin@$scheduler_ip:~/.ssh

echo "configuring git on the scheduler so that raps and repos can be cloned"
bash scripts/configure_git.sh $scheduler_ip $2

echo "installing and logging into Azure CLI on cluster"
bash scripts/install_az_cli.sh $scheduler_ip

#creation of lustre needs to know rg so send it over here
bash scripts/sendAzureInfo.sh $scheduler_ip 

echo "cloning raps and raps-poc (contains azure-specific build and benchmark scripts for raps and dwarves)"
bash scripts/initalise_raps.sh $scheduler_ip
