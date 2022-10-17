source "vsphere-iso" "vsphere-k8s-environment" {
  CPUs             = var.num_cpus
  RAM              = var.vm_memory
  RAM_reserve_all  = true
  boot_wait        = "5s"
  /* The single quotes around the ds=nocloud are important! */
  boot_command     = [
    "<enter><enter><f6><esc><wait> ",
    "linux /casper/vmlinuz 'ds=nocloud;s=/cidata/' autoinstall",
    "<enter><wait>",
  ]
  boot_order       = "cdrom,disk"
  cd_files         = ["./http/*"]
  cd_label         = "cidata"

  disk_controller_type   = ["pvscsi"]
  guest_os_type          = "ubuntu64Guest"
  host                   = var.vsphere_host
  insecure_connection    = true
  iso_url                = var.iso_url
  iso_checksum           = var.iso_checksum
  ssh_username           = var.ssh_username
  ssh_password           = var.ssh_password
  ssh_host               = var.ssh_host
  ssh_timeout            = "20m"
  ssh_handshake_attempts = "100"
  ssh_pty                = true
  convert_to_template    = true

  storage {
    disk_size             = var.vm_disk_size
    disk_thin_provisioned = true
  }

  network_adapters {
    network      = var.vm_network
    network_card = var.vm_network_card
  }

  username       = var.vsphere_username
  password       = var.vsphere_password
  vcenter_server = var.vsphere_vcenter_server
  datacenter     = var.vsphere_datacenter
  datastore      = var.vsphere_datastore
  cluster        = var.vsphere_cluster
  folder         = var.vsphere_folder
  vm_name        = var.vm_name
}

build {
  sources = [
    "sources.vsphere-iso.vsphere-k8s-environment",
  ]

  provisioner "file" {
    source      = "./files/ansible"
    destination = "/var/tmp/ansible"
  }

  provisioner "shell" {
    remote_folder = "/var/tmp"
    script = "./scripts/hardening.sh"
  }

  # provisioner "file" {
  #   source      = "./scripts/hardening_cleanup.sh"
  #   destination = "/var/tmp/"
  # }

  # provisioner "shell" {
  #   remote_folder = "/var/tmp"
  #   expect_disconnect = true
  #   inline = [
  #     "sudo bash /var/tmp/hardening_cleanup.sh"
  #   ]
  # }

  provisioner "file" {
    source      = "./files/k8s-sysctl.conf"
    destination = "/var/tmp/k8s.conf"
  }

  provisioner "file" {
    source      = "./files/60-rke2-cis.conf"
    destination = "/var/tmp/60-rke2-cis.conf"
  }

  provisioner "file" {
    source      = "./files/linux.conf"
    destination = "/var/tmp/linux.conf"
  }

  provisioner "shell" {
    remote_folder = "/var/tmp"
    inline = ["sudo cp /var/tmp/linux.conf /etc/sysctl.d/linux.conf"]
  }

  provisioner "shell" {
    remote_folder = "/var/tmp"
    script = "./scripts/prepare-rke2.sh"
  }

  //Openfile limit
  provisioner "shell" {
    remote_folder = "/var/tmp"
    environment_vars = [
      "OPEN_FILE_LIMIT=${var.open_file_limit}",
    ]
    script = "./scripts/filelimit.sh"
  }

  //Log rotate config
  provisioner "shell" {
    remote_folder = "/var/tmp"
    script = "./scripts/logrotate.sh"
  }

  provisioner "shell" {
    remote_folder = "/var/tmp"
    script = "./scripts/timezoneconfig.sh"
  }

  provisioner "file" {
    source      = "./files/cert"
    destination = "/var/tmp/cert"
  }

  provisioner "shell" {
    remote_folder = "/var/tmp"
    inline = ["sudo cp /var/tmp/cert/* /usr/local/share/ca-certificates/"]
  }

  provisioner "shell" {
    remote_folder = "/var/tmp"
    inline = ["sudo update-ca-certificates"]
  }

# Note: This step is not required for vSphere 6.7 U3 and later.
# https://kb.vmware.com/s/article/59687
 provisioner "shell" {
   remote_folder = "/var/tmp"
   script = "./scripts/dbus.sh"
 }

  #provisioner "shell" {
  #  remote_folder = "/var/tmp"
  #  script = "./scripts/ntp.sh"
  #}

  provisioner "shell" {
    remote_folder = "/var/tmp"
    script = "./scripts/modprobe.sh"
  }

  provisioner "shell" {
    remote_folder = "/var/tmp"
    script = "./scripts/hugepage.sh"
  }

  provisioner "shell" {
    remote_folder = "/var/tmp"
    expect_disconnect = true
    script = "./scripts/ufw.sh"
  }

  provisioner "file" {
    source      = "./files/fimlinux/"
    destination = "/var/tmp"
  }

  provisioner "file" {
    source      = "./files/solar/"
    destination = "/var/tmp"
  }

  provisioner "shell" {
    remote_folder = "/var/tmp"
    expect_disconnect = true
    inline = [
      "sudo chmod +x /var/tmp/agent64-linux-ubuntu20.bin",
      "sudo /var/tmp/agent64-linux-ubuntu20.bin -silent -prefix=/opt/Symantec -server= -cert=/var/tmp/agent-cert.ssl -agentport=443 secGrp=PCI-DSSkl"
    ]
  }

  provisioner "shell" {
    remote_folder = "/var/tmp"
    expect_disconnect = true
    inline = [
      "sudo chmod +x /var/tmp/install.sh",
      "cd /var/tmp && sudo sh install.sh"
    ]
  }

    provisioner "shell" {
    remote_folder = "/var/tmp"
    script = "./scripts/cleanup.sh"
  }

  post-processor "manifest"  {
    output = "manifest.json"
  }
}
