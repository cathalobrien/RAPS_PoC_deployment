cd "$(dirname "$0")" #ensure we are in the RAPS_PoC_deployment/scripts dir
cd ../cluster-configs

clusterName="hbv3-cluster"
clusterType="alma_slurm_singleQ"
templateFile="alma_slurm_singleQ.txt"
params="params.json" #gotten by launching matching vm via web UI and running "cyclecloud export_parameters cluster_name > params.json"
cyclecloud import_cluster $clusterName --force -c $clusterType -f $templateFile -p $params
cyclecloud start_cluster hbv3-cluster
echo "will take ~10 mins to start"
echo "then, you can connect with 'cyclecloud connect scheduler -c raps'"
