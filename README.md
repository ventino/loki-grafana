

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
this should create automatically an VM called devmachine, which can be accessed over ssh:

```
ssh -q sysop@loki-grafana
```



