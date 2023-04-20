# cyclecloud-terraform
Simple Terraform deployment for Azure CycleCloud

to launch your cyclecloud host:
	terraform init
	terraform plan
	terraform apply #This takes about 20 mins to complete as scripts must be installed onto the host server

to cleanup:
	#this shouldnt destory any data stored on your clusters
	#it WILL destroy any custom cluster configs you've uploaded so ensure you have a local copy
	terraform destroy
