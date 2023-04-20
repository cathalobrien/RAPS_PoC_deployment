##prerequisites
Run:
	 bash RAPS_PoC_deployment/scripts/install_cyclecloud_cli.sh

##Uploading a new template
Import a cyclecloud template using:
	cyclecloud import_template -f template_file.txt

##Deleting a template
Delete a template file using:
	cyclecloud delete_template template_name

Note that "template name" isnt necessarily the same as the "template\_file" mentioned above."template name" is set inside the template file, near the top of the file there will be a line:
	[cluster tempate_name]

##Updating a template
To update a template you have to delete and reupload it. Any existing clusters created from that template won't be updated, only new clusters created after the template is updated
