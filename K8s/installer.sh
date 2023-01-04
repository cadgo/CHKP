#!/bin/bash
#generar el hostname con el ID
#cambiar el hostname a WORKER ID

KIND="MASTER"
ID=0
MASTERIP=""
USERID=$(id -u)
CRIO_V=1.24
CIDR="10.244.0.0/16"
function print_help(){
   printf "\n\\n
   \t EXPORT VARIABLES\n\
   \t export TOKEN <obtain this info for the master installation>\n\
   \t export CACERT <obtain this info for the master installation>\n\n\

   \t usage: $0 options\n\
   \t\t -k MASTER | WORKER\n\
   \t\t -d Master IP address\n\
   \t\t -h help menu\n\n"
}

function inst_general_deps(){
  apt update -y
  apt install -y apt-transport-https ca-certificates curl
}

function add_net_modules(){
  cat <<EOF | tee etc/modules-load.d/k8s.conf
  overlay
  br_netfilter
EOF

  cat <<EOF | tee /etc/sysctl.d/k8s.conf
  net.bridge.bridge-nf-call-iptables  = 1
  net.bridge.bridge-nf-call-ip6tables = 1
  net.ipv4.ip_forward                 = 1
EOF

  modprobe -a overlay br_netfilter
  sysctl --system
}

function install_crio(){
  ub_v=$(lsb_release -a | grep Release | awk '{print $2}')
  crio_ver=$CRIO_V
  OS=xUbuntu_$ub_v
  echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /" > /etc/apt/sources.list.d/devel-libcontainers.list
  echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$crio_ver/$OS/ /" > /etc/apt/sources.list.d/devel-cri-o-$crio_ver.list 
  curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$crio_ver/$OS/Release.key | apt-key add -
  curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | apt-key add -
  
  apt update -y
  apt-get install -y cri-o cri-o-runc

  systemctl daemon-reload
  systemctl enable crio
  systemctl start crio

  if [ -S "/var/run/crio/crio.sock" ]; then
    echo "CRIO-O install suscessfully"
  else
    echo "There was soemthing wrong installing cri-o, the socket did not exists on the OS"
    exit 1
  fi
}

function disable_apparmor(){
  systemctl disable apparmor
}

function kubeadm_install(){
  curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
  echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
  apt update -y
  apt install -y kubelet kubeadm kubectl
  apt-mark hold kubelet kubeadm kubectl
}

function swap_handler(){
  swapoff -a
  sed -i -e '/swap/d' /etc/fstab
}

function common_steps(){
  inst_general_deps
  add_net_modules
  disable_apparmor
  install_crio
  kubeadm_install
  swap_handler
}

function master_install(){
  common_steps

  kubeadm init --pod-network-cidr=$CIDR --v=5
  #Install Flannel on master
  kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/v0.20.2/Documentation/kube-flannel.yml
}

function worker_install(){
  if [ -z $TOKEN ] || [ -z $CACERT ]; then
    echo "one of the variables CACERT or TOKEN are not exported"
    print_help
  fi
  common_steps
  kubeadm join $MASTERIP:6443 --token $TOKEN --discovery-token-ca-cert-hash $CACERT --v=5
}

if [[ "$USERID" != "0" ]]; then
  echo "This Script needs to be execute as root"
  exit 1
fi


echo "INSTALLER SCRIPT FOR K8S LAB RUN IT WITH OPTIONS MASTER or WORKER"

while getopts "k:d:h" options; do
  case "${options}" in
    h)
      print_help
      exit 0
    ;;
    k)
      if [[ "$OPTARG" == "MASTER" ]] || [[ "$OPTARG" == "WORKER" ]]; then 
        KIND=$OPTARG
        echo "Kind $KIND"
      else
        echo "Option can't be recognized"
        print_help
      fi
    ;;
    #i)
    #  if [[ "$KIND" == "MASTER" ]]; then
    #    echo "Invalid ID number for a MASTER this option is not an option for it"
    #    exit 1
    #  else
    #    ID=$OPTARG  
    #  fi
    #;;
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

if [[ "$KIND" == "MASTER" ]]; then
  master_install
elif [[ "$KIND" == "WORKER" ]]; then
  if [ -n "$MASTERIP" ]; then
    worker_install
  else
    echo "We need to define the variable master ip"
    print_help
  fi
else
  print_help 
fi
echo "TOO MANY CHANGES ON THE SYSTEM PLS REBOOT IT!"
