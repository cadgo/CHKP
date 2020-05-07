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
function dump_total_hosts2(){
        sidfile=$1
        domip=$2
        dumpfiles=()
        filenames="hostfile"
	qs=500
        totalhosts=0
	if [ -n $domip ]; then
		addcli="-d $domip"
	else
		addcli=""
	fi
	if [ -f "$sidfile" ]; then
		totalhosts=$(mgmt_cli show hosts --format json -s $sidfile $addcli | jq '.total' | sed -e 's/^"//' -e 's/"$//')
		iter=0
		if [ $totalhosts -gt $qs ]; then
			let ddi=$totalhosts%$qs
			if [ $ddi -gt 0 ]; then
				let iter=$totalhosts/$qs
				let iter=$iter+1
			else 
				let iter=$totalhosts/$qs
			fi
		else
			iter=1
		fi
		echo "Se tienen un total de $totalhosts hosts dividiendolo en $iter archivos"
		offset=0
		for (( x=0; x<$iter; x++ ))
		do
			nfile=$filenames${x}
        	mgmt_cli show hosts limit $qs offset $offset details-level full --format json -s $sidfile $addcli > $nfile
        	let offset=$offset+$qs
        	echo "offset $offset qs $qs"
		done
	fi
}
