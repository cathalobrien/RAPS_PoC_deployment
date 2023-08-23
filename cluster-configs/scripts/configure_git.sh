#script which sets up the new vm to use git
#copies ssh key and tells ssh to use the github key for github (shocking)

echo "usage: bash configure_git.sh [cluster scheduler ip] [github priv key]"
set -u
cluster_ip=$1
github_key=$2

cd "$(dirname "$0")"/..

scp -i ../.ssh/cc_key $github_key $cyclecloud_username@$cluster_ip:~/.ssh/github

cat > config <<- EOM
Host github.com
        User git
        Hostname github.com
        IdentityFile /shared/home/$cyclecloud_username/.ssh/github
Host git.ecmwf.int
        User git
        Hostname git.ecmwf.int
        IdentityFile /shared/home/$cyclecloud_username/.ssh/github
EOM
chmod 600 config

source ../config.env #get $cyclecloud_username
#scp -i ../.ssh/cc_key config $cyclecloud_username@$cluster_ip:~/.ssh
#ssh -i ../.ssh/cc_key $cyclecloud_username@$cluster_ip "sudo cat config >> /shared/home/$cyclecloud_username/.ssh/config" #not using scp bc we want to append not overwrite
cat config | ssh -i ../.ssh/cc_key $cyclecloud_username@$cluster_ip "sudo tee -a /shared/home/$cyclecloud_username/.ssh/config" #needs to be sudo bc config is protected
rm config
