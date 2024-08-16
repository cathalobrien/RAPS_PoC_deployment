#installs libraries lke terraform and azcopy if you don't already have them
set -e

echo "This script will check if terraform and Azure CLI are installed"
echo "If not, it will try install them for you (works on Mac and Rhel linux)"
echo "Then, it will ask you to provide credentials to authorise Cyclecloud to create VMs"
echo "If you don't have these credentials, create them with:"
echo "'az ad sp create-for-rbac --role=\"Owner\" --scopes=\"/subscriptions/SUBSCRIPTION_ID\"'"
echo "If you made a mistake with the login creds, delete $ROOT/config.env and rerun the script to regenerate the config"


if terraform --help > /dev/null && az --help > /dev/null; then 
	echo "prereqs installed" 
else 
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

	elif yum --help > /dev/null ; then #using RHEL/centos/alma
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
fi

cd "$(dirname "$0")"/..
if test ! -f ./config.env ; then
	echo "Generating config.env file..."
	echo "If you make a mistake you can always edit RAPS_PoC_deployment/config.env"

	read -p "Service Principal application id: " cyclecloud_application_id
	read -sp "Service Principal application secret: " cyclecloud_application_secret
	echo "" #newline
	read -p "Service Principal tenant id: " cyclecloud_tenant_id
	read -p "Cyclecloud username: " cyclecloud_username
	read -sp "Cyclecloud password (must have an uppercase char, a number and a special char): " cyclecloud_password
	echo ""

	cat <<EOF > config.env
cyclecloud_tenant_id=$cyclecloud_tenant_id
cyclecloud_application_id=$cyclecloud_application_id
cyclecloud_application_secret=$cyclecloud_application_secret
cyclecloud_password=$cyclecloud_password
cyclecloud_username=$cyclecloud_username
EOF

fi

#login with SP
source config.env
az login --service-principal -u $cyclecloud_application_id -p $cyclecloud_application_secret --tenant $cyclecloud_tenant_id

