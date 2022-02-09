#main disk volume
resource "libvirt_volume" "baseimage" {
  provider = libvirt
  name     = "${var.hostname}-baseimage.qcow2"
  pool     = "default"
  source   = var.cloud_image
  format   = "qcow2"
}

#cloud_init data definitions
data "template_file" "cloud_init" {
  template = file("${path.module}/templates/cloud_init.cfg")
  vars = {
    os_user      = var.os_user
    root_ssh_key = var.root_ssh_key
    dev_ssh_id   = var.dev_ssh_id
  }
}

#cloud_init network definitions
data "template_file" "network_config" {
  template = file("${path.module}/templates/network_config.cfg")
}

#cloud_init metadata definitions
data "template_file" "meta_data" {
  template = file("${path.module}/templates/meta_data.cfg")
  vars = {
    hostname = var.hostname
  }
}

#cloud_init resource disk
resource "libvirt_cloudinit_disk" "commoninit" {
  provider       = libvirt
  name           = "${var.hostname}-commoninit.iso"
  user_data      = data.template_file.cloud_init.rendered
  network_config = data.template_file.network_config.rendered
  meta_data      = data.template_file.meta_data.rendered
  pool           = "default"
}


resource "libvirt_domain" "vm-domain" {
  provider   = libvirt
  name       = var.hostname
  memory     = var.domain_memory
  vcpu       = var.domain_vcpu
  cloudinit  = libvirt_cloudinit_disk.commoninit.id
  autostart  = true
  qemu_agent = true



  network_interface {
    network_id = libvirt_network.loki_net.id
    hostname   = var.hostname
    addresses  = [var.ip_addr]
  }

  # IMPORTANT: this is a known bug on cloud images, since they expect a console
  # we need to pass it
  # https://bugs.launchpad.net/cloud-images/+bug/1573095
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.baseimage.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }


}



resource "libvirt_network" "loki_net" {
  # the name used by libvirt
  name = "lokinet"

  # mode can be: "nat" (default), "none", "route", "open", "bridge"
  mode = "nat"

  #  the domain used by the DNS server in this network
  #domain = "lan"

  #  list of subnets the addresses allowed for domains connected
  # also derived to define the host addresses
  # also derived to define the addresses served by the DHCP server
  addresses = ["192.168.24.0/24"]

  # (optional) the bridge device defines the name of a bridge device
  # which will be used to construct the virtual network.
  # (only necessary in "bridge" mode)
  bridge = "lokibr01"

  # (optional) the MTU for the network. If not supplied, the underlying device's
  # default is used (usually 1500)
  # mtu = 9000

  # (Optional) DNS configuration
  dns {
    # (Optional, default false)
    # Set to true, if no other option is specified and you still want to 
    # enable dns.
    enabled = true
    # (Optional, default false)
    # true: DNS requests under this domain will only be resolved by the
    # virtual network's own DNS server
    # false: Unresolved requests will be forwarded to the host's
    # upstream DNS server if the virtual network's DNS server does not
    # have an answer.
    local_only = true

    # (Optional) one or more DNS forwarder entries.  One or both of
    # "address" and "domain" must be specified.  The format is:
    # forwarders {
    #     address = "my address"
    #     domain = "my domain"
    #  } 
    # 

    # (Optional) one or more DNS host entries.  Both of
    # "ip" and "hostname" must be specified.  The format is:
    # hosts  {
    #     hostname = "my_hostname"
    #     ip = "my.ip.address.1"
    #   }
    # hosts {
    #     hostname = "my_hostname"
    #     ip = "my.ip.address.2"
    #   }
    # 

    # (Optional) one or more static routes.
    # "cidr" and "gateway" must be specified. The format is:
    # routes {
    #     cidr = "10.17.0.0/16"
    #     gateway = "10.18.0.2"
    #   }
  }

  # (Optional) Dnsmasq options configuration
  dnsmasq_options {
    # (Optional) one or more option entries.  Both of
    # "option_name" and "option_value" must be specified.  The format is:
    # options  {
    #     option_name = "server"
    #     option_value = "/base.domain/my.ip.address.1"
    #   }
    # options {
    #     option_name = "address"
    #     ip = "/.api.base.domain/my.ip.address.2"
    #   }
    #
  }

}