#script which sets up the new vm to use git
#copies ssh key and tells ssh to use the github key for github (shocking)

echo "usage: bash configure_git.sh [cluster scheduler ip] [github priv key]"
set -u
cluster_ip=$1
github_key=$2

cd "$(dirname "$0")"/..

scp -i ../.ssh/cc_key $github_key hpc_admin@$cluster_ip:~/.ssh

cat > config <<- EOM
Host github.com
        User git
        Hostname github.com
        IdentityFile /shared/home/hpc_admin/.ssh/github
Host git.ecmwf.int
        User git
        Hostname git.ecmwf.int
        IdentityFile /shared/home/hpc_admin/.ssh/github
EOM
chmod 600 config

#scp -i ../.ssh/cc_key config hpc_admin@$cluster_ip:~/.ssh
#ssh -i ../.ssh/cc_key hpc_admin@$cluster_ip "sudo cat config >> /shared/home/hpc_admin/.ssh/config" #not using scp bc we want to append not overwrite
cat config | ssh -i ../.ssh/cc_key hpc_admin@$cluster_ip "sudo tee -a /shared/home/hpc_admin/.ssh/config" #needs to be sudo bc config is protected
rm config
