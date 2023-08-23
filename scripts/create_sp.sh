#script to create an azure service principal with enough perms to work with this repo
#Has A LOT of perms tho so make sure you keep the creds secure

echo "usgae: bash create_sp.sh [sp_name]"
set -u
sp_name=$1

#create the sp
sub_id=`az account show --query id --output tsv`
az ad sp create-for-rbac -n $sp_name --role="Owner" --scopes="/subscriptions/$sub_id"

sp_app_id=`az ad sp list --display-name $sp_name --query "[].appId" -o tsv`
sp_tenant_id=`az ad sp list --display-name $sp_name --query "[].appOwnerOrganizationId" -o tsv`

echo "app_id: $sp_app_id tenant_id: $sp_tenant_id"
echo "Make sure you record the password above becuase there is no way to query this in the future!"

#to delete your sp:
#az ad sp delete --id $sp_app_id
echo 'To delete your SP later you can use: az ad sp delete --id $sp_app_id'
