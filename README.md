## Packer Image Creation
This repo creates a golden image that can later be used to clone VMs.

## Usage
Edit the variables under `vars/vsphere.pkvars.hcl`.

|  Option | Type |Default  | Description |
|---|---|---| ---|
|  vsphere_vcenter_server |  string |  | |
|  vsphere_username |  string | - | |
|  vsphere_password |  string | - | |
|  vsphere_host | string  |  |  |
|  vsphere_datastore |  string |  | |
|  vsphere_datacenter |  string |  |  |
|  vsphere_cluster | string  |  | |
|  vsphere_folder |  string |  | |
|  ssh_host |  string |  | |
|  ssh_username |  string | - | |
|  ssh_password |  string  | -  | |
|  vm_name |  string  |   | |
|  vm_network |  string  |   | |
|  vm_network_card |  string  |   | |
|  vm_memory |  number  | 4096  | |
|  vm_disk_size |  number  | 327680  | |
|  num_cpus |  number  | 2  | |
|  open_file_limit |  string  | 1024000  | |
|  iso_url |  string  | https://releases.ubuntu.com/20.04/ubuntu-20.04.4-live-server-amd64.iso  | |

### INIT

```
packer init . 
```

### VALIDATE

```
packer validate --vars-file=vars/vsphere.pkrvars.hcl .
```

### BUILD

```
packer build --var-file=vars/vsphere.pkrvars.hcl .
```

## Configuration

### Kernel parameters
The kernel parameters that will be used for RKE2 and Kubernetes can be found in `files`. Any additional parameters should be added there. Recommended way is to add additional parameters inside `k8s-sysctl.conf` since this file is copied to `/etc/sysctl.d/k8s.conf` for persistent loading.

### cloud-init
Network settings and any users that should be created for the OS can be set inside `http/user-data`. This file is used as part of the cloud-init process and this config is used for the template creation.

```
autoinstall
  identity:
    hostname: ubuntu
    username: ''
    password: ''
  keyboard:
    layout: tr
    variant: tr
  network:
    version: 2
    renderer: networkd
    ethernets:
      ens192:
        dhcp4: true
        addresses:
          - 
        gateway4: 
        nameservers:
          addresses: []
          search:
            - 
  late-commands:
    - 'sed -i "s/dhcp4: true/&\n      dhcp-identifier: mac/" /target/etc/netplan/00-installer-config.yaml'
    - echo 'appsys ALL=(ALL) NOPASSWD:ALL' > /target/etc/sudoers.d/appsys
```

**NOTE:** Password for the users can be generated with the `mkpasswd -m sha512crypt` command.

### Scripts
* `ansible`script runs [ubuntu2004_cis](https://github.com/akkoc16/ubuntu2004_cis) playbook that is used for Security Hardening. 

* `cleanup` and `dbus` scripts should not be modified. They are responsible for disabling `cloud-init` and fixing VMware specific bugs.

* `filelimit` sets file limits more suitable for production workloads.

* `hugepage` script 

* `logrotate` configures how the container logs should be rotated.

* `modprobe` script adds specific kernel modules.

* `prepare-rke2` script copies the kernel configuration to */etc/sysctl.d* for persistence and adds an etcd user which is a requirement for CIS1.6

* `timezoneconfig` is responsible for setting the correct timezone configuration.

* `ufw` script 


