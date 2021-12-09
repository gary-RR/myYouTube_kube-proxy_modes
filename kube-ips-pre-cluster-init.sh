#!/bin/bash

##################### Run this on all Linux nodes #######################

#Update the server
sudo apt-get update -y
sudo apt-get upgrade -y

#Install ipvsadm
sudo apt-get install -y ipvsadm

#Install containerd
sudo apt-get install containerd -y

#Configure containerd and start the service
sudo mkdir -p /etc/containerd
sudo su -
    containerd config default  /etc/containerd/config.toml
exit

#Next, install Kubernetes. First you need to add the repository's GPG key with the command:
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add

#Add the Kubernetes repository
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

#Install all of the necessary Kubernetes components with the command:
sudo apt-get install kubeadm kubelet kubectl -y

#Modify "sysctl.conf" to allow Linux Node’s iptables to correctly see bridged traffic
sudo nano /etc/sysctl.conf
    #Add this line: net.bridge.bridge-nf-call-iptables = 1

sudo -s
#Allow packets arriving at the node's network interface to be forwaded to pods. 
sudo echo '1' > /proc/sys/net/ipv4/ip_forward
exit

#Reload the configurations with the command:
sudo sysctl --system

#Load overlay and netfilter modules 
sudo modprobe overlay
sudo modprobe br_netfilter
  
#Disable swap by opening the fstab file for editing 
sudo nano /etc/fstab
    #Comment out "/swap.img"

#Disable swap from comand line also 
sudo swapoff -a

#Pull the necessary containers with the command:
sudo kubeadm config images pull

####### This section must be run only on the Master node#############

kubeadm config print init-defaults > kubeadm.yaml
nano kubeadm.yaml

sudo kubeadm init  --config kubeadm.yaml 

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#Download Calico CNI
curl https://docs.projectcalico.org/manifests/calico.yaml > calico.yaml
#Apply Calico CNI
kubectl apply -f ./calico.yaml

####If you are setting up worker nodes, copy the join command you got after inializing the cluster and run on each node.

#Copy the "/.kube" folder to your worker nodes. That will enable you to run "kubectl" commands from your worker nodes.    
    #scp -r $HOME/.kube gary@192.168.0.23:/home/gary

#Get cluster info
kubectl cluster-info

#If you have a single Kubernetes node (only master), untaint it so you can schedule PODS on it
kubectl taint node kube-master node-role.kubernetes.io/master-

#View nodes
kubectl get nodes -o wide

#List the virtual server table 
sudo ipvsadm -L

#Schedule a Kubernetes deployment using a container from Google samples
kubectl create deployment hello-world --image=gcr.io/google-samples/hello-app:1.0

#View all Kubernetes deployments
kubectl get deployments

kubectl expose deployment hello-world --port=8090 --target-port=8080 

kubectl get services

kubectl get pods -o wide

#List the virtual server table
sudo ipvsadm -L

kubectl scale --replicas=4 deployment/hello-world

#List the virtual server table
sudo ipvsadm -L
