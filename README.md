

This is an loki stack installed on microk8s.

## Prerequisites:

To run the VM with terraform, the host must have libvirt installed and terraform should have libvirt provider installed.

https://github.com/dmacvicar/terraform-provider-libvirt

Also, the host should have the primary network interface configured as bridge. If using a desktop version of linux, the NetworkManager is not able to configure bridge networks from UI, so the config files must be edited manually or the commnad line interface, nmcli, must be used.

https://www.answertopia.com/ubuntu/creating-an-ubuntu-kvm-networked-bridge-interface/

https://www.tecmint.com/create-network-bridge-in-ubuntu/

Nice to have, but not mandatory, would be to allocate from router a fixed IP address to the VM. Use "mac_address" variable in terraform to change the MAC address for the VM and setup the router DHCP to reserve an IP and for that address. 



## Example tfvars:

```
hostname    = "loki-grafana"
cloud_image = "/home/mihai/images/hirsute-server-cloudimg-amd64.img"
dev_ssh_id  = "gh:mihaics"
os_user     = "sysop"
```

## Usage: 
If all is set, run

```
terraform init
terraform plan
terraform apply
```
this should create automatically an VM called loki-grafana, which can be accessed over ssh:

```
ssh -q sysop@loki-grafana
```


To locally install minio for tests:

```
helm repo add minio https://charts.min.io/
helm repo update
helm --kubeconfig $HOME/.kube/config upgrade --install minio minio/minio --set accessKey=loki,secretKey=lokisecret,persistence.storageClass=openebs-hostpath,mode=standalone,replicas=1,resources.requests.memory=500Mi --namespace minio --create-namespace

```

To access MinIO from localhost, run the below commands:

  1. export POD_NAME=$(kubectl get pods --namespace minio -l "release=minio" -o jsonpath="{.items[0].metadata.name}")

  2. kubectl port-forward $POD_NAME 9000 --namespace minio

Read more about port forwarding here: http://kubernetes.io/docs/user-guide/kubectl/kubectl_port-forward/

You can now access MinIO server on http://localhost:9000. Follow the below steps to connect to MinIO server with mc client:

  1. Download the MinIO mc client - https://docs.minio.io/docs/minio-client-quickstart-guide

  2. export MC_HOST_minio_local=http://$(kubectl get secret --namespace minio minio -o jsonpath="{.data.rootUser}" | base64 --decode):$(kubectl get secret --namespace minio minio -o jsonpath="{.data.rootPassword}" | base64 --decode)@localhost:9000

  3. mc ls minio_local://


