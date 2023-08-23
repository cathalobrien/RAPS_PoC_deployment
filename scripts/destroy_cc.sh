cd "$(dirname "$0")"/../deploy-cyclecloud

source ../config.env #load cyclecloud details
pub_key=$(<../.ssh/cc_key.pub)

terraform destroy -var="cyclecloud_tenant_id=$cyclecloud_tenant_id" \
        -var="cyclecloud_application_id=$cyclecloud_application_id" \
        -var="cyclecloud_application_secret=$cyclecloud_application_secret" \
	-var="cyclecloud_user_publickey=$pub_key"
