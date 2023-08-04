cd "$(dirname "$0")"/..
mkdir -p .ssh #for some reason having ssh key in ~/.ssh seems to cause problems, so put it in ~/RAPS_PoC_deployment/.ssh instead
rm -rf .ssh/*
ssh-keygen -t rsa -b 4096 -C "cc_key" -f $PWD/.ssh/cc_key
