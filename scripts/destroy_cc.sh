cd "$(dirname "$0")"/../deploy-cyclecloud
pub_key=$(<~/RAPS_PoC_deployment/.ssh/cc_key.pub)
export TF_VAR_cyclecloud_user_publickey=$pub_key
terraform destroy
