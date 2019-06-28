#!/bin/bash
TERRA_DOWN="https://releases.hashicorp.com/terraform/0.12.3/terraform_0.12.3_linux_amd64.zip"
create_azure_file(){
	mkdir -p $HOME/.azure/
	touch $HOME/.azure/credentials
	echo "[default]" > $HOME/.azure/credentials
	echo "subscription_id=$1" >> $HOME/.azure/credentials
	echo "client_id=$2" >> $HOME/.azure/credentials
	echo "secret=$3" >> $HOME/.azure/credentials
	echo "tenant=$4" >> $HOME/.azure/credentials
}

terra_download(){
	TERRA_FOLDER="/Terraform/"
	TERRA_FILE="terraform"
	mkdir -p $TERRA_FOLDER
	#cd /Terraform
	wget -qO - $TERRA_DOWN | zcat >> $TERRA_FOLDER$TERRA_FILE 
        chmod +x $TERRA_FOLDER$TERRA_FILE	
}

if [ $# -ne 4 ]
then
	echo "Pls provide azure subscription parameters"
	echo -e "subscription_id\nclient_id\nsecret\ntenant"
fi

create_azure_file $@
terra_download

