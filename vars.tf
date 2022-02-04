#Local provider related variables

variable "qemu_uri" {
  description = "URI to connect with the qemu-service."
  default     = "qemu:///system"
}

variable "domain_memory" {
  default = "12288"
}

variable "domain_vcpu" {
  default = "6"
}

variable "cloud_image" {
  description = "Image Source"
  default     = "https://cloud-images.ubuntu.com/hirsute/current/hirsute-server-cloudimg-amd64.img"
}


variable "hostname" {
  description = "host name"
  default     = "devmachine"
}


variable "network" {
  description = "Name of Libvirt Network"
  default     = "default"
}


variable "os_codename" {
  description = "OS codename"
  default     = "groovy"
}

#variable "docker-auth-token" {}

variable "os_user" {
  description = "default user for login"
  default     = "bitwarpers"
}


variable "root_ssh_key" {
  description = "Public key which will be added to .ssh/authorized_keys for root user"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq6cUeVqUAZ7ln2qFxLwpYcM8u1J20upM6VGmv4HxNTi9yl1sOfGr/9fodVVBFquk25bhiUzBAA41GuKVpXzroZU4QBp6roUqvJVavwtG6VNZB+F8SEa4puLJ4cf3gqgTiuyIeSx5S19weke0ktoj6o+b1L84Eoa9pBh1LuWdO4f0jbRy4deFpm8VIVRGjLG58NKVTrNvGKThZG+O3qPtoetlRS1Z3JXVVea0nFBdPZxj9F03YGeGKOC8YDL6XXbuO+lKXWEyUxt6kW6Hlb2XQwrkkABmIUHq4r8pnmZilfpuTB8B4Vtwj4ZX+5y6DoE9oLVXOLW/AP1As/DKC8ixZQ== mihai@i5737z.sysop-consulting.ro"
}

variable "dev_ssh_id" {
  description = "id used to import ssh keys for developer access, github or other"
  default     = "gh:mihaics"
}

variable "ip_addr" {
  description = "machine ip address on libvirt netwiork"
  default     = "192.168.122.100"
}