#This script should be run AFTER you have created your cyclelcoud host using terraform apply
set -e

#get the IP of the cyclecloud host server
cd "$(dirname "$0")" #ensure we are in the RAPS_PoC_deployment/scripts dir
cd ../deploy-cyclecloud
cycle_dir=$PWD
export ip=$(terraform output public_ip_address | tr -d '"')

#needed on mac
#export LDFLAGS="-L/opt/homebrew/opt/openssl@1.1/lib"
#export CPPFLAGS="-I/opt/homebrew/opt/openssl@1.1/include"
#pyenv version 2.7.18

#instal the cyclecloud cli
cd /tmp
wget --no-check-certificate https://$ip/static/tools/cyclecloud-cli.zip
unzip -o cyclecloud-cli.zip
cd /tmp/cyclecloud-cli-installer
./install.sh -y
cd /tmp
rm -rf cyclecloud-cli*

#initalize cyclecloud cli
cd $cycle_dir
export url=https://$ip
source ../config.env #get cyclecloud_username and cyclecloud_password
cyclecloud initialize --force --batch --url=$url --username=$cyclecloud_username --password=$cyclecloud_password --verify-ssl=false

#Import a custom cluster template
cyclecloud import_template --force -f ../cluster-configs/alma_slurm_singleQ.txt

#Import a public key for the default hpc_admin user, so that you can connect to your created clusters
bash ../cluster-configs/scripts/update_pub_key.sh $cyclecloud_username ../.ssh/cc_key.pub $ip

echo "open '$url' in your browser to launch a HPC cluster!"
echo "The first time you may be warned about untrusted certs, just click past it"
echo "username: $cyclecloud_username, password: $cyclecloud_password"
