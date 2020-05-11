#!/bin/bash
#script to replace existing Log servers on all gateways and clusters in a specific domain
# c 2018 Check Point Software Luc CORMORAND
pkill -f ./changelogserverR80X_v4.sh

# VER   DATE            WHO                     WHAT
#-----------------------------------------------------
# v1    2018            Luc CORMORAND   Creation of script
# v2    2018            Luc CORMORAND   Adding several cheks
# v3    2018            Luc CORMORAND   Adding log server validation check
# v4    2018            Luc CORMORAND   Adding script error logs tracking
# v5    2018            Luc CORMORAND   Optimizing performance
# v6    2018            Luc CORMORAND   Adding VS support
# v7    2018            Luc CORMORAND   Adding VSX support
# v8    2018            Luc CORMORAND   Adding secondary backup server

LOG_DIR="$HOME/changelog_logs"
mkdir -p $LOG_DIR

SHELL_NAME=`basename "$0"`
LOG_FILE="$LOG_DIR/$SHELL_NAME.err"
touch $LOG_FILE

echo
echo "Be advised that everything is written to $LOG_FILE."
echo "this script will change log servers settings on gateway/cluster/VSX and VS only"
echo

exec 2>$LOG_FILE

set -x

# export all Check Point environment variables
. /opt/CPshared/5.0/tmp/.CPprofile.sh

CMA=$1
ARGS=1

rm /home/admin/gwname.txt >/dev/null 2>&1
rm /home/admin/clusteruid.txt >/dev/null 2>&1
rm /home/admin/vsuid.txt >/dev/null 2>&1
rm /home/admin/vsxuid.txt >/dev/null 2>&1
rm /home/admin/clustervsxuid.txt >/dev/null 2>&1

if [ $# -lt "$ARGS" ]
then
        echo "Usage:"
        echo  "changelogserver <CMA Object name>"
        echo
        exit 0
fi

# create session
mdsenv $CMA
mgmt_cli login -d $CMA -r true > /home/admin/id.txt

echo "Please provide primary Log server object name"
read logserver1
echo

# Check if primary log server exists as an object in the DB
if [ "` mdsquerydb NetworkObjects |grep $logserver1`" = "" ]; then
        echo "Log server is not in Domain database"
                echo
        exit 1
fi

# check if primary log server is indeed a log server
LGS1=$(mgmt_cli -s /home/admin/id.txt -f json -d $CMA show-generic-objects name $logserver1 details-level "full" | grep -w ""logServer"" | awk -F\: '{print $2}' | sed 's/,//' | sed 's/\ //')
if [ "$LGS1" != "true" ]
then
        echo "Specified Log Server is not a valid LogServer/CLM"
        exit 1
fi

echo "Please provide backup Log server object name"
read logserver2
echo

# Check if backup log server exists as an object in the DB
if [ "` mdsquerydb NetworkObjects |grep $logserver2`" = "" ]; then
        echo "Log server is not in Domain database"
                echo
        exit 1
fi

# check if backup log server is indeed a log server
LGS2=$(mgmt_cli -s /home/admin/id.txt -f json -d $CMA show-generic-objects name $logserver2 details-level "full" | grep -w ""logServer"" | awk -F\: '{print $2}' | sed 's/,//' | sed 's/\ //')
if [ "$LGS2" != "true" ]
then
        echo "Specified Log Server is not a valid LogServer/CLM"
        exit 1
fi
# Check if primary log server and backup log server are different

if [ "$logserver1" == "$logserver2" ] ; then
                echo "Log servers must be different"
                echo
        exit 1
fi

mdsenv $CMA

################################################################################################################################################
#Getting Log Servers uid
logserver1uid=$(mgmt_cli -s /home/admin/id.txt -f json -d $CMA show-generic-objects name $logserver1 | jq '.objects[].uid')
logserver2uid=$(mgmt_cli -s /home/admin/id.txt -f json -d $CMA show-generic-objects name $logserver2 | jq '.objects[].uid')

# Changing Log Server for all gateways managed by the CMA
echo " Changing Log Server for all gateways managed by $CMA"
echo

mgmt_cli -s /home/admin/id.txt -d $CMA show gateways-and-servers limit 500 offset 0 -f json details-level "full" | jq '.objects[] | select (.type | contains("simple-gateway")) | .name' >> /home/admin/gwname.txt
for name in $(cat /home/admin/gwname.txt) ; do
mgmt_cli -s /home/admin/id.txt -d $CMA set simple-gateway name $name send-logs-to-server $logserver1uid send-alerts-to-server $logserver1uid
mgmt_cli -s /home/admin/id.txt -d $CMA set simple-gateway name $name send-logs-to-backup-server $logserver2uid
echo "$name gateway has been modified"
done

# Changing Log Server for all clusters managed by the CMA
echo " Changing Log Server for all clusters managed by $CMA"
echo

mgmt_cli -s /home/admin/id.txt -d $CMA show gateways-and-servers limit 500 offset 0 -f json details-level "full" | jq '.objects[] | select (.type | contains("CpmiGatewayCluster")) | .uid' >> /home/admin/clusteruid.txt

for clusteruid in $(cat /home/admin/clusteruid.txt) ; do
mgmt_cli -s /home/admin/id.txt -d $CMA set-generic-object uid $clusteruid logServers.sendLogsTo.1 $logserver1uid logServers.sendAlertsTo.1 $logserver1uid
mgmt_cli -s /home/admin/id.txt -d $CMA set-generic-object uid $clusteruid logServers.backupLogServers.1 $logserver2uid
echo "$clusteruid cluster has been modified"
done

# Changing Log Server for VSX gateways
echo " Changing Log Server for all VSX managed by $CMA"
echo

mgmt_cli -s /home/admin/id.txt -d $CMA show gateways-and-servers limit 500 offset 0 -f json details-level "full" | jq '.objects[] | select (.type | contains("CpmiVsxNetobj")) | .uid' >> /home/admin/vsxuid.txt

for vsxuid in $(cat /home/admin/vsxuid.txt) ; do
mgmt_cli -s /home/admin/id.txt -d $CMA set-generic-object uid $vsxuid logServers.sendLogsTo.1 $logserver1uid logServers.sendAlertsTo.1 $logserver1uid
mgmt_cli -s /home/admin/id.txt -d $CMA set-generic-object uid $vsxuid logServers.backupLogServers.1 $logserver2uid
echo "$vsxuid has been modified"
done

# Changing Log Server for VSX cluster
echo " Changing Log Server for all VSX cluster managed by $CMA"
echo

mgmt_cli -s /home/admin/id.txt -d $CMA show gateways-and-servers limit 500 offset 0 -f json details-level "full" | jq '.objects[] | select (.type | contains("CpmiVsxClusterNetobj")) | .uid' >> /home/admin/vsxclusteruid.txt

for vsxclusteruid in $(cat /home/admin/vsxclusteruid.txt) ; do
mgmt_cli -s /home/admin/id.txt -d $CMA set-generic-object uid $vsxclusteruid logServers.sendLogsTo.1 $logserver1uid logServers.sendAlertsTo.1 $logserver1uid
mgmt_cli -s /home/admin/id.txt -d $CMA set-generic-object uid $vsxclusteruid logServers.backupLogServers.1 $logserver2uid
echo "$vsxuid has been modified"
done

# Changing Log Server for all VS managed by the CMA
echo " Changing Log Server for all VSs managed by $CMA"
echo

mgmt_cli -s /home/admin/id.txt -d $CMA show gateways-and-servers limit 500 offset 0 -f json details-level "full" | jq '.objects[] | select (.type | contains("CpmiVsNetobj")) | .uid' >> /home/admin/vsuid.txt

for vsuid in $(cat /home/admin/vsuid.txt) ; do
mgmt_cli -s /home/admin/id.txt -d $CMA set-generic-object uid $vsuid logServers.sendLogsTo.1 $logserver1uid logServers.sendAlertsTo.1 $logserver1uid
mgmt_cli -s /home/admin/id.txt -d $CMA set-generic-object uid $vsuid logServers.backupLogServers.1 $logserver2uid
echo "$vsuid has been modified"
done

################################################################################################################################
# Adding a second backup server
echo "Do you want to add a second backup server ?"
read decision
if [[ $decision == "N" || $decision == "n" ]]; then

mgmt_cli publish -s /home/admin/id.txt
mgmt_cli logout -s /home/admin/id.txt
echo "Execution time $SECONDS seconds"

else
echo "Please provide second backup Log server object name"
read logserver3

# Check if backup log server exists as an object in the DB
if [ "` mdsquerydb NetworkObjects |grep $logserver3`" = "" ]; then
        echo "Log server is not in Domain database"
        echo "All changes will be discard. Please run again the script"
        mgmt_cli -s /home/admin/id.txt discard
		mgmt_cli logout -s /home/admin/id.txt
		exit 1
fi

# check if backup log server is indeed a log server
LGS3=$(mgmt_cli -s /home/admin/id.txt -f json -d $CMA show-generic-objects name $logserver3 details-level "full" | grep -w ""logServer"" | awk -F\: '{print $2}' | sed 's/,//' | sed 's/\ //')
if [ "$LGS3" != "true" ]
then
        echo "Specified Log Server is not a valid LogServer/CLM"
        echo "All changes will be discard. Please run again the script"
        mgmt_cli -s /home/admin/id.txt discard
		mgmt_cli logout -s /home/admin/id.txt
		exit 1
fi

# Check if primary backup log server and secondary log server are different

if [ "$logserver2" == "$logserver3" ] || [ "$logserver1" == "$logserver3" ]; then
        echo "Log servers must be different"
        echo "All changes will be discard. Please run again the script"
        mgmt_cli -s /home/admin/id.txt discard
		mgmt_cli logout -s /home/admin/id.txt
		exit 1
fi

####################
#Getting second Log Servers uid
logserver3uid=$(mgmt_cli -s /home/admin/id.txt -f json -d $CMA show-generic-objects name $logserver3 | jq '.objects[].uid')

####################
# Adding second backup server
for name in $(cat /home/admin/gwname.txt) ; do
mgmt_cli -s /home/admin/id.txt -d $CMA set simple-gateway name $name send-logs-to-backup-server.add $logserver3uid
echo "$name gateway has been modified"
done
for clusteruid in $(cat /home/admin/clusteruid.txt) ; do
mgmt_cli -s /home/admin/id.txt -d $CMA set-generic-object uid $clusteruid logServers.backupLogServers.add $logserver3uid
echo "$clusteruid cluster has been modified"
done
for vsuid in $(cat /home/admin/vsuid.txt) ; do
mgmt_cli -s /home/admin/id.txt -d $CMA set-generic-object uid $vsuid logServers.backupLogServers.add $logserver3uid
echo "$vsuid has been modified"
done
for vsxuid in $(cat /home/admin/vsxuid.txt) ; do
mgmt_cli -s /home/admin/id.txt -d $CMA set-generic-object uid $vsxuid logServers.backupLogServers.add $logserver3uid
echo "$vsxuid has been modified"
done
for vsxclusteruid in $(cat /home/admin/vsxclusteruid.txt) ; do
mgmt_cli -s /home/admin/id.txt -d $CMA set-generic-object uid $vsxclusteruid logServers.backupLogServers.add $logserver3uid
echo "$vsxclusteruid has been modified"
done

###################
# Publishing
mgmt_cli publish -s /home/admin/id.txt
mgmt_cli logout -s /home/admin/id.txt
echo "Execution time $SECONDS seconds"

fi
