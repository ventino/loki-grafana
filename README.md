

This is a generic VM module, docker enabled, which needs a file called terraform.tfvars to be filled.

## Prerequisites:

To run the VM with terraform, the host must have libvirt installed and terraform should have libvirt provider installed.

https://github.com/dmacvicar/terraform-provider-libvirt

Also, the host should have the primary network interface configured as bridge. If using a desktop version of linux, the NetworkManager is not able to configure bridge networks from UI, so the config files must be edited manually or the commnad line interface, nmcli, must be used.

https://www.answertopia.com/ubuntu/creating-an-ubuntu-kvm-networked-bridge-interface/

https://www.tecmint.com/create-network-bridge-in-ubuntu/

Nice to have, but not mandatory, would be to allocate from router a fixed IP address to the VM. Use "mac_address" variable in terraform to change the MAC address for the VM and setup the router DHCP to reserve an IP and for that address. 



## Example tfvars:

```
hostname = "devmachine"
cloud_image = "/home/sysop/Downloads/groovy-server-cloudimg-amd64.img"
mac_address = "AA:BB:CC:11:24:24"
```

## Usage: 
If all is set, run

```
terraform init
terraform plan
terraform apply
```
this should create automatically an VM called devmachine, which can be accessed over ssh:

```
ssh -q bitwarpers@devmachine
```



## Example script to access the kubernetes dashboard:

```
 
cat <<EOF | microk8s kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kube-system
EOF


cat <<EOF | microk8s kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kube-system
EOF




microk8s kubectl -n kube-system get secret $(microk8s kubectl -n kube-system get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}";echo 


microk8s kubectl port-forward -n kube-system service/kubernetes-dashboard --address 0.0.0.0 10443:443
```

