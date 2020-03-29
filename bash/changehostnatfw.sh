#!/bin/bash
logfile=host.log
loggerf()
{
        echo $@ >> $logfile
}
nfw="VS_VoIP"
hstfile="hosts.file"
hostdb="host_chkp.db"
totalhosts=`cat hosts.file | jq '.total'`
loggerf "dumping hosts for looping"

if [ -f $hostdb ]; then
        loggerf "File $hostdb exists creating new one"
        rm $hostdb
else
        loggerf "File didnt exists"
fi
echo $totalhosts
for (( x=0; x<$totalhosts; x++ ))
do
        cat $hstfile | jq ".objects[$x].name" >> $hostdb
done
r=0
for xx in $( cat $hostdb )
do
        bb=`cat $hstfile | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."install-on"' | sed -e 's/^"//' -e 's/"$//'`
        nattype=`cat $hstfile | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."method"' | sed -e 's/^"//' -e 's/"$//'`
        if [[ "$bb" = "Cluster_VoIP" ]]; then
                if [[ "$nattype" = "static" ]]; then
                        ipv4=`cat $hstfile | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."ipv4-address"' | sed -e 's/^"//' -e 's/"$//'`
                        auto=`cat $hstfile | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."auto-rule"' | sed -e 's/^"//' -e 's/"$//'`
                        echo "Chaging Fw Nat" $xx " en modo static" >> $logfile
                        mgmt_cli -r true -d 150.100.218.18 set host name $xx nat-settings.auto-rule $auto nat-settings.ip-address $ipv4 nat-settings.method "static" nat-settings.install-on $nfw
                else
                        ipv4=`cat $hstfile | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."ipv4-address"' | sed -e 's/^"//' -e 's/"$//'`
                        auto=`cat $hstfile | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."auto-rule"' | sed -e 's/^"//' -e 's/"$//'`
                        echo "Changing Fw NAt" $xx " en modo hide" >> $logfile
                        mgmt_cli -r true -d 150.100.218.18 set host name $xx nat-settings.auto-rule $auto nat-settings.ip-address $ipv4 nat-settings.method "hide" nat-settings.install-on $nfw
                fi
        fi
done
