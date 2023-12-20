resource "opennebula_virtual_machine" "default" {
  count = 2

  name        = "virtual-machine-${count.index}"
  description = "Mquina virtual creada amb Terraform"
  cpu         = 0.5
  vcpu        = 2
  memory      = 1024
  permissions = "600"


  graphics {
    type   = "VNC"
    listen = "0.0.0.0"
    keymap = "es"
  }
  os {
    arch = "x86_64"
    boot = "disk0"
  }

  disk {
    image_id = data.opennebula_image.default.id
    size     = 20000
    target   = "vda"
    driver   = "qcow2"
  }

#  on_disk_change = "RECREATE"

  nic {
    model           = "virtio"
    network_id      = data.opennebula_virtual_network.default.id
    security_groups = [data.opennebula_security_group.default.id]
  }

  template_id = data.opennebula_template.default.id
  
}

data "opennebula_image" "default" {
  name = "Ubuntu22.04+openssh-server"
}

data "opennebula_virtual_network" "default" {
  name = "Internet"
}

data "opennebula_security_group" "default" {
  name = "default"
}

data "opennebula_template" "default" {
  name = "Ubu22.04v1.4-GIxPD"
}

resource "local_file" "inventari" {
  content = templatefile("${path.module}/inventari.tpl", {
  vm_ips = opennebula_virtual_machine.mv[*].nic[0].computed_ip})
  
  filename = "${path.module}/hosts"
  
  depends_on = [opennebula_virtual_machine.mv]
}
