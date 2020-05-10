#!/bin/bash
. ./apifuncs.sh
logfile=host.log
loggerf()
{
        echo $@ >> $logfile
}
#PONER FUNCION QUE REMUEVA LOS ARCHIVO HOST.DB Y HSTFILE
domip=150.100.218.18
username="admin"
pass="vpn123"
if [ -n $domip ]; then
	mgmt_cli -d $domip login user $username password $pass > sid.txt
	addcli="-d $domip"
else
	mgmt_cli login user $username password $pass > sid.txt
	addcli=""
fi
#nfw="VS_VoIP"
nfw="Cluster_VoIP"
oldfw="VS_VoIP"
netfile="netfiles"
netdb="net_chkp.db"
#dumpnetworks
#totalnetworks=`cat networks.file | jq '.total'`
#cat hostfile10 | jq '.objects[].name' | wc -l
loggerf "dumping networks for looping"
dump_total_nets sid.txt $domip
if [ $? -eq 0 ]; then
	loggerf "There are not networks to dump bye bye"
	exit 0
fi
for yy in `ls $netfile*`; do
	loggerf "creating database $netdb file for file $yy"
	totalnetworks=$(cat $yy | jq '.objects[].name' | wc -l)
	loggerf "File $yy has $totalnetworks networks to be iterated"
	for (( x=0; x<$totalnetworks; x++ ))
	do
         cat $yy | jq ".objects[$x].name" >> $netdb
	done
	for xx in $( cat $netdb )
	do
         bb=`cat $yy | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."install-on"' | sed -e 's/^"//' -e 's/"$//'`
         nattype=`cat $yy | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."method"' | sed -e 's/^"//' -e 's/"$//'`
 	if [[ "$bb" = "$oldfw" ]]; then
             if [[ "$nattype" = "static" ]]; then
             	ipv4=`cat $yy | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."ipv4-address"' | sed -e 's/^"//' -e 's/"$//'`
                auto=`cat $yy | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."auto-rule"' | sed -e 's/^"//' -e 's/"$//'`
                echo "Chaging Fw Nat" $xx " en modo static" >> $logfile
 		loggerf "running mgmt_cli set network name $xx nat-settings.auto-rule $auto nat-settings.ip-address $ipv4 nat-settings.method "static" nat-settings.install-on $nfw $addcli -s sid.txt"
                mgmt_cli -d $domip set network name $xx nat-settings.auto-rule $auto nat-settings.ip-address $ipv4 nat-settings.method "static" nat-settings.install-on $nfw $addcli -s sid.txt
            else
                ipv4=`cat $yy | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."ipv4-address"' | sed -e 's/^"//' -e 's/"$//'`
                auto=`cat $yy | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."auto-rule"' | sed -e 's/^"//' -e 's/"$//'`
                hb=`cat $yy | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."hide-behind"' | sed -e 's/^"//' -e 's/"$//'`
                echo "Changing Fw NAt" $xx " en modo hide" >> $logfile
                if [[ "$hb" = "gateway" ]]; then
                	loggerf "mgmt_cli set network name $xx nat-settings.auto-rule $auto nat-settings.hide-behind "gateway" nat-settings.method "hide" nat-settings.install-on $nfw $addcli -s sid.txt"
                	mgmt_cli set network name $xx nat-settings.auto-rule $auto nat-settings.hide-behind "gateway" nat-settings.method "hide" nat-settings.install-on $nfw $addcli -s sid.txt
                else
                	loggerf "running mgmt_cli set network name $xx nat-settings.auto-rule $auto nat-settings.ip-address $ipv4 nat-settings.method "hide" nat-settings.install-on $nfw $addcli -s sid.txt"
 			mgmt_cli set network name $xx nat-settings.auto-rule $auto nat-settings.ip-address $ipv4 nat-settings.method "hide" nat-settings.install-on $nfw $addcli -s sid.txt
             	fi
             fi
 	fi
	done
	loggerf "removing $netdb"
	rm $netdb
done
echo "Do you want to publish [Y/N]"
read option
if [ "$option" = "Y" ]; then
	loggerf "publishing session"
	mgmt_cli publish $addcli -s sid.txt
	mgmt_cli logout $addcli -s sid.txt
else
	loggerf "Dropping session :("
	mgmt_cli discard $addcli -s sid.txt
	mgmt_cli logout $addcli -s sid.txt
fi
loggerf "Removiendo archivos"
