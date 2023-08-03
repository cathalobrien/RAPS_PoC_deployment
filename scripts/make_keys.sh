cd "$(dirname "$0")"/..
mkdir -p .ssh
rm -rf .ssh/*
ssh-keygen -t rsa -b 4096 -C "cc_key" -f $PWD/.ssh/cc_key
