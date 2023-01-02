#!/bin/bash
#generar el hostname con el ID
#cambiar el hostname a WORKER ID

KIND=""
ID=0
MASTERIP=""
function print_help(){
   printf "\n\
   \t usage: $0 options\n\
   \t\t -k MASTER | WORKER\n\
   \t\t -i worker ID Number 1 2 3, etc\n\
   \t\t -d Master IP address\n\
   \t\t -h help menu"
}

echo "INSTALLER SCRIPT FOR K8S LAB RUN IT WITH OPTIONS MASTER WORKER"

while getopts "k:i:d:h" options; do
  case "${options}" in
    h)
      print_help
    ;;
    k)
      KIND=$OPTARG
    ;;
    i)
      if [[ "$KIND" == "MASTER" ]]; then
        echo "Invalid ID number for a MASTER this option is not an option for it"
        exit 1
      else
        ID=$OPTARG  
      fi
    ;;
    d)
      if [[ "$KIND" == "MASTER" ]]; then
        echo "This option is just for WORKER node"
        exit 1
      else
        MASTERIP=$OPTARG
      fi
    ;;
  esac
done
echo "Kind $KIND"
echo "ID $ID"
