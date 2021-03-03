
######################## H  O  S   T ##############################
function dump_total_hosts(){
        sidfile=$1
        domip=$2
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
                if [ $totalhosts -eq 0 ]; then
                        echo "There are not hosts in this server"
                        return 0
                fi
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
                echo "Total hosts $totalhosts splitted by $iter files"
                offset=0
                for (( x=0; x<$iter; x++ ))
                do
                        nfile=$filenames${x}
                mgmt_cli show hosts limit $qs offset $offset details-level full --format json -s $sidfile $addcli > $nfile
                let offset=$offset+$qs
                echo "Generating file $nfile to store from " $((x*qs)) " To $offset"
                done
                return 1
        fi
}
######################## N  E  T  W  O  R  K ##############################
function dump_total_nets(){
        sidfile=$1
        domip=$2
        filenames="netfiles"
        qs=500
        totalnets=0
        if [ -n $domip ]; then
                addcli="-d $domip"
        else
                addcli=""
        fi
        if [ -f "$sidfile" ]; then
                totalnets=$(mgmt_cli show networks --format json -s $sidfile $addcli | jq '.total' | sed -e 's/^"//' -e 's/"$//')
                iter=0
                if [ $totalnets -eq 0 ]; then
                        echo "There are not networks in this server"
                        return 0
                fi
                if [ $totalnets -gt $qs ]; then
                        let ddi=$totalnets%$qs
                        if [ $ddi -gt 0 ]; then
                                let iter=$totalnets/$qs
                                let iter=$iter+1
                        else
                                let iter=$totalnets/$qs
                        fi
                else
                        iter=1
                fi
                echo "Total networks $totalnets splitted by $iter files"
                offset=0
                for (( x=0; x<$iter; x++ ))
                do
                        nfile=$filenames${x}
                mgmt_cli show networks limit $qs offset $offset details-level full --format json -s $sidfile $addcli > $nfile
                let offset=$offset+$qs
                echo "Generating file $nfile to store from " $((x*qs)) " To $offset"
                done
                return 1
        fi
}
######################## R  A  N  G  E ##############################

function dump_total_range(){
        sidfile=$1
        domip=$2
        filenames="netrange"
        qs=500
        totalrange=0
        if [ -n $domip ]; then
                addcli="-d $domip"
        else
                addcli=""
        fi
        if [ -f "$sidfile" ]; then
                totalrange=$(mgmt_cli show address-ranges --format json -s $sidfile $addcli | jq '.total' | sed -e 's/^"//' -e 's/"$//')
                iter=0
                if [ $totalrange -eq 0 ]; then
                        echo "There are not address-ranges in this server"
                        return 0
                fi
                if [ $totalrange -gt $qs ]; then
                        let ddi=$totalrange%$qs
                        if [ $ddi -gt 0 ]; then
                                let iter=$totalrange/$qs
                                let iter=$iter+1
                        else
                                let iter=$totalrange/$qs
                        fi
                else
                        iter=1
                fi
                echo "Total address-ranges $totalrange splitted by $iter files"
                offset=0
                for (( x=0; x<$iter; x++ ))
                do
                        nfile=$filenames${x}
                mgmt_cli show address-ranges limit $qs offset $offset details-level full --format json -s $sidfile $addcli > $nfile
                let offset=$offset+$qs
                echo "Generating file $nfile to store from " $((x*qs)) " To $offset"
                done
                return 1
        fi
}