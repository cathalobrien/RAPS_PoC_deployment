cd "$(dirname "$0")"/..

echo "usage: bash sendAzureInfo.sh [scheduler IP]"
set -ue

rg_name=`cd ../deploy-cyclecloud ; terraform output rg_name | tr -d '"'`
cluster_ip=$1

file=.azInfo.env
cat > $file <<- EOM
rg_name=$rg_name
EOM

scp -i ../.ssh/cc_key $file hpc_admin@$cluster_ip:~
rm $file
