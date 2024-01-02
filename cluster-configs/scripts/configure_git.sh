#script which sets up the new vm to use git
#copies ssh key and tells ssh to use the github key for github (shocking)

echo "usage: bash configure_git.sh [cluster scheduler ip] ?githubKey?"
set -xe
cluster_ip=$1

cd "$(dirname "$0")"/..

source ../config.env #get $cyclecloud_username
if [ ! -z "$2" ]; then
	file_loc=/shared/home/$cyclecloud_username/.ssh/github_priv_key
	scp -i ../.ssh/cc_key -o StrictHostKeyChecking=no $2 $cyclecloud_username@$cluster_ip:$file_loc
else
	file_loc=/usr/local/share/github_priv_key
fi


#not sure if its good to be hardcoded in image
cat > config <<- EOM
Host *
    StrictHostKeyChecking no
Host github.com
        User git
        Hostname github.com
        IdentityFile $file_loc
Host git.ecmwf.int
        User git
        Hostname git.ecmwf.int
        IdentityFile $file_loc
EOM
chmod 600 config

#scp -i ../.ssh/cc_key config $cyclecloud_username@$cluster_ip:~/.ssh
#ssh -i ../.ssh/cc_key $cyclecloud_username@$cluster_ip "sudo cat config >> /shared/home/$cyclecloud_username/.ssh/config" #not using scp bc we want to append not overwrite
cat config | ssh -o StrictHostKeyChecking=no -i ../.ssh/cc_key $cyclecloud_username@$cluster_ip "sudo tee /shared/home/$cyclecloud_username/.ssh/config" #needs to be sudo bc config is protected
rm config
