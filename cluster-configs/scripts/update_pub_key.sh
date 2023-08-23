#script to update a CC users pub key via commandline
#takes a username, a public key file and a cyclecloud host IP
#NOTE currently will overwrite previously existing $output_file, shouldnt matter if this file just triggers an update on creation
 
echo "usage: bash update_pub_key.sh [user to be updated] [ABSOLUTE path to new pub key] [cyclecloud host IP]"
set -u #stop if no CLAs given

cd "$(dirname "$0")"/..

username=$1
pub_key_file=$2
cycleserver=$3
output_file="pubkeyupdate.txt"
output_file_loc="/opt/cycle_server/config/data"

#read file
echo "reading $2"
pub_key=`cat $2`

#generate update file
echo "generating update file to $output_file"
cat > $output_file <<- EOM
AdType = "Credential"
Name = "$username/public"
CredentialType = "PublicKey"
PublicKey = "$pub_key"
EOM

#send update file to cycleserver
echo "sending $output_file to $cycleserver:$output_file_loc"
#scp -i ../.ssh/cc_key $output_file $username@$cycleserver:$output_file_loc #doesnt work need root perms for output_file_loc
cat $output_file | ssh -i ../.ssh/cc_key $username@$cycleserver "sudo tee -a $output_file_loc/$output_file" #hacky workaround

#cleanup
rm $output_file
