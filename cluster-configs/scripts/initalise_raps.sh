#first time setup on a new VM, clones raps and raps-poc (cloud specific bm and build scripts) on a given scheduler node
echo "usage: bash initalise_raps.sh [cluster scheduler ip]"
set -uex
cluster_ip=$1
user=hpc_admin
ssh_key=~/RAPS_PoC_deployment/.ssh/cc_key

ssh -i $ssh_key $user@$cluster_ip "git clone git@github.com:cathalobrien/raps-poc.git"
ssh -i $ssh_key $user@$cluster_ip "cd raps-poc/scripts; bash init.sh"
