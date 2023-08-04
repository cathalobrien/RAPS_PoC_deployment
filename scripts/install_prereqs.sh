#installs libraries lke terraform and azcopy if you don't already have them
set -x
set -e

#Install terraform
#assumes your running rhel linux (yum) but you can swap them out
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform
terraform --version

#Install Azure CLI
sudo yum check-update & true
sudo yum install -y gcc libffi-devel python36-devel openssl-devel
curl -L https://aka.ms/InstallAzureCli | bash

echo "now type 'az login' to complete setup"
#uncomment these lines to run as root, not needed currently tho
#cp ~/bin/az /usr/bin #so root can find it
#sudo az login 
az login 

