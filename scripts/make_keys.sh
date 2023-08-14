cd "$(dirname "$0")"/..
mkdir -p .ssh #for some reason having ssh key in ~/.ssh seems to cause problems, so put it in ~/RAPS_PoC_deployment/.ssh instead
rm -rf .ssh/*
ssh-keygen -t rsa -b 4096 -C "cc_key" -f $PWD/.ssh/cc_key -N "" #no password
chmod 600 $PWD/.ssh/cc_key
eval `ssh-agent`
ssh-add $PWD/.ssh/cc_key
