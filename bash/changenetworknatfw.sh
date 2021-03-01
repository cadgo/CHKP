#!/bin/bash

####################################################
#                                                  #
# This script is a colaboration between PS and SE  #
#                 By                               #
#   Cadgo          &     RDPS                      #
####################################################
echo 'this script is a colaboratio between PS and SE'
echo 'By cadgo and RDPS'
. ./apifuncs.sh
logfile=host.log
loggerf()
{
        echo $@ >> $logfile
}
#PONER FUNCION QUE REMUEVA LOS ARCHIVO HOST.DB Y HSTFILE

# ------------------ Constant Variables ------------------
FAILED_COMMANDS_FILE=$(eval "basename $0").failed_commands
LAST_OUTPUT_FILE=last_output_file.txt
SUCCESS_COLOR='\033[0;32m'
FAILED_COLOR='\033[0;31m'
YELLOW_COLOR='\033[0m'
NO_COLOR='\033[0m'
LIGHT_CYAN='\e[96m'
# -------------------------------------------------------
# ------------------ Execute Function ------------------
run_command() {
cmd=$@
echo -e "${YELLOW_COLOR}### Executing:${NO_COLOR}"
echo $cmd
eval $cmd > $LAST_OUTPUT_FILE 2>&1	
if [ $? -ne 0 ];
    then
        echo -e "${YELLOW_COLOR}### Result: ${FAILED_COLOR}Failed"
        echo $cmd >> $FAILED_COMMANDS_FILE
        cat $LAST_OUTPUT_FILE >> $FAILED_COMMANDS_FILE
        cat $LAST_OUTPUT_FILE
    else
        echo -e "${YELLOW_COLOR}### Result: ${SUCCESS_COLOR}Success"
fi
echo -e "${NO_COLOR}"
}
domip=150.100.218.254
username="admin"
pass="vpn123"
if [ -n $domip ]; then
	mgmt_cli -d $domip login user $username password $pass > sid.txt
	addcli="-d $domip"
else
	mgmt_cli login user $username password $pass > sid.txt
	addcli=""
fi

nfw="VS_Bmovil"
oldfw="ClusterBmovil"
hstfile="hostfile"
hostdb="host_chkp.db"
#dumphosts
#totalhosts=`cat hosts.file | jq '.total'`
#cat hostfile10 | jq '.objects[].name' | wc -l
loggerf "dumping hosts for looping"
dump_total_hosts sid.txt $domip


#########################################host section############################
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
                run_command "mgmt_cli -d $domip set host name $xx nat-settings.auto-rule $auto nat-settings.ip-address $ipv4 nat-settings.method "static" nat-settings.install-on $nfw $addcli -s sid.txt"
            else
                ipv4=`cat $yy | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."ipv4-address"' | sed -e 's/^"//' -e 's/"$//'`
                auto=`cat $yy | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."auto-rule"' | sed -e 's/^"//' -e 's/"$//'`
                hb=`cat $yy | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."hide-behind"' | sed -e 's/^"//' -e 's/"$//'`
                echo "Changing Fw NAt" $xx " en modo hide" >> $logfile
                if [[ "$hb" = "gateway" ]]; then
                	loggerf "mgmt_cli set host name $xx nat-settings.auto-rule $auto nat-settings.hide-behind "gateway" nat-settings.method "hide" nat-settings.install-on $nfw $addcli -s sid.txt"
                	run_command "mgmt_cli set host name $xx nat-settings.auto-rule $auto nat-settings.hide-behind "gateway" nat-settings.method "hide" nat-settings.install-on $nfw $addcli -s sid.txt"
                else
                	loggerf "running mgmt_cli set host name $xx nat-settings.auto-rule $auto nat-settings.ip-address $ipv4 nat-settings.method "hide" nat-settings.install-on $nfw $addcli -s sid.txt"
 					run_command "mgmt_cli set host name $xx nat-settings.auto-rule $auto nat-settings.ip-address $ipv4 nat-settings.method "hide" nat-settings.install-on $nfw $addcli -s sid.txt"
             	fi
             fi
 	fi
	done
	loggerf "removing $hostdb"
	rm $hostdb
done

	loggerf "publishing session"
	mgmt_cli publish $addcli -s sid.txt
	
rm host*
rm host.log
loggerf "Removiendo archivos"
#remover archivos rutina


###############changing networks



hostdb="host_chkp.db"
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
                run_command "mgmt_cli -d $domip set network name $xx nat-settings.auto-rule $auto nat-settings.ip-address $ipv4 nat-settings.method "static" nat-settings.install-on $nfw $addcli -s sid.txt"
            else
                ipv4=`cat $yy | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."ipv4-address"' | sed -e 's/^"//' -e 's/"$//'`
                auto=`cat $yy | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."auto-rule"' | sed -e 's/^"//' -e 's/"$//'`
                hb=`cat $yy | jq ".objects[] | select(.name==$xx)" | jq '."nat-settings"."hide-behind"' | sed -e 's/^"//' -e 's/"$//'`
                echo "Changing Fw NAt" $xx " en modo hide" >> $logfile
                if [[ "$hb" = "gateway" ]]; then
                	loggerf "mgmt_cli set network name $xx nat-settings.auto-rule $auto nat-settings.hide-behind "gateway" nat-settings.method "hide" nat-settings.install-on $nfw $addcli -s sid.txt"
                	run_command "mgmt_cli set network name $xx nat-settings.auto-rule $auto nat-settings.hide-behind "gateway" nat-settings.method "hide" nat-settings.install-on $nfw $addcli -s sid.txt"
                else
                	loggerf "running mgmt_cli set network name $xx nat-settings.auto-rule $auto nat-settings.ip-address $ipv4 nat-settings.method "hide" nat-settings.install-on $nfw $addcli -s sid.txt"
 			run_command "mgmt_cli set network name $xx nat-settings.auto-rule $auto nat-settings.ip-address $ipv4 nat-settings.method "hide" nat-settings.install-on $nfw $addcli -s sid.txt"
             	fi
             fi
 	fi
	done
	loggerf "removing $netdb"
	rm $netdb
done

	loggerf "publishing session"
	mgmt_cli publish $addcli -s sid.txt
	
rm host.log
rn betfiles*
rm sid.txt

mgmt_cli logout $addcli -s sid.txt