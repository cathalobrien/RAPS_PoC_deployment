#script which installs az cli onto a given cluster node and then logins using the preprovided SP details
#The install step being ehre should just be temporary until  add it into the image

cd "$(dirname "$0")"/../..

echo "usage: bash install_az_cli.sh [scheduler IP]"
set -ue

cluster_ip=$1
source config.env #get cc username and SP creds
user=$cyclecloud_username
ssh_key=.ssh/cc_key

#install azure cli
ssh -o StrictHostKeychecking=no -i $ssh_key $user@$cluster_ip "sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc"
ssh -o StrictHostKeychecking=no -i $ssh_key $user@$cluster_ip "sudo dnf install -y https://packages.microsoft.com/config/rhel/8/packages-microsoft-prod.rpm"
ssh -o StrictHostKeychecking=no -i $ssh_key $user@$cluster_ip "sudo dnf install -y azure-cli"

#login 
ssh -o StrictHostKeychecking=no -i $ssh_key $user@$cluster_ip "az login --service-principal -u $cyclecloud_application_id -p $cyclecloud_application_secret --tenant $cyclecloud_tenant_id"
