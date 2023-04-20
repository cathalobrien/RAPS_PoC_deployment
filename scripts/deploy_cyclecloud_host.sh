cd "$(dirname "$0")"/../deploy-cyclecloud
terraform init
terraform plan
terraform apply --auto-approve
