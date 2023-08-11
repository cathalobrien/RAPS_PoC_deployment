cd "$(dirname "$0")"/../deploy-cyclecloud
terraform init
pub_key=$(<../.ssh/cc_key.pub) #this doesnt even do anything unless run in root
#export TF_VAR_cyclecloud_user_publickey=$pub_key
<<<<<<< HEAD

echo("Make sure you add you SP details to deploy-cyclecloud/terraform.tfvars")
terraform plan -var="cyclecloud_user_publickey=$pub_key" \
=======
terraform plan -var="cyclecloud_user_publickey=$pub_key"
>>>>>>> b51643e4a0298a7edf5280caf0835b53da6afbd5
#sudo terraform apply --auto-approve -var="cyclecloud_user_publickey=$pub_key"
terraform apply --auto-approve -var="cyclecloud_user_publickey=$pub_key"
