cd "$(dirname "$0")"/../deploy-cyclecloud
terraform init
pub_key=$(<../.ssh/cc_key.pub)
#export TF_VAR_cyclecloud_user_publickey=$pub_key
terraform plan -var="cyclecloud_user_publickey=$pub_key"
#sudo terraform apply --auto-approve -var="cyclecloud_user_publickey=$pub_key"
terraform apply --auto-approve -var="cyclecloud_user_publickey=$pub_key"
