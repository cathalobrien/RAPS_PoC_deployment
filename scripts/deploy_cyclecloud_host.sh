cd "$(dirname "$0")"/../deploy-cyclecloud
terraform init
pub_key=$(<~/.ssh/cc_key.pub)
export TF_VAR_cyclecloud_user_publickey=$pub_key
terraform plan 
terraform apply --auto-approve
