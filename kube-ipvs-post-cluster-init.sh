#Edit "kube-proxy" ConfigMap and set  'mode: "ipvs"'. 
#To change the IPVS load balancing algorithm, set the 
#"scheduler" under "ipvs" to one of the following, "" uses round robin:
    #rr: round-robin
    # lc: least connection
    # dh: destination hashing
    # sh: source hashing
    # sed: shortest expected delay
    # nq: never queue
#"shift-i" enters insert mode, "escape" exists, "sfit:" followed by "wq" saves it
kubectl edit configmap kube-proxy -n kube-system

#Get the kube-proxy bane and delete it so the above chnage can take place
KUBE_POXY_POD_NAME=$(kubectl get pods -no-headers -n kube-system | awk '{ print $1}' | grep kube-proxy)
echo $KUBE_POXY_POD_NAME
kubectl delete pod $KUBE_POXY_POD_NAME -n kube-system

#Verify that that kube-proxy switched to "ipvs" mode.
KUBE_POXY_POD_NAME=$(kubectl get pods -no-headers -n kube-system | awk '{ print $1}' | grep kube-proxy)
echo $KUBE_POXY_POD_NAME
kubectl logs $KUBE_POXY_POD_NAME -n kube-system | grep "Using ipvs Proxier"


#List 
sudo ipvsadm -L

#Schedule a Kubernetes deployment using a container from Google samples
kubectl create deployment hello-world --image=gcr.io/google-samples/hello-app:1.0

#View all Kubernetes deployments
kubectl get deployments

#Get pod info
kubectl get pods -o wide

kubectl expose deployment hello-world --port=8080 --target-port=8080 --type=NodePort
sudo ipvsadm -L



#*********************************************************************************************************************************
scp gary@192.168.0.22:/home/gary/tests/video-21/*.* /C:\Users\grost\OneDrive\YouTube-Channel\Video-21-Kube-IPVS\scripts
scp gary@192.168.0.10:/C:/Users/grost/OneDrive/YouTube-Channel/Video-21-Kube-IPVS/scripts/*.* /home/gary

sudo apt install openssh-server