# This file has been written with the following clean up scripts in mind
# https://github.com/vmware-samples/packer-examples-for-vsphere/blob/main/scripts/linux/ubuntu-server-2x.sh
# https://github.com/kalenarndt/packer-vsphere-cloud-init/blob/master/scripts/ubuntu/20/ubuntu-20-cloud-init.sh
echo '> Creating cleanup script ...'
sudo cat <<EOF > /var/tmp/cleanup.sh
#!/bin/bash

# Cleans /tmp directories.
echo '> Cleaning /tmp directories ...'
rm -rf /tmp/*
#rm -rf /var/tmp/*

### Clean apt cache. ###
echo '> Cleaning apt cache ...'
apt-get autoremove -y
apt-get clean -y

### Clean the machine-id. ###
echo '> Cleaning the machine-id ...'
truncate -s 0 /etc/machine-id
rm /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id

### Prepare cloud-init ###
# echo '> Preparing cloud-init ...'
# rm -rf /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg
# rm -rf /etc/cloud/cloud.cfg.d/99-installer.cfg
# rm -rf /etc/netplan/00-installer-config.yaml
# echo "disable_vmware_customization: false" >> /etc/cloud/cloud.cfg
# echo "datasource_list: [ VMware, OVF, None ]" > /etc/cloud/cloud.cfg.d/90_dpkg.cfg
# Uncomment below if guest customization will be performed by VMware Tools.
# touch /etc/cloud/cloud.cfg.d/99.disable-network-config.cfg
# echo "network: {config: disabled}" >> /etc/cloud/cloud.cfg.d/99.disable-network-config.cfg/

# Disable Cloud Init
touch /etc/cloud/cloud-init.disabled

### Modify GRUB ###
echo '> Modifying GRUB ...'
sed -i -e "s/GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\"/" /etc/default/grub
update-grub
EOF

### Change script permissions for execution. ###
echo '> Changing script permissions for execution ...'
sudo chmod +x /var/tmp/cleanup.sh

### Executes the cleauup script. ###
echo '> Executing the cleanup script ...'
sudo /var/tmp/cleanup.sh

### All done. ###
echo '> Done.'

