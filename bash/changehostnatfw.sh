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
nfw="VS_VoIP"
oldfw="Cluster_VoIP"
hstfile="hostfile"
hostdb="host_chkp.db"
#dumphosts
#totalhosts=`cat hosts.file | jq '.total'`
#cat hostfile10 | jq '.objects[].name' | wc -l
loggerf "dumping hosts for looping"
dump_total_hosts sid.txt $domip
if [ $? -eq 0 ]; then
	loggerf "There are not hosts to dump bye bye"
	exit 0
fi
for yy in `ls $hstfile*`; do
	loggerf "creating database $hostdb file for file $yy"
	totalhosts=$(cat $yy | jq '.objects[].name' | wc -l)
	loggerf "File $yy has $totalhosts hosts to be iterated"
	for (( x=0; x<$totalhosts; x++ ))
	do
         cat $yy | jq ".objects[$x].name" >> $hostdb
	done
	for xx in $( cat $hostdb )
	do
         bb=`cat $yy | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."install-on"' | sed -e 's/^"//' -e 's/"$//'`
         nattype=`cat $yy | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."method"' | sed -e 's/^"//' -e 's/"$//'`
 	if [[ "$bb" = "$oldfw" ]]; then
             if [[ "$nattype" = "static" ]]; then
             	ipv4=`cat $yy | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."ipv4-address"' | sed -e 's/^"//' -e 's/"$//'`
                auto=`cat $yy | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."auto-rule"' | sed -e 's/^"//' -e 's/"$//'`
                echo "Chaging Fw Nat" $xx " en modo static" >> $logfile
 				loggerf "running mgmt_cli set host name $xx nat-settings.auto-rule $auto nat-settings.ip-address $ipv4 nat-settings.method "static" nat-settings.install-on $nfw $addcli -s sid.txt"
                mgmt_cli -d $domip set host name $xx nat-settings.auto-rule $auto nat-settings.ip-address $ipv4 nat-settings.method "static" nat-settings.install-on $nfw $addcli -s sid.txt
            else
                ipv4=`cat $yy | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."ipv4-address"' | sed -e 's/^"//' -e 's/"$//'`
                auto=`cat $yy | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."auto-rule"' | sed -e 's/^"//' -e 's/"$//'`
                hb=`cat $yy | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."hide-behind"' | sed -e 's/^"//' -e 's/"$//'`
                echo "Changing Fw NAt" $xx " en modo hide" >> $logfile
                if [[ "$hb" = "gateway" ]]; then
                	loggerf "mgmt_cli set host name $xx nat-settings.auto-rule $auto nat-settings.hide-behind "gateway" nat-settings.method "hide" nat-settings.install-on $nfw $addcli -s sid.txt"
                	mgmt_cli set host name $xx nat-settings.auto-rule $auto nat-settings.hide-behind "gateway" nat-settings.method "hide" nat-settings.install-on $nfw $addcli -s sid.txt
                else
                	loggerf "running mgmt_cli set host name $xx nat-settings.auto-rule $auto nat-settings.ip-address $ipv4 nat-settings.method "hide" nat-settings.install-on $nfw $addcli -s sid.txt"
 					mgmt_cli set host name $xx nat-settings.auto-rule $auto nat-settings.ip-address $ipv4 nat-settings.method "hide" nat-settings.install-on $nfw $addcli -s sid.txt
             	fi
             fi
 	fi
	done
	loggerf "removing $hostdb"
	rm $hostdb
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
#remover archivos rutina
