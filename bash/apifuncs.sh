#!/bin/bash
function dump_total_hosts(){
	sidfile=$1
	domip=$3
	dumpfile=$2
	totalhosts=0
	if [ -z "$dumpfile" ]; then
		echo "There is not defile file to be dumped"
		exit 0
	fi
	if [ -f "$sidfile" ]; then
		if [ -n $domip ]; then
			totalhosts=$(mgmt_cli -d $domip show hosts --format json -s $sidfile | jq '.total' | sed -e 's/^"//' -e 's/"$//')
			echo "Creating database file $dumpfile"
			mgmt_cli -d $domip show hosts limit $totalhosts details-level full --format json -s $sidfile > $dumpfile
		else
			totalhosts=$(mgmt_cli show hosts --format json -s $sidfile | jq '.total' | sed -e 's/^"//' -e 's/"$//')
			echo "Creating database file $dumpfile"
                        mgmt_cli show hosts limit $totalhosts details-level full --format json -s $sidfile > $dumpfile
		fi
	else
		echo "impossible to logging there is no checkpoint session filea"
		exit 0
	fi	
}
#dumphosts sid.txt hosts.file 150.100.218.18
