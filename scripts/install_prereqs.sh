#installs libraries lke terraform and azcopy if you don't already have them
set -e

echo "detecting package manager..."
#detect system package manager
if brew -v; then #using mac
	echo "using brew"

	brew update && brew install azure-cli
	brew install terraform

	brew install jq #needed bc mac uses a non-standard version of sed

	#needed for cyclecloud on mac
	export LDFLAGS="-L/opt/homebrew/opt/openssl@1.1/lib"
	export CPPFLAGS="-I/opt/homebrew/opt/openssl@1.1/include"

elif yum -v; then #using RHEL/centos/alma
	echo "using yum"

	#Install terraform
	sudo yum install -y yum-utils
	sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
	sudo yum -y install terraform
	terraform --version

	#Install Azure CLI
	sudo yum check-update & true
	sudo yum install -y gcc libffi-devel python36-devel openssl-devel
	curl -L https://aka.ms/InstallAzureCli | bash
	
else
	echo "You system isn\'t supported. please try install terraform and the Azure CLI yourself"
	exit 1
fi

az login 

