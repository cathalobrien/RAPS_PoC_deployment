cd "$(dirname "$0")"/../deploy-cyclecloud
terraform init

source ../config.env #load cyclecloud details
pub_key=$(<../.ssh/cc_key.pub)
sub_id=`az account show --query id --output tsv`

echo "Make sure you add you SP details to RAPS_PoC_deployment/config.env"
terraform plan -var="cyclecloud_tenant_id=$cyclecloud_tenant_id" \
	-var="cyclecloud_application_id=$cyclecloud_application_id" \
	-var="cyclecloud_application_secret=$cyclecloud_application_secret" \
	-var="sub_id=$sub_id" \
	-var="cyclecloud_user_publickey=$pub_key" \
	-var="cyclecloud_password=$cyclecloud_password" \
	-var="cyclecloud_username=$cyclecloud_username"

terraform apply --auto-approve -var="cyclecloud_tenant_id=$cyclecloud_tenant_id" \
        -var="cyclecloud_application_id=$cyclecloud_application_id" \
        -var="cyclecloud_application_secret=$cyclecloud_application_secret" \
	-var="sub_id=$sub_id" \
	-var="cyclecloud_user_publickey=$pub_key" \
	-var="cyclecloud_password=$cyclecloud_password" \
	-var="cyclecloud_username=$cyclecloud_username"
