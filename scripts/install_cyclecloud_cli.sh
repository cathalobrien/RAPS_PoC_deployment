#This script should be run AFTER you have created your cyclelcoud host using terraform apply

#get the IP of the cyclecloud host server
cd "$(dirname "$0")" #ensure we are in the RAPS_PoC_deployment/scripts dir
cd ../deploy-cyclecloud
cycle_dir=$PWD
export ip=$(terraform output public_ip_address | tr -d '"')

#instal the cyclecloud cli
cd /tmp
wget --no-check-certificate https://$ip/static/tools/cyclecloud-cli.zip
unzip -o cyclecloud-cli.zip
cd /tmp/cyclecloud-cli-installer
./install.sh -y
cd /tmp
rm -rf cycleIcloud-cli*

#initalize cyclecloud cli
cd $cycle_dir
export url=https://$ip
export username=$(cat terraform.tfvars | grep "cyclecloud_username" | awk '{print $3}' | tr -d '"')
export password=$(cat terraform.tfvars | grep "cyclecloud_password" | awk '{print $3}' | tr -d '"')
cyclecloud initialize --force --batch --url=$url --username=$username --password=$password --verify-ssl=false

#Import a custom cluster template
cyclecloud import_template --force -f ../cluster-configs/alma_slurm_singleQ.txt

#Import a public key for the default hpc_admin user, so that you can connect to your created clusters
bash ../cluster-configs/scripts/update_pub_key.sh hpc_admin ../.ssh/cc_key.pub $ip

echo "open '$url' in your browser to launch a HPC cluster!"
echo "The first time you may be warned about untrusted certs, just click past it"
echo "username: $username, password: $password"
