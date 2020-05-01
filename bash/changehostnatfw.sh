#!/bin/bash
. ./apifuncs.sh
logfile=host.log
loggerf()
{
        echo $@ >> $logfile
}

domip=150.100.218.18
username="admin"
pass="vpn123"
if [ -n $domip ]; then
	mgmt_cli -d $domip login user $username password $pass > sid.txt 	
else
	mgmt_cli login user $username password $pass > sid.txt
fi
#nfw="VS_VoIP"
nfw="Cluster_VoIP"
oldfw="VS_VoIP"
hstfile="hosts.file"
hostdb="host_chkp.db"
loggerf "Creating json database for hosts"
#dumphosts
echo "dumphost"
totalhosts=`cat hosts.file | jq '.total'`
loggerf "dumping hosts for looping"


if [ -f $hostdb ]; then
        loggerf "File $hostdb exists creating new one"
        rm $hostdb
else
        loggerf "File didnt exists"
fi
for (( x=0; x<$totalhosts; x++ ))
do
        cat $hstfile | jq ".objects[$x].name" >> $hostdb
done
r=0
for xx in $( cat $hostdb )
do
        bb=`cat $hstfile | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."install-on"' | sed -e 's/^"//' -e 's/"$//'`
        nattype=`cat $hstfile | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."method"' | sed -e 's/^"//' -e 's/"$//'`
	if [[ "$bb" = "$oldfw" ]]; then
                if [[ "$nattype" = "static" ]]; then
                        ipv4=`cat $hstfile | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."ipv4-address"' | sed -e 's/^"//' -e 's/"$//'`
                        auto=`cat $hstfile | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."auto-rule"' | sed -e 's/^"//' -e 's/"$//'`
                        echo "Chaging Fw Nat" $xx " en modo static" >> $logfile
			loggerf "running mgmt_cli -d $domip set host name $xx nat-settings.auto-rule $auto nat-settings.ip-address $ipv4 nat-settings.method "static" nat-settings.install-on $nfw"
                        mgmt_cli -d $domip set host name $xx nat-settings.auto-rule $auto nat-settings.ip-address $ipv4 nat-settings.method "static" nat-settings.install-on $nfw -s sid.txt
                else
                        ipv4=`cat $hstfile | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."ipv4-address"' | sed -e 's/^"//' -e 's/"$//'`
                        auto=`cat $hstfile | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."auto-rule"' | sed -e 's/^"//' -e 's/"$//'`
                        echo "Changing Fw NAt" $xx " en modo hide" >> $logfile
                        loggerf "running mgmt_cli -d $domip set host name $xx nat-settings.auto-rule $auto nat-settings.ip-address $ipv4 nat-settings.method "hide" nat-settings.install-on $nfw"
			mgmt_cli -d $domip set host name $xx nat-settings.auto-rule $auto nat-settings.ip-address $ipv4 nat-settings.method "hide" nat-settings.install-on $nfw -s sid.txt
                fi
	fi
done
if [ -n $domip ]; then
        mgmt_cli -d $domip publish -s sid.txt
	mgmt_cli -d $domip logout -s sid.txt
else
	mgmt_cli publish -s sid.txt
        mgmt_cli logout -s sid.txt
fi
