#Script which tries to do everything automatically
#currently untested
#alternatively, follow the instructions in README.md
set -ex

cd "$(dirname "$0")/scripts" #ensure we are in the RAPS_PoC_deployment/scripts dir

bash make_keys.sh #generate ssh keys to connect to CC

bash install_prereqs.sh #install azure cli and terraform

bash deploy_cyclecloud_host.sh #create a server which runs cyclecloud, takes about 20 mins

bash install_cyclecloud_cli.sh #downloads the CC clie, connects it to the server and uploads a cluster template with IFS preloaded

bash create_cluster.sh #create a cluster called hbv3-cluster
